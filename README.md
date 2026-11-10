# SWE-AGI for SeekMoon

This repository holds a updated version of the
[SWE-AGI](https://github.com/moonbitlang/SWE-AGI) and the workflows that run
the benchmark on a schedule. The run artifacts (`run-dir`s) will be stored as
github artifacts

## What runs when

Three schedules, because the expensive part and the fragile part are not the
same part.

| workflow | when | what | cost |
| --- | --- | --- | --- |
| `bench` (full) | Saturdays 18:00 UTC+8 | 5 tasks × 3 platforms × 3 trials — 15 jobs, 45 agent trials | ~72 CNY |
| `bench` (canary) | the other six nights, same hour | ini on Windows/native, 3 trials | ~4 CNY |
| `smoke` | every night, an hour earlier | build, package and execute the agent on all 3 platforms | free |

About 14 CNY a day in all. The full matrix used to run nightly, at ~2150 CNY
a month, and that bought a resolution the data does not support: nine trials
estimate a task's failure rate to within roughly ±14 points, so a single
night says almost nothing and the signal lives in the trend. Spending the
same money across seven nights bought seven noisy points where one would do.

The canary is the one cell worth paying for daily: ini has the highest
failure rate of the five tasks (21.7% of finished trials, 2026-09-17 to
2026-11-03) and Windows/native the highest of the three platforms (9.2%,
about twice either Linux row, Fisher p=0.002). It keeps ini at 27 trials a
week rather than 9, and it puts a real agent call on the account every night,
which is its own kind of check.

`smoke` exists because most of what breaks is not the agent. `bench` spends
money only in its *Run the agent* step; the toolchain install, the per-target
build, the staging of the installed artifact and `check-bundle.mjs` — which
executes the staged agent against a local fake model server — are all local,
and Actions is free on public repositories. Left to the weekly run alone, a
broken `moon update` or a MoonBit release would surface up to seven days late
*and* cost that week its only data point. So that half still runs nightly, at
no cost, and shares one composite action
(`.github/actions/build-agent`) with `bench` so the two cannot drift. When a
weekly run comes back red, read `smoke` first.

Each scheduled run checks the DeepSeek balance before starting anything: 85
CNY for a full matrix, 10 for a canary — that shape's own cost plus headroom.
Below it the run fails before any job starts and reports nothing, because a
balance that runs out mid-run kills every attempt on HTTP 402 at once, buys no
result with the money already spent, and would still commit a 0/N day to the
dashboard. Keep the floor tied to the measured cost: a round number that
drifts above a top-up's residue takes the benchmark dark, which is what 100
CNY did from 2026-11-04 to 2026-11-10 on a balance of 97.84.

Saturday is off-peak all day at DeepSeek (peak is 01:00–04:00 and 06:00–10:00
UTC, Monday to Friday), so the full matrix is no longer balanced on the edge
of the discount window the way a 10:00 UTC daily cron was. Moving either cron
earlier into a weekday morning doubles the bill.

## Benchmark platforms

A full run benchmarks the OpenSeek agent on Linux/native, Linux/wasm, and
Windows/native, each with five tasks (csv, ini, uri, toml, hpack) and three
trials per task. `tasks/protobuf` is kept for manual runs but left out of the
matrix, since it has stopped producing failures: 228 of 228 trials passed
between 2026-09-17 and 2026-10-30.

The target selects how the **agent** is compiled and run. Task code keeps its
own configured target, and the grader runs on wasm on every platform. Windows
uses MSVC for native builds and Git Bash for the workflow commands.

Stats include `os` and `target`, and each task has one dashboard card comparing
platforms on shared charts: agent pass rate, tool-call pass rate and average
steps, all shown by default and each collapsible independently.

The denominator is the part worth knowing. A trial that the harness killed
before it ended — 613 of the 2214 trials recorded so far, 447 of them at step
0, nearly all of them one DeepSeek client error — never got its chance, so it
is dropped from the pass-rate and step averages rather than scored as a
failure, and a column with no surviving trial is a gap instead of a zero.
Counting those trials is what put a quarter of the page under DeepSeek's
uptime: pass@k reads 69% over every recorded trial and 93% over the measured
ones, 2026-10-12 drew a spike to zero on every series, and 2026-11-03 — the
full matrix that died whole on HTTP 402, which is the run the balance gate
above exists to prevent — read as every task regressing to nothing. A killed
trial still counts when all its tests had gone green, since the agent had
already finished by then; that only ever shrinks a denominator and never adds
a pass. Dropping an unknown outcome cannot lower a rate, so every tooltip
names how many trials it divided by, and a card opens on its newest column
that measured something rather than on its newest column.

There is no "average tests passed" chart. It tracked pass@k at r=0.925 while
claiming a partial credit that barely exists — of 667 failing trials, 534
scored about zero because nothing compiled and 124 scored above 95%, leaving 9
in the band the chart was for — and `moon test` runs in the run directory, so
its total counts the tests the agent wrote itself: 705 to 2119 on toml, which
lets a trial failing one spec test present as 99.9%. The per-trial `passed/total`
stays in the run table, where it is a fact about that trial rather than an
average across trials. A real partial-credit metric needs the grader to record
the task's own test results apart from the agent's.

A tool-name selector chooses one tool-call chart, with a line for each platform
and success rates weighted by call count across trials. It is ordered by call
volume and carries each tool's count, so `mbtx` — 57% of all calls — comes
first. A name that has never once succeeded is left out and listed under the
selector instead: either a name the harness rejected (`mbTx` for `mbtx`,
`mutli_edit`, `moon_check`; 36 calls across the whole history) or a tool that
does not work here at all, which is `read_image`. Changing the tool preserves
the selected workflow run. Run details list all measured platforms together in
one table with a platform column: three trials on each of three platforms
produce nine rows, and a canary night produces one. Trials the charts did not
divide by are marked `not measured` there. `moon check` errors are appended to
the warning count rather than given a column of their own, which was zeros in
2199 of 2214 rows. A task with a single measurement — `lua` and `url`, one
manual run each from 2026-09-01 — gets no charts at all, only its run details.
The “only show this tool in overview” toggle dims other tools in the run-detail
call strips, preserving call order and success/failure colors as the tool or run changes.
Viewer links remain specific to each platform. Missing measurements remain gaps in the charts
and do not produce run-detail rows — which is what a canary night looks like on
every series but ini/Windows. Historical records without platform fields
belong to Linux/native and retain their original session-viewer links.
Artifacts are named `runs-<os>-<target>-<task>` and
`stats-<os>-<target>-<task>` so parallel jobs never overwrite each other.

## Benchmarking a specific openseek commit

The scheduled runs always measure openseek's current `HEAD`. To measure some
other commit, dispatch the `bench` workflow manually and fill in
`openseek_ref` — a full 40-hex SHA, or a branch/tag name:

```
gh workflow run bench.yml -f openseek_ref=<sha-or-branch>
```

A dispatch runs the full matrix unless you ask for the cheap shape:

```
gh workflow run bench.yml -f mode=canary
```

Such a run is *ad-hoc*, but it reports like any other: its stats are committed
under `stats/`, the session viewers are published, and the dashboard is
redeployed with the new point on it. Each stats record carries the
`openseek_commit` it measured, so the point stays attributable.

The one thing an ad-hoc run does not do is move the `openseek` submodule pin.
That pin records which HEAD the timeline has reached, and a named ref — often
an older commit — would rewind it. A canary leaves it alone for the same
reason read the other way: it measured one cell of the matrix, not the matrix,
so it is not what the timeline reached.

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
