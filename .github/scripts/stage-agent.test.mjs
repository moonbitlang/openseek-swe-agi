import assert from "node:assert/strict";
import { mkdtemp, mkdir, readFile, rm, writeFile } from "node:fs/promises";
import { tmpdir } from "node:os";
import { join } from "node:path";
import test from "node:test";
import { artifactPath, stageAgent } from "./stage-agent.mjs";

test("Moon diagnostic records cannot become part of the artifact filename", () => {
  const artifact = join(tmpdir(), "path with spaces", "openseek.exe");
  const output = [
    { $message_type: "diagnostic", level: "warning", message: "deprecated syntax" },
    { artifacts_path: [artifact] },
    { $message_type: "diagnostic", level: "warning", message: "another warning" },
  ].map(JSON.stringify).join("\r\n") + "\r\n";
  assert.equal(artifactPath(output), artifact);
});

test("missing, ambiguous, malformed, and relative artifact records fail closed", () => {
  for (const output of ["", "{}", "not json", '{"artifacts_path":null}',
    '{"artifacts_path":[]}', '{"artifacts_path":["a","b"]}',
    '{"artifacts_path":[null]}', '{"artifacts_path":["relative.exe"]}',
    '{"artifacts_path":[]}\n{"artifacts_path":[]}']) {
    assert.throws(() => artifactPath(output));
  }
});

test("staging uses the measured revision's packager and replaces stale resources", async t => {
  const root = await mkdtemp(join(tmpdir(), "stage-agent-test-"));
  t.after(() => rm(root, { recursive: true, force: true }));
  const source = join(root, "source");
  const bundle = join(root, "bundle");
  const artifact = join(root, "engine.wasm");
  await writeFile(artifact, "wasm fixture");
  await mkdir(join(source, "desktop/package"), { recursive: true });
  await mkdir(join(source, "share/workflow"), { recursive: true });
  await writeFile(join(source, "share/workflow/read.mbtx"), "measured workflow");
  await writeFile(join(source, "desktop/package/resources.mjs"), `
    import { cp } from "node:fs/promises";
    export async function stageResources(source, destination) {
      await cp(source, destination, { recursive: true });
      return "hash-from-measured-packager";
    }
  `);
  await mkdir(join(bundle, "share"), { recursive: true });
  await writeFile(join(bundle, "share/stale"), "old snapshot");
  const result = await stageAgent(source, bundle, "wasm", JSON.stringify({ artifacts_path: [artifact] }));
  assert.equal(result.resourceHash, "hash-from-measured-packager");
  assert.equal(await readFile(result.agent, "utf8"), "wasm fixture");
  assert.equal(await readFile(join(result.share, "workflow/read.mbtx"), "utf8"), "measured workflow");
  await assert.rejects(readFile(join(result.share, "stale")), { code: "ENOENT" });
  await rm(join(source, "share"), { recursive: true });
  await assert.rejects(stageAgent(source, bundle, "wasm", JSON.stringify({ artifacts_path: [artifact] })),
    { code: "ENOENT" });
});

test("historical refs work without a packager; missing modern resources are fatal", async t => {
  const root = await mkdtemp(join(tmpdir(), "stage-agent-legacy-"));
  t.after(() => rm(root, { recursive: true, force: true }));
  const source = join(root, "source");
  const bundle = join(root, "bundle");
  const artifact = join(root, "engine.wasm");
  await writeFile(artifact, "wasm fixture");
  await mkdir(source);
  const output = JSON.stringify({ artifacts_path: [artifact] });
  assert.equal((await stageAgent(source, bundle, "wasm", output)).share, null);
  await mkdir(join(source, "share"));
  await writeFile(join(source, "share/legacy"), "legacy resource");
  const legacy = await stageAgent(source, bundle, "wasm", output);
  assert.equal(await readFile(join(legacy.share, "legacy"), "utf8"), "legacy resource");
  assert.equal(legacy.resourceHash, null);
  await rm(join(source, "share"), { recursive: true });
  await mkdir(join(source, "resources"));
  await assert.rejects(stageAgent(source, bundle, "wasm", output), /share directory is missing/);
});
