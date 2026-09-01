## Goal

Implement a MoonBit **TOML v1.0.0 parser** that is compatible with this
repository's test suite. The authoritative references are vendored in:

- `specs/v1.0.0.md` — the TOML v1.0.0 specification
- `specs/toml.md` — this repo's parser-oriented summary and conventions

## What This Task Is Really About

This is an exercise in building a **real parser** for a real data format.
The goal is to write code that can correctly parse TOML documents in
general — not to hardcode behaviors for specific test strings.

A proper implementation will have:

- A **lexer/scanner** layer that handles TOML's lexical shapes (strings
  and their escapes, numbers, datetimes, punctuation, comments, LF/CRLF
  newlines, whitespace)
- A **parser** for statements (key/value pairs, dotted keys, `[table]`
  headers, `[[array-of-tables]]` headers) and values (strings, integers,
  floats, booleans, datetimes, arrays, inline tables)
- A **semantic layer** that applies TOML's structural rules (duplicate
  keys, table redefinition, dotted-key/header interactions, closed inline
  tables, static vs array-of-tables arrays) and produces the final
  document value

**Important mindset**: If the test suite were regenerated with different
literal values, different key names, or different whitespace/comment
placement, your implementation should still pass. If it wouldn't, you
haven't built a parser — you've built a lookup table.

## Approach

Build incrementally:

1. **Lexing**: keys, strings, numbers, punctuation, comments, newlines
   (LF/CRLF), whitespace.
2. **Parsing values**: strings (basic, literal, multiline), integers
   (decimal, hex/octal/binary, underscores), floats (dot and exponent
   forms, `inf`/`nan`), booleans, datetimes (all four kinds), arrays,
   inline tables.
3. **Parsing statements**: key/value pairs, dotted keys, table headers,
   array-of-tables headers.
4. **Structural checks**: duplicate keys, redefinitions, dotted-key vs
   header conflicts, closed inline tables, static arrays.
5. **Validation depth**: calendar-correct dates (leap years), time and
   offset ranges, `Int64` range for integers, escape validity.

Run tests frequently while adding features.

Important: The core logic must be implemented in MoonBit.

## Scope

In scope (TOML v1.0.0, exactly):

- Key/value pairs with bare, quoted, and dotted keys
- Tables `[a]`, nested tables `[a.b]`, arrays of tables `[[arr]]`
- Comments (`# ...`) and flexible whitespace; LF and CRLF newlines
- Printing: `print` serializes a document back to TOML text that parses
  to an equal document (the exact layout is unspecified)
- Values:
  - strings: basic, literal, and both multiline forms with the v1.0.0
    escape and control-character rules
  - integers: decimal, hex, octal, binary, `_` separators, signed 64-bit
    range (overflow is an error)
  - floats: IEEE 754 binary64, exponent forms, `inf` and `nan`
  - booleans
  - datetimes: offset date-time, local date-time, local date, local time
    (seconds required; leap second `:60` accepted; fractional seconds
    truncated to nanoseconds)
  - arrays (multi-line, trailing comma allowed, heterogeneous element
    types allowed)
  - inline tables (single-line, no trailing comma)

Out of scope (rejected as invalid — these are TOML 1.1 draft features):

- Newlines or trailing commas in inline tables
- `\x..` and `\e` string escapes
- Times and date-times without seconds

## Required API

Complete the declarations in `toml_spec.mbt`.

Implementation notes:

- You can **freely decide** the project structure (modules/files), the
  parsing strategy, and any internal data structures.
- Do **not** modify the following files:
  - `toml_spec.mbt` - API specification (types, `Eq`, `parse`, `print`)
  - `toml_qc.mbt` - Property-test generators
  - `specs/` folder - Reference documents
  - `*_pub_test.mbt` - Public test file (`toml_pub_test.mbt`)
  - `*_priv_test.mbt` - Private test file (`toml_priv_test.mbt`)
- Implement the required declarations by adding new `.mbt` files as needed.
- **You may add additional test files** (e.g., `xxx_test.mbt`) if needed
  for testing and maintenance purposes:
  - Create test files to validate edge cases
  - Derive test scenarios from `specs/v1.0.0.md`
  - All added tests must remain faithful to TOML v1.0.0

Required entry points:

- `@toml.parse(input : StringView) -> Map[String, Toml] raise`
- `@toml.print(doc : Map[String, Toml]) -> String`

The result types are fixed by the spec: `Toml`, `Date`, and `Time` are
`pub(all)` types in `toml_spec.mbt` whose values the tests construct
directly and compare with `assert_eq` (using the `Eq` implementation
shipped in the spec — floats compare IEEE-style with NaN == NaN). The
property-test generators in `toml_qc.mbt` build documents from these
types and check `parse(print(doc)) == doc`.

## Behavioral rules

- Follow TOML v1.0.0 exactly; TOML 1.1 draft extensions must be rejected.
- Tables are maps: key order does not matter, keys are case-sensitive.
- Integers are `Int64`; out-of-range integers are an error.
- Offset datetimes store the wall-clock components plus the offset in
  minutes east of UTC (`Z` == `+00:00` == offset 0). Lowercase `t`/`z`
  and the space separator are accepted and not observable in the value.
