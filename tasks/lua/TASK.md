## Goal

Implement a MoonBit **Lua 5.4 interpreter** that is compatible with this
repository's test suite. The authoritative references are vendored in:

- `specs/lua-5.4.8-manual.html` — the Lua 5.4.8 Reference Manual
- `specs/lua.md` — this repo's interpreter-oriented summary and
  conventions

## What This Task Is Really About

This is an exercise in building a **real language implementation**. The
goal is to write code that can correctly execute Lua 5.4 programs in
general — not to hardcode behaviors for specific test chunks.

A proper implementation will have:

- A **lexer** for Lua's lexical shapes (names and keywords, short and
  long strings with their escapes, decimal/hex integer and float
  literals including hex floats like `0x1p-1`, comments, operators)
- A **parser** for the Lua 5.4 grammar (statements, expressions with
  correct precedence and associativity, function bodies, varargs) that
  rejects malformed chunks at compile time
- A **runtime** implementing Lua semantics: values (nil, booleans,
  64-bit integers and floats, strings, tables, functions, coroutines),
  environments and closures, metatables and metamethods, error
  propagation with `pcall`/`xpcall`
- **Standard libraries** required by the suite: base, `string`
  (including Lua patterns), `table`, `math`, `coroutine`

**Important mindset**: If the test suite were regenerated with different
programs exercising the same language features, your implementation
should still pass. If it wouldn't, you haven't built an interpreter —
you've built a lookup table.

## Approach

Build incrementally:

1. **Lexing**: names, keywords, strings (escapes, long brackets),
   numbers (integer vs float, hex, hex floats), comments, operators.
2. **Parsing**: full statement and expression grammar; compile-time
   checks (`break` placement, `...` only in vararg functions, balanced
   blocks).
3. **Core runtime**: values, scopes and closures, calls and multiple
   returns/assignment, control flow (numeric and generic `for`,
   `while`, `repeat`), integer/float arithmetic rules.
4. **Metatables**: `__index`, `__newindex`, `__add`, `__call`,
   `__concat`, `__eq`, `__lt`, `__le`, `__len`, `__tostring`.
5. **Libraries**: base functions, string patterns and `string.format`,
   table manipulation, math, coroutines.
6. **Error handling**: classify failures as `SyntaxError` vs
   `RuntimeError` exactly where Lua 5.4 draws the line.

Run tests frequently while adding features.

Important: The core logic must be implemented in MoonBit.

## Scope

In scope (Lua 5.4, as exercised by the tests):

- Executing one chunk per `exec` call in a fresh VM, deterministically
- The full expression/statement grammar of Lua 5.4 for text chunks
- Integer/float numerics (wrap-around integer arithmetic, floor
  division and modulo, bitwise operators, hex floats,
  `math.maxinteger`/`math.mininteger`)
- Tables with array and hash parts, the `#` length operator, metatables
  and the metamethods listed above
- Closures, varargs (`select`, tail-call argument adjustment), multiple
  assignment and multiple returns
- Coroutines: `create`, `resume`, `yield`, `status`, `wrap`, yields
  across calls, nested coroutines, error propagation into `resume`
- `load` with text chunks and custom environments (`_ENV`)
- The base/`string`/`table`/`math`/`coroutine` library functions listed
  in `specs/lua.md`
- Robustness: `exec` must never panic or hang on arbitrary input (a
  property-based test feeds it random strings)

Out of scope (not required by the tests):

- The C API, `require`/`package`, `io`, `os`, `utf8`, and `debug`
  libraries; binary chunks (`string.dump`); garbage-collection
  observables (`collectgarbage`, weak tables, `__gc`); goto/labels
  beyond what the grammar demands

## Required API

Complete the declaration in `lua_spec.mbt`.

Implementation notes:

- You can **freely decide** the project structure (modules/files), the
  parsing/evaluation strategy, and any internal data structures.
- Do **not** modify the following files:
  - `lua_spec.mbt` - API specification (`LuaError`, `exec`)
  - `specs/` folder - Reference documents
  - `*_pub_test.mbt` - Public test file (`lua_pub_test.mbt`)
  - `*_priv_test.mbt` - Private test file (`lua_priv_test.mbt`)
- Implement the required declaration by adding new `.mbt` files as
  needed.
- **You may add additional test files** (e.g., `xxx_test.mbt`) if needed
  for testing and maintenance purposes:
  - Create test files to validate edge cases
  - Derive test scenarios from the vendored reference manual
  - All added tests must remain faithful to Lua 5.4

Required entry points:

- `@lua.exec(src : StringView) -> Unit raise LuaError`

The error type is fixed by the spec: `LuaError` is a `pub(all)` suberror
in `lua_spec.mbt` with variants `SyntaxError(String)` and
`RuntimeError(String)`. The tests execute Lua chunks that assert their
own expectations with Lua's `assert`, so they only check whether `exec`
returns, raises `SyntaxError`, or raises `RuntimeError` — never the
message text.

## Behavioral rules

- Follow Lua 5.4 (reference release 5.4.8) exactly for everything the
  tests observe; `specs/lua.md` summarizes the dialect points the suite
  leans on.
- Each `exec` call runs in a fresh VM with base, `string`, `table`,
  `math`, and `coroutine` loaded; no state crosses calls.
