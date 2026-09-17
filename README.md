# SWE-AGI for SeekMoon

This repository holds a updated version of the
[SWE-AGI](https://github.com/moonbitlang/SWE-AGI) and will contains the
workflow that runs the benchmark everyday. The run artifacts (`run-dir`s) will
be stored as github artifacts

## Benchmark platforms

Both scheduled and manually dispatched runs benchmark the OpenSeek agent on
Linux/native, Linux/wasm, and Windows/native. Each combination runs all six
tasks (csv, ini, uri, toml, hpack, protobuf) with three trials per task: 18
jobs and 54 agent trials per workflow run.

The target selects how the **agent** is compiled and run. Task code keeps its
own configured target, and the grader runs on wasm on every platform. Windows
uses MSVC for native builds and Git Bash for the workflow commands.

Stats include `os` and `target`, and each task has one dashboard card comparing
platforms on shared charts. Agent, test, and tool-call pass rates and average
steps are all shown by default; each chart can be collapsed independently.
A platform selector controls run details and session-viewer links. Historical
records without those fields belong to Linux/native and retain their original
session-viewer links.
Artifacts are named `runs-<os>-<target>-<task>` and
`stats-<os>-<target>-<task>` so parallel jobs never overwrite each other.

## Benchmarking a specific openseek commit

The nightly run always measures openseek's current `HEAD`. To measure some
other commit, dispatch the `bench` workflow manually and fill in
`openseek_ref` — a full 40-hex SHA, or a branch/tag name:

```
gh workflow run bench.yml -f openseek_ref=<sha-or-branch>
```

Such a run is *ad-hoc*, but it reports like any other: its stats are committed
under `stats/`, the session viewers are published, and the dashboard is
redeployed with the new point on it. Each stats record carries the
`openseek_commit` it measured, so the point stays attributable.

The one thing an ad-hoc run does not do is move the `openseek` submodule pin.
That pin records which HEAD the timeline has reached, and a named ref — often
an older commit — would rewind it.

Dispatch from the default branch. Reporting commits to whichever ref the
workflow ran from and republishes the one repository-wide Pages site, so a run
launched from another branch or a tag benchmarks and uploads its artifacts but
reports nothing. `openseek_ref` is how you choose the commit under test; the
ref the workflow itself runs from is a separate thing.

Locally, the submodule is an ordinary checkout, so any commit works directly:

```
git -C openseek fetch origin <sha> && git -C openseek checkout <sha>
just run <task>    # needs DEEPSEEK
just grade <task>
```
