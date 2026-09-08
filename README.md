# SWE-AGI for SeekMoon

This repository holds a updated version of the
[SWE-AGI](https://github.com/moonbitlang/SWE-AGI) and will contains the
workflow that runs the benchmark everyday. The run artifacts (`run-dir`s) will
be stored as github artifacts

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
