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
// A trial that ran to the end with every test green, to vary from.
const trial = (over = {}) => ({
  dir: 'tasks/csv_run_1', session_id: 'sid', steps: 10, elapsed: 1,
  tool_call_stats: {}, tool_calls: [],
  test_result: { exit_code: 0, total: 120, passed: 120, failed: 0 },
  check_result: { exit_code: 0, warnings: 0, errors: 0 },
  stop_reason: { kind: 'finished', message: '' },
  ...over,
});
const killed = (over = {}) => trial({
  steps: 0,
  test_result: { exit_code: 1, total: 120, passed: 0, failed: 120 },
  stop_reason: { kind: 'failed', message: 'agent failed: deepseek client' },
  ...over,
});

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

test('a trial the harness killed is not in any denominator', () => {
  const dead = toPoint({ ...record, runs: [killed(), killed(), killed()] });
  assert.equal(dead.trials, 3);
  assert.equal(dead.k, 0);
  // A gap, not a zero: nothing about the agent was observed on this day.
  assert.equal(dead.passRate, null);
  assert.equal(dead.avgSteps, null);

  const mixed = toPoint({ ...record, runs: [killed(), killed(), trial({ steps: 50 })] });
  assert.equal(mixed.k, 1);
  assert.equal(mixed.passRate, 1);
  assert.equal(mixed.avgSteps, 50);
});

test('a killed trial whose tests all pass still counts', () => {
  const p = toPoint({
    ...record,
    runs: [trial({ steps: 60, stop_reason: { kind: 'failed', message: 'agent failed' } })],
  });
  assert.equal(p.k, 1);
  assert.equal(p.passed, 1);
  assert.equal(p.passRate, 1);
  assert.equal(p.avgSteps, 60);
});

test('tool calls count wherever they happened; no calls is a gap', () => {
  assert.equal(toPoint({ ...record, runs: [trial()] }).toolRate, null);
  const p = toPoint({
    ...record,
    runs: [killed({ tool_call_stats: { mbtx: { passed: 3, failed: 1 } } })],
  });
  assert.equal(p.k, 0);
  assert.equal(p.passRate, null);
  assert.equal(p.toolCalls, 4);
  assert.equal(p.toolRate, 0.75);
});

test('the tool selector leads with volume and drops names that never worked', () => {
  const card = new TaskCard('csv', [{
    ...record,
    runs: [trial({ tool_call_stats: {
      plan: { passed: 2, failed: 0 },
      mbtx: { passed: 40, failed: 10 },
      read_image: { passed: 0, failed: 5 },
      mbTx: { passed: 0, failed: 1 },
    } })],
  }]);
  assert.deepEqual(Array.from(card.tools), ['mbtx', 'plan']);
  assert.deepEqual(Array.from(card.rejected), ['read_image (5)', 'mbTx (1)']);
});

test('a single measurement carries no trend', () => {
  assert.equal(new TaskCard('lua', [record]).trended, false);
  assert.equal(new TaskCard('csv', [record, { ...record, run: '43' }]).trended, true);
});

test('viewer filenames retain historical formats and isolate platforms', () => {
  assert.equal(viewerName(toPoint({ ...record, run: undefined }), 'csv'), 'bench-2026-09-17-csv.html');
  assert.equal(viewerName(toPoint(record), 'csv'), 'bench-2026-09-17-42-csv.html');
  for (const [os, target] of [['linux', 'native'], ['linux', 'wasm'], ['windows', 'native']]) {
    assert.equal(viewerName(toPoint({ ...record, os, target }), 'csv'),
      `bench-2026-09-17-42-${os}-${target}-csv.html`);
  }
});
