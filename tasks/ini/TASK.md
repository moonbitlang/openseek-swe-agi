## Goal

Implement a MoonBit **INI parser** that is compatible with this repository's
test suite. INI has no single authoritative standard; this repo defines a
clear dialect via its API contract and tests. The authoritative reference is
vendored in:

- `specs/ini.md`

## What This Task Is Really About

This is an exercise in building a **real parser** for a real configuration
format. The goal is to parse INI inputs correctly in general — not to
hardcode behaviors for specific test strings.

A proper implementation will have:

- A line scanner that handles sections, key/value entries, comments, blank
  lines, and continuations
- Value parsing for quoted (`"..."`, `'...'`) and unquoted values, inline
  comments, and escape sequences
- A parser that produces the document as global entries plus a map from
  section name to that section's key/value entries

**Important mindset**: If the test suite were regenerated with different
literal values or different section/comment placement, your implementation
should still pass. If it wouldn't, you haven't built a parser — you've built
a lookup table.

## Approach

Build incrementally:

1. **Line handling**: LF/CRLF line breaks, blank lines, full-line comments.
2. **Sections**: `[name]` headers, the "" global section, re-opening on a
   repeated header.
3. **Entries**: the first `=` or `:` as the separator, whitespace trimming,
   duplicate keys.
4. **Values**: quoted values (escapes, `\n` for a line break), inline
   comments, backslash continuations, escape sequences in unquoted values.
5. **Error detection**: reject the malformed inputs required by invalid tests.

Run tests frequently while adding features.

Important: The core logic must be implemented in MoonBit.

## Scope

In scope for this parser implementation:

- Sections with the global "" section, including:
  - names with spaces, unicode, punctuation and embedded quotes
  - fully-quoted names (`["name"]`, `['name']`) with the quotes stripped
  - re-opening on a repeated header, with last-wins for duplicate keys
- Key/value entries split at the first `=` or `:`; later ones are value text
- Comments: `;` and `#`, full-line and inline (after whitespace, outside
  quotes)
- Quoted values (double and single), closing on the same line and
  preserving inner whitespace and comment markers. Each carrier decodes its
  own escapes — unquoted `\\ \n \r \t`, `"..."` those plus `\"`, `'...'`
  only `\\` and `\'` — and anything else keeps its backslash. See the table
  in `specs/ini.md`
- Backslash line continuations, and the trailing-backslash runs that are
  escaped literals instead (see `specs/ini.md`)
- Line endings: LF and CRLF

Out of scope (not required by current tests):

- Type inference (everything is a string)
- Nested sections or interpolation

## Required API

Complete the declarations in `ini_spec.mbt`.

Implementation notes:

- You can **freely decide** the project structure (modules/files/directories),
  the parsing strategy, and any internal data structures.
- Do **not** modify the following files:
  - `ini_spec.mbt` - API specification
  - `ini_qc.mbt` - Property-test generators
  - `specs/` folder - Reference documents
  - `*_pub_test.mbt` - Public test files (`ini_pub_test.mbt`)
  - `*_priv_test.mbt` - Private test files (`ini_priv_test.mbt`)
- Implement the required declarations by adding new `.mbt` files as needed.
- **You may add additional test files** (e.g., xxx_test.mbt) if needed for testing and maintenance purposes
  - Create additional test files (e.g., `xxx_test.mbt`) to validate edge cases
  - Derive test scenarios from `specs/ini.md`
  - All added tests must remain faithful to the INI dialect used by this repo

Required entry points:

- `@ini.parse(input : StringView) -> Doc raise`
- `@ini.print(doc : Doc) -> String`

## Behavioral rules

- The document is global entries plus a map of sections: a duplicate key
  takes its last value and a repeated section header re-opens the section
  (see `ini_spec.mbt`).
- Whitespace around keys, separators, and unquoted values is trimmed; quoted
  values keep theirs.
