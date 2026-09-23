import { appendFile, chmod, cp, mkdir, readFile, rm, stat, writeFile } from "node:fs/promises";
import { isAbsolute, join, resolve } from "node:path";
import { pathToFileURL } from "node:url";

export function artifactPath(output) {
  // Moon emits diagnostics and the artifact record on the same JSONL stream.
  const records = output.split(/\r?\n/).filter(line => line.trim()).map(JSON.parse);
  const artifacts = records.filter(record => Object.hasOwn(record, "artifacts_path"));
  if (artifacts.length !== 1 || !Array.isArray(artifacts[0].artifacts_path) ||
      artifacts[0].artifacts_path.length !== 1) {
    throw new Error("Expected exactly one Moon artifact");
  }
  const [path] = artifacts[0].artifacts_path;
  if (typeof path !== "string" || !isAbsolute(path) || /[\r\n]/.test(path)) {
    throw new Error("Expected an absolute artifact filename without newlines");
  }
  return path;
}

async function exists(path) {
  try { await stat(path); return true; }
  catch (error) { if (error.code === "ENOENT") return false; throw error; }
}

export async function stageAgent(source, destination, target, output) {
  if (!["native", "wasm"].includes(target)) throw new Error(`Unsupported target: ${target}`);
  const artifact = artifactPath(output);
  if (!(await stat(artifact)).isFile()) throw new Error(`Not an executable file: ${artifact}`);
  await rm(destination, { recursive: true, force: true });
  await mkdir(join(destination, "bin"), { recursive: true });
  const suffix = target === "wasm" ? ".wasm" : process.platform === "win32" ? ".exe" : "";
  const agent = join(destination, "bin", `openseek${suffix}`);
  // Copy, rather than symlink: upstream resolves the real executable's ../share.
  await cp(artifact, agent);
  if (target === "native" && process.platform !== "win32") await chmod(agent, 0o755);
  let share = null;
  let resourceHash = null;
  const packager = join(source, "desktop/package/resources.mjs");
  if (await exists(packager)) {
    const { stageResources } = await import(pathToFileURL(packager).href);
    share = join(destination, "share");
    resourceHash = await stageResources(join(source, "share"), share);
  } else if (await exists(join(source, "share"))) {
    // Historical ad-hoc refs predate the upstream resource packager.
    share = join(destination, "share");
    await cp(join(source, "share"), share, { recursive: true });
  } else if (await exists(join(source, "resources"))) {
    throw new Error("OpenSeek has a resource resolver but its share directory is missing");
  }
  return { agent, share, resourceHash };
}

if (process.argv[1] && import.meta.url === pathToFileURL(resolve(process.argv[1])).href) {
  const [source, destination, target, log] = process.argv.slice(2);
  const bundle = await stageAgent(resolve(source), resolve(destination), target, await readFile(log, "utf8"));
  const manifest = { commit: process.env.OPENSEEK_COMMIT ?? null, target, ...bundle };
  await writeFile(join(destination, "bundle.json"), JSON.stringify(manifest, null, 2) + "\n");
  console.log(JSON.stringify(manifest, null, 2));
  if (process.env.GITHUB_ENV) {
    await appendFile(process.env.GITHUB_ENV, `OPENSEEK_AGENT=${bundle.agent}\n` +
      (bundle.share ? `OPENSEEK_REFERENCES=${bundle.share}\n` : ""));
  }
}