- Raise `SyntaxError` for chunks the reference interpreter's `load`
  would reject (including `break` outside a loop and `...` misuse,
  which are compile-time errors).
- Raise `RuntimeError` for errors raised while the chunk runs and not
  caught by `pcall`/`xpcall` inside it — `error(...)`, failed
  `assert(...)`, invalid arithmetic/concatenation/indexing/calls, bad
  library arguments, yielding from the main thread.
- Behavior must be deterministic, and `exec` must be total: for
  arbitrary input it returns or raises `LuaError` — it never panics.

## Test execution

```bash
moon test
```

## Constraints

### 1. Test Requirements

**All tests must pass for task completion**:

The model should keep running until all tests pass.

- **Public tests** (`*_pub_test.mbt`): 9 cases (including one
  property-based robustness test), visible in this repository for
  development and debugging
- **Private tests** (`*_priv_test.mbt`): 75 additional cases, vendored
  as ordinary files in this local task and run by `moon test`

**CRITICAL - Full Suite Evaluation**:

Passing only the public tests is **INSUFFICIENT** and will result in
task failure. The task is complete **only when both public and private
test suites in this directory pass**.

**Why Private Tests Matter**:
- **Coverage**: Private tests represent ~90% of the total evaluation -
  they are the primary measure of success
- **Comprehensiveness**: Validate interpreter semantics well beyond the
  public subset — metatables, coroutines, string patterns,
  `string.format`, numeric edge cases, `_ENV` manipulation
- **Real-world scenarios**: Several chunks come from the official Lua
  `testes/` suite
- **Implementation integrity**: Even though these tests are visible
  here, the goal is a genuine interpreter, not a lookup table for
  fixture outputs

**Evaluation Process**:

Make all tests pass locally by running `moon test` in this directory.
Iterate until they pass, then `finish`.

There is **no submission step and no evaluation server** in this
environment. `moon test` is the grading command for this vendored native
workflow.

Because the private tests (~90% of the suite) decide success, a genuine,
general implementation is essential: do **not** hardcode or memorize
responses to the fixtures — build a real interpreter that works for
arbitrary Lua 5.4 programs within the scoped subset.

### 2. Code Quality Requirements

**Correctness**:
- Zero compiler errors, warnings, or diagnostics
- No runtime panics or unhandled edge cases
- Proper error handling with meaningful error messages

**Formatting**:
- Run `moon fmt` to format all code
- Run `moon info` to generate interface files (`.mbti`)
- Follow MoonBit style conventions consistently

**Implementation Integrity**:
- Solutions must be real interpreters, not test-specific lookup tables
- No hardcoded mappings derived from test fixtures
- Implementation should work for arbitrary Lua 5.4 chunks within the
  scoped subset

### 3. Software Engineering Standards

**Modularity and Organization**:
- The required declaration in `lua_spec.mbt` belongs to the root `lua`
  package. Tests call the root-package API `@lua.exec`, so that
  declaration must be implemented in (or forwarded to) the root
  package.
- You may organize implementation across root-level files by functional
  area (for example, lexing, parsing, evaluation, libraries).
- If you create subdirectories as separate MoonBit packages, wire them
  through package configuration and keep root-package implementations,
  `pub using` re-exports, or forwarding functions so the required root
  `lua` API remains available.
- Group related functionality together
- Avoid dumping all code in the root directory

**File Size Limits**:
- Please try to keep each file to at most **1000 lines of core code**
  (excluding blank lines and comments)
- Split large modules into focused, single-responsibility files
- Use meaningful file names that reflect their purpose

**Readability**:
- Clear, descriptive function and variable names
- Add comments for complex algorithms or non-obvious logic
- Document public APIs and key data structures
- Keep functions focused (prefer multiple small functions over large
  monolithic ones)

**Code Structure**:
- Logical separation of concerns (lexing → parsing → evaluation →
  libraries)
- Minimize coupling between modules
- Use appropriate abstractions (types, enums, structs)
- Avoid global mutable state

**Example directory structure**:
```
lua/
├── moon.mod
├── moon.pkg
├── lua_spec.mbt           # API specification (do not modify)
├── lua.mbt                # exec: wire lexer → parser → runtime
├── lexer.mbt              # Tokenization
├── parser.mbt             # AST construction
├── eval.mbt               # Evaluation engine
├── value.mbt              # Value model, tables, metatables
├── coroutine.mbt          # Coroutine scheduling
└── stdlib_*.mbt           # base/string/table/math libraries
```

These standards ensure your code is maintainable, understandable, and
follows professional software engineering practices.

## Documentation

**Write a comprehensive README.md**:

Your implementation must include a `README.md` file that documents:

- **Project overview**: What this interpreter implements and its
  purpose
- **Architecture**: High-level design decisions and module organization
- **Implementation approach**: Key algorithms, data structures, and
  evaluation strategy
- **Usage examples**: How to use the API (executing chunks, handling
  errors)
- **Testing**: How to run tests and interpret results
- **Design decisions**: Rationale for important technical choices

The README should be written **based on your actual implementation** -
describe the code you built, not generic information from
specifications. It should help future developers understand your
codebase quickly.

## External references

This environment has public network access. You may consult Lua
documentation and discussions online, but treat the vendored spec files
in `specs/` as the authoritative baseline for behavior in this task.