- Reject malformed inputs as the invalid tests require:
  - malformed section headers (unclosed, empty, nested brackets)
  - lines without a separator; empty or whitespace-only keys; control
    characters in keys
  - unterminated or mismatched quotes, a quote left open at the end of its
    line, text after a closing quote
  - invalid continuations (trailing `\` at end of input, continuation
    without a trailing `\`)
- `print` must satisfy `parse(print(doc)) == doc` for well-formed documents
  (see `ini_spec.mbt`); the round-trip is checked by a property-based test.

## Test execution

```bash
moon test
```


## Constraints

### 1. Test Requirements

**All tests must pass for task completion**:

The model should keep running until all tests pass.

- **Public tests** (`*_pub_test.mbt`): 12 cases (including two property-based tests), visible in this repository for development and debugging
- **Private tests** (`*_priv_test.mbt`): 108 additional cases that decide the score. They are **withheld while you work** — expect them to be absent from this directory, and do not go looking for them. Your `moon test` therefore exercises the public tests only; the private suite is run against your implementation afterwards.

**CRITICAL - Full Suite Evaluation**:

Passing only the public tests is **INSUFFICIENT**. A green `moon test` is necessary but not sufficient: it covers roughly 10% of the cases that decide the outcome. The task is complete only when the private suite passes too — and you cannot run it yourself.

**Why Private Tests Matter**:
- **Coverage**: Private tests represent 90% of the total evaluation - they are the primary measure of success
- **Comprehensiveness**: Validate full INI behavior compliance, including edge cases, corner cases, and subtle semantic rules not exposed in public tests
- **Real-world scenarios**: Test configuration shapes that occur in actual INI files (git config, systemd units, php.ini) but may not be obvious from the spec
- **Implementation integrity**: you cannot see these cases, so the only way to pass them is a genuine parser rather than a lookup table for the fixtures you can see

**Evaluation Process**:

Make the public tests pass by running `moon test` in this directory, and
iterate until they do, then `finish`.

There is **no submission step and no evaluation server** in this environment:
`moon test` is the command you run, and the withheld private tests are run
against your implementation afterwards.

Because the withheld tests (~90% of the suite) decide success, a genuine,
general implementation is essential: do **not** hardcode or memorize responses
to the fixtures — build a real parser that works for arbitrary inputs within
the supported dialect.

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
- Solutions must be real parsers/state machines, not test-specific lookup tables
- No hardcoded mappings derived from test fixtures
- Implementation should work for arbitrary INI inputs within the supported dialect

### 3. Software Engineering Standards

**Modularity and Organization**:
- The required declarations in `ini_spec.mbt` belong to the root `ini`
  package. Tests call root-package APIs such as `@ini.parse`, so those
  declarations must be implemented or forwarded from the root package.
- You may organize implementation across root-level files by functional area
  (for example, scanning, value parsing, and printing).
- If you create subdirectories as separate MoonBit packages, wire them through
  package configuration and keep root-package implementations, `pub using`
  re-exports, or forwarding functions so the required root `@ini` APIs remain
  available.
- Group related functionality together
- Avoid dumping all code in the root directory

**File Size Limits**:
- Please try to keep each file to at most **1000 lines of core code** (excluding blank lines and comments)
- Split large modules into focused, single-responsibility files
- Use meaningful file names that reflect their purpose

**Readability**:
- Clear, descriptive function and variable names
- Add comments for complex algorithms or non-obvious logic
- Document public APIs and key data structures
- Keep functions focused (prefer multiple small functions over large monolithic ones)

**Code Structure**:
- Logical separation of concerns (scanning → parsing → output)
- Minimize coupling between modules
- Use appropriate abstractions (types, enums, structs)
- Avoid global mutable state

**Example directory structure**:
```
ini/
├── moon.mod
├── moon.pkg
├── ini_spec.mbt           # API declarations (do not modify)
├── ini.mbt                # Main entry point
├── scanner.mbt            # Line and value scanning
├── parser.mbt             # Document assembly
└── printer.mbt            # print implementation
```

These standards ensure your code is maintainable, understandable, and follows professional software engineering practices.

## Documentation

**Write a comprehensive README.md**:

Your implementation must include a `README.md` file that documents:

- **Project overview**: What this parser implements and its purpose
- **Architecture**: High-level design decisions and module organization
- **Implementation approach**: Key algorithms, data structures, and parsing strategy
- **Usage examples**: How to use the API (parsing and printing code)
- **Testing**: How to run tests and interpret results
- **Design decisions**: Rationale for important technical choices

The README should be written **based on your actual implementation** - describe the code you built, not generic information from specifications. It should help future developers understand your codebase quickly.

## External references

This environment has public network access. You may consult INI documentation
and discussions online, but treat the vendored spec file in `specs/` as the
authoritative baseline for behavior in this task.
