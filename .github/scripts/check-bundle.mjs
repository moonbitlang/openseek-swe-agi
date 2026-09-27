import assert from "node:assert/strict";
import { spawn } from "node:child_process";
import { once } from "node:events";
import { mkdtemp, rm, stat, writeFile } from "node:fs/promises";
import { createServer } from "node:http";
import { tmpdir } from "node:os";
import { join } from "node:path";

// Exercise the installed engine's real @builtin resolver and workflow execution,
// without sending a request to a model or adding events to benchmark sessions.
if (!process.env.OPENSEEK_REFERENCES) {
  console.log("Skipping bundled workflow check for a historical ref without share/");
  process.exit(0);
}
// Decide compatibility from the source, never skip a broken installed copy.
try { await stat(join("openseek", "share/workflow/read.mbtx")); }
catch (error) {
  if (error.code !== "ENOENT") throw error;
  console.log("Skipping read workflow check for a historical ref without read.mbtx");
  process.exit(0);
}
const directory = await mkdtemp(join(tmpdir(), "openseek-bundle-check-"));
const marker = "BUNDLED-READ-SMOKE-OK";
await writeFile(join(directory, "sample.txt"), marker + "\n");
let requests = 0;
let failure;
const server = createServer(async (request, response) => {
  try {
    let body = "";
    for await (const chunk of request) body += chunk;
    const { messages } = JSON.parse(body);
    requests++;
    assert.ok(requests <= 2, "Unexpected extra model request");
    if (requests === 2) {
      const result = messages.findLast(message => message.role === "tool");
      assert.ok(result?.content.includes(`1 |${marker}`), `Bundled read failed: ${result?.content}`);
    }
    const name = requests === 1 ? "mbtx" : "finish";
    const args = requests === 1 ? { filename: "@builtin/read.mbtx", args: ["sample.txt"] } : { answer: marker };
    const delta = { tool_calls: [{ index: 0, id: `bundle-${requests}`, type: "function",
      function: { name, arguments: JSON.stringify(args) } }] };
    response.writeHead(200, { "Content-Type": "text/event-stream" });
    response.end(`data: ${JSON.stringify({ choices: [{ delta }] })}\n\ndata: [DONE]\n\n`);
  } catch (error) {
    failure = error;
    response.writeHead(500);
    response.end("Bundle smoke check failed");
  }
});
let child;
let output = "";
try {
  server.listen(0, "127.0.0.1");
  await once(server, "listening");
  const agent = process.env.OPENSEEK_AGENT;
  const wasm = process.env.BENCH_TARGET === "wasm";
  child = spawn(wasm ? "moonrun" : agent, [
    ...(wasm ? [agent, "--"] : []), "run", "--dir", directory,
    "--api-key", "bundle-smoke", "--model", "deepseek-v4-flash",
    "--api-url", `http://127.0.0.1:${server.address().port}/chat/completions`,
    "--max-steps", "2", "--mcp-config", "", "--no-session", "Read sample.txt, then finish.",
  ], { cwd: directory, env: { ...process.env, DEEPSEEK: "bundle-smoke", OPENSEEK_RETRY_ATTEMPTS: "1" },
    stdio: ["ignore", "pipe", "pipe"], timeout: 120_000, killSignal: "SIGKILL" });
  child.stdout.on("data", data => { output += data; });
  child.stderr.on("data", data => { output += data; });
  const [code] = await once(child, "close");
  if (failure) throw failure;
  assert.equal(code, 0, output);
  assert.equal(requests, 2, output);
  // The second request above already saw the read's output. run no longer
  // prints JSONL events, so there is nothing more to check on stdout.
  console.log("PASS: installed engine executes @builtin/read.mbtx from an unrelated working directory");
} finally {
  child?.kill("SIGKILL");
  server.closeAllConnections();
  server.close();
  await rm(directory, { recursive: true, force: true });
}
