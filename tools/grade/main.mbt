///|
const TestTimeoutMs : Int = 600_000

///|
async fn copy_glob(glob : String, dest : String) -> Unit {
  for file in @shell.glob(glob) {
    @shell.Cmd("cp", [file, dest]).run()
  }
}

///|
struct TestResult {
  exit_code : Int
  total : Int
  passed : Int
  failed : Int
} derive(ToJson)

///|
const Digits : Regex = re"[[:digit:]]+"

///|
async fn collect_test_result(run_dir~ : String) -> TestResult {
  let output = @shell.Cmd("moon", ["test"], cwd=run_dir).output(
    timeout_ms=TestTimeoutMs,
  )
  let mut result : TestResult = {
    exit_code: output.exit_code(),
    total: 0,
    passed: 0,
    failed: 0,
  }
  // moon prints the summary on stdout; scan stderr too in case that moves.
  for line in (output.stdout() + "\n" + output.stderr()).split("\n") {
    if line =~ (
        re"Total tests: " +
        (Digits as total) +
        re", passed: " +
        (Digits as passed) +
        re", failed: " +
        (Digits as failed)
      ) {
      result = {
        exit_code: output.exit_code(),
        total: @string.parse_int(total),
        passed: @string.parse_int(passed),
        failed: @string.parse_int(failed),
      }
    }
  }
  result
}

///|
struct CheckResult {
  exit_code : Int
  warnings : Int
  errors : Int
} derive(ToJson)

///|
async fn collect_check_result(run_dir~ : String) -> CheckResult {
  let mut warnings = 0
  let mut errors = 0
  let exit_code = @shell.Cmd("moon", ["check", "--output-json"], cwd=run_dir).each_line() <| line => {
    let diagnostic = @json.parse(line) catch { _ => return }
    match diagnostic {
      { "level": "warning", .. } => warnings += 1
      { "level": "error", .. } => errors += 1
      _ => ()
    }
  }
  { exit_code, warnings, errors, }
}

///|
struct ToolCallStats {
  passed : Int
  failed : Int
} derive(ToJson)

///|
async fn collect_run_stats(
  run_dir~ : String,
  test_result~ : TestResult,
  check_result~ : CheckResult,
) -> RunStats {
  let logs = @shell.glob(
    "\{run_dir}/.openseek/sessions/*/openseek_session-*.jsonl",
  ).filter(path => !path.contains("-sr-"))
  guard logs is [primary] else {
    fail("expect exactly 1 session log, but got: \{@debug.Repr(logs)}")
  }
  let parsed = @session_log.parse_events(@fs.read_file(primary).text())
  // The viewer deep-links sessions by id (`#s=<id>` in the exported HTML).
  let session_id = parsed.header.map(header => header.id)
  let tool_call_stats : Map[String, ToolCallStats] = Map([])
  let mut start_ms = None
  let mut stop_ms = None
  let mut stop_reason = None
  for event in parsed.events {
    let now = event.unix_ms()
    if start_ms is None {
      start_ms = Some(now)
    }
    stop_ms = Some(now)
    match event.item() {
      Tool(result) => {
        let name = result.tool_name()
        let passed = if result.is_error() { 0 } else { 1 }
        let failed = 1 - passed
        if tool_call_stats.get(name) is Some(stat) {
          tool_call_stats[name] = {
            passed: stat.passed + passed,
            failed: stat.failed + failed,
          }
        } else {
          tool_call_stats[name] = { passed, failed, }
        }
      }
      Terminal(terminal) => stop_reason = Some(terminal)
      _ => ()
    }
  }
  let elapsed = if start_ms is Some(start_ms) && stop_ms is Some(stop_ms) {
    (stop_ms - start_ms).to_double() / 1000.0
  } else {
    0.0
  }
  {
    dir: run_dir,
    session_id,
    steps: parsed.events.count_if(event => event.is_agent_step()),
    elapsed,
    tool_call_stats,
    test_result,
    check_result,
    stop_reason,
  }
}

///|
struct RunStats {
  dir : String
  session_id : String?
  steps : Int
  elapsed : Double
  // tool_call: name -> stats
  tool_call_stats : Map[String, ToolCallStats]
  test_result : TestResult
  check_result : CheckResult
  stop_reason : @agent_session.TurnTerminal?
}

///|
impl ToJson for RunStats with fn to_json(self) {
  let stop_reason : Json = match self.stop_reason {
    Some(Finished(message)) => { "kind": "finished", "message": message }
    Some(Aborted(message)) => { "kind": "aborted", "message": message }
    Some(Interrupted(message)) => { "kind": "interrupted", "message": message }
    Some(Failed(message)) => { "kind": "failed", "message": message }
    None => null
  }
  {
    "dir": self.dir,
    "session_id": match self.session_id {
      Some(id) => Json::string(id)
      None => Json::null()
    },
    "steps": self.steps,
    "elapsed": self.elapsed,
    "tool_call_stats": self.tool_call_stats,
    "test_result": self.test_result,
    "check_result": self.check_result,
    "stop_reason": stop_reason,
  }
}

///|
struct TaskStats {
  task : String
  passed : Int
  runs : Array[RunStats]
} derive(ToJson)

///|
async fn main {
  let command = @argparse.Command(
    "grade",
    about="Grade OpenSeek fleet runs for a task under tasks/",
    positionals=[PositionArg("task")],
  )
  let matches = command.parse()
  guard matches.values.get("task") is Some([task, ..]) else {
    fail("expect <task>")
  }
  let run_stats : Array[RunStats] = []
  for run_dir in @shell.glob("tasks/\{task}_run_*") {
    guard @fs.kind(run_dir) is Directory else { continue }
    copy_glob("tasks/\{task}/*_test.mbt", run_dir)
    let test_result = collect_test_result(run_dir~)
    let check_result = collect_check_result(run_dir~)
    let run_stat = collect_run_stats(run_dir~, test_result~, check_result~)
    run_stats.push(run_stat)
  }
  let stats : TaskStats = {
    task,
    passed: run_stats.count_if(run => {
      run.test_result.failed == 0 && run.test_result.total > 0
    }),
    runs: run_stats,
  }
  println(ToJson::to_json(stats).stringify(indent=2))
}
