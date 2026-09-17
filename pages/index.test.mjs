import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import test from 'node:test';
import vm from 'node:vm';

// Load the page's actual model without starting network requests or rendering.
const html = readFileSync(new URL('./index.html', import.meta.url), 'utf8');
const source = html.match(/<script>([\s\S]*?)<\/script>/)[1].replace(/boot\(\);\s*$/, '');
const { TaskCard, toPoint, viewerName } = vm.runInNewContext(
  source + '\n({ TaskCard, toPoint, viewerName })',
);
const record = {
  task: 'csv', date: '2026-09-17', run: '42', openseek_commit: 'abc',
  passed: 0, runs: [],
};

test('one task aligns three platforms by workflow run, with gaps for missing data', () => {
  const card = new TaskCard('csv', [
    record,
    { ...record, os: 'linux', target: 'wasm' },
    { ...record, os: 'windows', target: 'native' },
    { ...record, run: '43' },
  ]);
  assert.equal(card.points.length, 2);
  assert.equal(card.points[0].platforms.size, 3);
  assert.equal(card.points[1].platforms.size, 1);
  assert.equal(card.points[1].platforms.get('linux/wasm'), undefined);
  assert.deepEqual(Array.from(card.series, s => s.label),
    ['linux/native', 'linux/wasm', 'windows/native']);
});

test('same-day runs and distinct measured commits remain separate', () => {
  const card = new TaskCard('csv', [
    { ...record, run: '100' },
    { ...record, run: '99' },
    { ...record, run: '100', openseek_commit: 'def', os: 'linux', target: 'wasm' },
  ]);
  assert.equal(card.points.length, 3);
  assert.equal(card.points[0].run, '99');
  assert.ok(card.points.every(point => point.platforms.size === 1));
});

test('platform jobs crossing UTC midnight share a workflow comparison column', () => {
  const card = new TaskCard('csv', [
    record,
    { ...record, date: '2026-09-18', os: 'windows', target: 'native' },
  ]);
  assert.equal(card.points.length, 1);
  assert.equal(card.points[0].date, '2026-09-17');
  assert.equal(card.points[0].platforms.get('windows/native').date, '2026-09-18');
});

test('multiple legacy measurements on one day are retained', () => {
  const card = new TaskCard('csv', [
    { ...record, run: undefined },
    { ...record, run: undefined },
    { ...record, run: undefined, os: 'linux', target: 'wasm' },
    { ...record, run: undefined, os: 'linux', target: 'wasm' },
  ]);
  assert.equal(card.points.length, 2);
  assert.ok(card.points.every(point => point.platforms.size === 2));
});

test('platform colors stay stable when a task has fewer platforms', () => {
  const partial = new TaskCard('csv', [{ ...record, os: 'windows', target: 'native' }]);
  const all = new TaskCard('csv', [record, { ...record, os: 'windows', target: 'native' }]);
  assert.equal(partial.series[0].color, all.series[1].color);
});

test('viewer filenames retain historical formats and isolate platforms', () => {
  assert.equal(viewerName(toPoint({ ...record, run: undefined }), 'csv'), 'bench-2026-09-17-csv.html');
  assert.equal(viewerName(toPoint(record), 'csv'), 'bench-2026-09-17-42-csv.html');
  for (const [os, target] of [['linux', 'native'], ['linux', 'wasm'], ['windows', 'native']]) {
    assert.equal(viewerName(toPoint({ ...record, os, target }), 'csv'),
      `bench-2026-09-17-42-${os}-${target}-csv.html`);
  }
});
