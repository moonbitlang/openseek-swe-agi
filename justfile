default:
    just --list

# Run the OpenSeek agent fleet on a task in tasks/, e.g. `just run csv`.
# Requires DEEPSEEK to be set; runs land in tasks/<task>_run_<i>.
run task *args:
    @test -n "${DEEPSEEK:-}" || { echo "DEEPSEEK is not set (export DEEPSEEK=sk-...)"; exit 1; }
    cd openseek && moon run --target native cmd/openseek -- run \
        --dir ../tasks/{{ task }} \
        --model deepseek-v4-flash \
        --max-steps 160 \
        {{ args }} \
        "$(cat ../tasks/{{ task }}/TASK.md)"

# Serve this repo's recorded sessions in the browser; flags pass through
# to the server (e.g. just inspect --port 8081).
inspect *args:
    cd openseek && moon build cmd/viz_app --target js
    cd openseek && moon run inspect -- --search-dir .. {{ args }}

# Grade a task's run directories (restores shipped tests, reruns moon test,
# mines the session logs) and print one JSON stats document.
grade task:
    moon run tools/grade -- {{ task }}
