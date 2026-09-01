# Lua 5.4 — interpreter specification for this repo

This document is a **practical, test-oriented spec** for the `lua`
package. It summarizes the required behavior of a **Lua 5.4**
interpreter subset and the conventions used by this repository's MoonBit
API and test suite.

It is **not** a copy of the Lua reference manual; the authoritative text
is vendored at `specs/lua-5.4.8-manual.html` (the source of the Lua 5.4.8
Reference Manual).

## Objectives (what the implementation must do)

The `lua` package expects an implementation that can:

1. Compile a Lua 5.4 chunk (source text) and execute it in a fresh VM
   with the standard libraries required by this suite loaded: base,
   `string`, `table`, `math`, `coroutine`.
2. Raise `LuaError::SyntaxError` for inputs that are not valid Lua 5.4
   chunks (lexing/parsing/compiling failures).
3. Raise `LuaError::RuntimeError` for chunks that compile but fail at
   run time with an error not caught by `pcall`/`xpcall` inside the
   program — including failed `assert(...)` calls.
4. Never panic: for **arbitrary** input, `exec` either returns or raises
   a `LuaError` (checked by a property-based test over random strings).

## Primary references

- Lua 5.4.8 Reference Manual (vendored): `specs/lua-5.4.8-manual.html`
- Lua 5.4 Reference Manual (online): https://www.lua.org/manual/5.4/
- The official interpreter (lua.org release `lua-5.4.8`) is the
  behavioral baseline: every valid chunk in this suite runs successfully
  under it, every syntax-error chunk fails its `load`, and every
  runtime-error chunk fails under `pcall`.

## Dialect

The dialect is **Lua 5.4 exactly** (reference release 5.4.8). Notable
5.4 semantics the tests rely on:

- **Integer/float distinction**: `math.type(1) == "integer"`,
  `math.type(1.5) == "float"`; integer arithmetic wraps on 64-bit
  two's-complement overflow (`math.maxinteger + 1 < math.maxinteger`);
  `/` and `^` always produce floats; `//` and `%` follow floor
  semantics (`-7 // 3 == -3`, `-7 % 3 == 2`).
- **Bitwise operators** `& | ~ << >>` on integers, with `~` also the
  unary bitwise NOT and `0xF0 & 0xCC == 0xC0`-style precedence.
- **Hex float literals**: `0x1p1 == 2.0`, `0x1.8p0 == 1.5`,
  `0xABCp4 == 0xABC0`.
- **`goto`-era grammar rules**: `break` outside a loop and `...` in a
  non-vararg function (or not in the last parameter position) are
  *syntax* errors, caught at compile time.
- **Metamethods**: `__index` (table or function), `__newindex`,
  `__add`, `__call`, `__concat`, `__eq`, `__lt`, `__le`, `__len`,
  `__tostring`.
- **Coroutines**: `create`/`resume`/`yield`/`status`/`wrap`, multiple
  yield/resume values, yields across (tail) calls, nested coroutines,
  errors inside coroutines turning into `false, message` from `resume`,
  and `coroutine.yield()` from the main thread being a *runtime* error.

## API contract (from `lua_spec.mbt`)

```
exec(src : StringView) -> Unit raise LuaError

suberror LuaError {
  SyntaxError(String)
  RuntimeError(String)
}
```

The error payload is a human-readable message; tests match only the
variant. There is no output comparison: the chunks assert their own
expectations with Lua's `assert`, so the observable contract is
"ran to completion" vs. "which class of error".

## Execution model

- **Fresh VM per call.** Each `exec` call compiles and runs the chunk in
  a brand-new interpreter state. No globals, metatables, or loaded
  chunks survive between calls; behavior must be deterministic.
- **Chunk semantics.** The input is one chunk, compiled as a vararg
  function and run in the global environment (as the reference
  interpreter's `load(src, name, "t")` + call would). Statement
  separators (`;`) are optional; both statement-level and expression
  grammars must match the manual.
- **Error classification.** Errors detected before the chunk starts
  running (lexer, parser, compile-time checks like `break` placement)
  are `SyntaxError`. Everything raised while running — `error(...)`,
  failed `assert`, wrong-type arithmetic/concatenation/indexing/calls,
  bad arguments to library functions, yielding from the main thread —
  is `RuntimeError`, unless the program itself catches it with
  `pcall`/`xpcall`.

## Required libraries (as exercised by the corpus)

- **base**: `_G`, `assert`, `error`, `pcall`, `xpcall`, `type`,
  `tostring` (honoring `__tostring`), `tonumber` (decimal and `0x`
  strings; returns `nil` on non-numbers rather than erroring), `pairs`,
  `ipairs`, `next`, `select` (including `select("#", ...)` and negative
  indices), `load` (text chunks, with the optional `chunkname`, `mode`,
  and `env` parameters — `load(code, "name", "t", env)` must run the
  chunk with `env` as its `_ENV`), `print`, `rawget`, `rawset`,
  `rawequal`, `rawlen` (strings and tables only; erroring otherwise),
  `setmetatable`, `getmetatable`.
- **string**: `byte`, `char`, `find` (patterns, `init`, `plain`),
  `format` (`%d %s %x %X %f` with width/precision/zero-pad forms),
  `gmatch`, `gsub` (pattern captures and `%1` replacement references),
  `match`, `rep` (with separator), `reverse`, `sub`, `upper` — with Lua
  patterns including classes (`%a %d %f[set] %b()`), captures, and
  anchors as defined in the manual.
- **table**: `concat` (with separator and range), `insert` (2- and
  3-argument forms; wrong arity is an error), `move`, `pack`/`unpack`
  (including explicit ranges and `nil` holes), `remove`, `sort`
  (default `<` and custom comparators).
- **math**: `abs`, `cos`, `floor`, `max`, `min`, `maxinteger`,
  `mininteger`, `modf`, `pi`, `sin`, `sqrt`, `tointeger`, `type` —
  with integer-vs-float behavior per the manual (e.g. `math.floor`
  errors on a non-number string).
- **coroutine**: `create`, `resume`, `status`, `wrap`, `yield`.

The corpus grows in the private suite along exactly these lines; the
manual — not this list's letter — is the authority for each function's
behavior.

## Robustness

`exec` must be total over arbitrary `String` input: return, raise
`SyntaxError`, or raise `RuntimeError` — never panic, abort, or hang.
The public suite includes a quickcheck property feeding random strings
to `exec` to enforce this.

## Error handling

Tests never inspect error messages — only the `SyntaxError` vs.
`RuntimeError` classification. A message in the reference
interpreter's `chunk:line: description` style is nevertheless strongly
recommended for debuggability. What matters is drawing the
compile-time/run-time line exactly where Lua 5.4 draws it.
