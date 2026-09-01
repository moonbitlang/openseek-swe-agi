///|
test "easy/happy/arithmetic" {
  let src =
    #|local a = 2 + 3 * 4
    #|local b = 7 // 2
    #|assert(a == 14)
    #|assert(b == 3)
    #|assert(7 % 3 == 1)
    #|assert(5 / 2 == 2.5)
    #|
  @lua.exec(src)
}

///|
test "easy/happy/strings" {
  let src =
    #|local s = "hello"
    #|assert(#s == 5)
    #|assert(s .. " world" == "hello world")
    #|assert(string.upper("Lua") == "LUA")
    #|
  @lua.exec(src)
}

///|
test "hard/happy/coroutine-yield-resume" {
  let src =
    #|local co = coroutine.create(function()
    #|  local x = coroutine.yield(1)
    #|  assert(x == 10)
    #|  return x + 2
    #|end)
    #|local ok, value = coroutine.resume(co)
    #|assert(ok)
    #|assert(value == 1)
    #|ok, value = coroutine.resume(co, 10)
    #|assert(ok)
    #|assert(value == 12)
    #|
  @lua.exec(src)
}

///|
test "hard/happy/coroutine-multi-yield" {
  // From testes/coroutine.lua (multiple resume/yield values)
  let src =
    #|local function foo(a, b)
    #|  local x, y = coroutine.yield(a + b, a - b)
    #|  return x, y, a, b
    #|end
    #|local co = coroutine.create(foo)
    #|local ok, p, q = coroutine.resume(co, 5, 3)
    #|assert(ok and p == 8 and q == 2)
    #|ok, p, q, r, s = coroutine.resume(co, "x", "y")
    #|assert(ok and p == "x" and q == "y" and r == 5 and s == 3)
    #|
  @lua.exec(src)
}

///|
test "hard/error/syntax-break-outside" {
  let src =
    #|break
    #|
  assert_syntax_error(src)
}

///|
test "easy/error/syntax-bad-token" {
  let src =
    #|local = 1
    #|
  assert_syntax_error(src)
}

///|
test "mid/happy/functions-and-closures" {
  let src =
    #|local function make_adder(x)
    #|  return function(y)
    #|    return x + y
    #|  end
    #|end
    #|local add5 = make_adder(5)
    #|assert(add5(3) == 8)
    #|
  @lua.exec(src)
}

///|
test "mid/happy/varargs-sum" {
  let src =
    #|local function sum(...)
    #|  local total = 0
    #|  for i = 1, select("#", ...) do
    #|    total = total + select(i, ...)
    #|  end
    #|  return total
    #|end
    #|assert(sum(1, 2, 3, 4) == 10)
    #|
  @lua.exec(src)
}

///|
/// Run `src` and require that it fails to compile: `exec` must raise
/// `SyntaxError`. Completing normally or raising `RuntimeError` fails the
/// test.
fn assert_syntax_error(src : String) -> Unit raise {
  try @lua.exec(src) catch {
    SyntaxError(_) => ()
    RuntimeError(msg) =>
      fail("expected a syntax error, got a runtime error: \{msg}")
  } noraise {
    _ => fail("expected a syntax error, but the chunk ran successfully")
  }
}

///|
/// Run `src` and require that it compiles but fails at run time: `exec`
/// must raise `RuntimeError`. Completing normally or raising `SyntaxError`
/// fails the test.
fn assert_runtime_error(src : String) -> Unit raise {
  try @lua.exec(src) catch {
    RuntimeError(_) => ()
    SyntaxError(msg) =>
      fail("expected a runtime error, got a syntax error: \{msg}")
  } noraise {
    _ => fail("expected a runtime error, but the chunk ran successfully")
  }
}

///|
test "quickcheck: exec should never panic" {
  @quickcheck.check((s : String) => {
    try @lua.exec(s) catch {
      _ => true
    } noraise {
      _ => true
    }
  })
}
