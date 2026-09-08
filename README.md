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

Such a run is *ad-hoc*: it grades every task as usual and leaves the results
in the run summary plus the `combined-stats` / `runs-<task>` artifacts, but it
does not commit stats, move the `openseek` submodule pin, or redeploy the
dashboard — those record the HEAD timeline and a pinned ref is not part of it.

Locally, the submodule is an ordinary checkout, so any commit works directly:

```
git -C openseek fetch origin <sha> && git -C openseek checkout <sha>
just run <task>    # needs DEEPSEEK
just grade <task>
```