- Fractional seconds go to `Time::nanosecond`, truncated (not rounded)
  beyond nine digits.
- `second` may be 60: RFC 3339's `time-second` is `00-58, 00-59, 00-60
  based on leap second rules`, so `23:59:60` parses; only `:61` and above
  are invalid.
- Offsets run to `+23:59` / `-23:59`: RFC 3339's `time-numoffset` is
  `("+" / "-") time-hour ":" time-minute`, and `time-hour` is `00-23`, so
  `+24:00` is out of range.
- Reject structural conflicts as required by the invalid tests (duplicate
  keys, redefining tables, extending closed inline tables, appending to
  static arrays, dotted-key/header conflicts, etc.).
- Reject invalid lexical content: bad escapes, out-of-range or surrogate
  `\u`/`\U` code points, control characters outside strings and in
  single-line strings, bare CR, malformed numbers and datetimes,
  non-calendar dates.
- `print` emits TOML text whose exact layout is unspecified, but
  `parse(print(doc)) == doc` must hold for every well-formed document
  (see `toml_spec.mbt` for the well-formedness contract); the round-trip
  is checked by a property-based test over generated documents.

## Test execution

```bash
moon test
```

## Constraints

### 1. Test Requirements

**All tests must pass for task completion**:

The model should keep running until all tests pass.

- **Public tests** (`*_pub_test.mbt`): 81 cases (including two
  property-based tests), visible in this repository for development and
  debugging
- **Private tests** (`*_priv_test.mbt`): 662 additional cases
  that decide the score. They are **withheld while you work** — expect
  them to be absent from this directory, and do not go looking for
  them. Your `moon test` therefore exercises the public tests only;
  the private suite is run against your implementation afterwards.

**CRITICAL - Full Suite Evaluation**:

Passing only the public tests is **INSUFFICIENT**. A green `moon test`
is necessary but not sufficient: it covers roughly 10% of the cases that
decide the outcome. The task is complete only when the private suite
passes too — and you cannot run it yourself.

**Why Private Tests Matter**:
- **Coverage**: Private tests represent ~90% of the total evaluation -
  they are the primary measure of success
- **Comprehensiveness**: Validate full TOML v1.0.0 compliance, including
  edge cases, corner cases, and subtle semantic rules not exposed in
  public tests
- **Real-world scenarios**: Test combinations and patterns that occur in
  actual TOML files but may not be obvious from the spec
- **Implementation integrity**: you cannot see these cases, so the only
  way to pass them is a genuine implementation rather than a lookup table
  for the fixtures you can see

**Evaluation Process**:

Make the public tests pass by running `moon test` in this directory, and
iterate until they do, then `finish`.

There is **no submission step and no evaluation server** in this
environment: `moon test` is the command you run, and the withheld private
tests are run against your implementation afterwards.

Because the withheld tests (~90% of the suite) decide success, a genuine,
general implementation is essential: do **not** hardcode or memorize
responses to the fixtures you can see — build a real parser that works for
arbitrary TOML v1.0.0 input.

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
- Solutions must be real parsers, not test-specific lookup tables
- No hardcoded mappings derived from test fixtures
- Implementation should work for arbitrary valid TOML v1.0.0 inputs

### 3. Software Engineering Standards

**Modularity and Organization**:
- The required declaration in `toml_spec.mbt` belongs to the root `toml`
  package. Tests call the root-package API `@toml.parse`, so that
  declaration must be implemented in (or forwarded to) the root package.
- You may organize implementation across root-level files by functional
  area (for example, lexing, value parsing, structural semantics).
- If you create subdirectories as separate MoonBit packages, wire them
  through package configuration and keep root-package implementations,
  `pub using` re-exports, or forwarding functions so the required root
  `toml` API remains available.
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
- Logical separation of concerns (lexing → parsing → semantic analysis)
- Minimize coupling between modules
- Use appropriate abstractions (types, enums, structs)
- Avoid global mutable state

**Example directory structure**:
```
toml/
├── moon.mod
├── moon.pkg
├── toml_spec.mbt          # API specification (do not modify)
├── toml.mbt               # Main entry point
├── lexer.mbt              # Character-level scanning helpers
├── strings.mbt            # String parsing and escapes
├── numbers.mbt            # Integer/float parsing
├── datetime.mbt           # Datetime parsing and validation
└── semantic.mbt           # Tables, dotted keys, structural rules
```

These standards ensure your code is maintainable, understandable, and
follows professional software engineering practices.

## Documentation

**Write a comprehensive README.md**:

Your implementation must include a `README.md` file that documents:

- **Project overview**: What this parser implements and its purpose
- **Architecture**: High-level design decisions and module organization
- **Implementation approach**: Key algorithms, data structures, and
  parsing strategy
- **Usage examples**: How to use the API (parsing code, reading the
  resulting document)
- **Testing**: How to run tests and interpret results
- **Design decisions**: Rationale for important technical choices

The README should be written **based on your actual implementation** -
describe the code you built, not generic information from specifications.
It should help future developers understand your codebase quickly.

## External references

This environment has public network access. You may consult upstream TOML
documentation and discussions online, but treat the vendored spec files in
`specs/` as the authoritative baseline for behavior in this task.
