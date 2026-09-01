## Goal

Implement a MoonBit **URI parser and reference resolver** (RFC 3986) that is
compatible with this repository's test suite. The authoritative references are
vendored in:

- `specs/rfc3986.txt`
- `specs/uri.md`

## What This Task Is Really About

This is an exercise in building a **real parser** for a real syntax.
The goal is to parse URIs and resolve relative references correctly in
general — not to hardcode behaviors for specific test strings.

A proper implementation will have:

- A component splitter that follows the RFC 3986 generic syntax
  (`scheme ":" hier-part [ "?" query ] [ "#" fragment ]`)
- Validation of the characters allowed in each component (including
  percent-encoding and IPv6/IPvFuture host literals)
- The Section 5.2 reference-resolution algorithm, including proper
  dot-segment removal

**Important mindset**: If the test suite were regenerated with different
hostnames, paths, or resolution examples, your implementation should still
pass. If it wouldn't, you haven't built a parser — you've built a lookup table.

## Approach

Build incrementally:

1. **Component splitting**: scheme, authority (userinfo/host/port), path,
   query, fragment.
2. **Validation**: reject invalid schemes, characters, percent-encodings,
   ports, and malformed IPv6/IPvFuture literals.
3. **Stringification**: `Uri::to_string` reproducing exactly the components
   that are present.
4. **Reference resolution**: RFC 3986 Section 5.2, validated against the
   Section 5.4 normal and abnormal examples.

Run tests frequently while adding features.

Important: The core logic must be implemented in MoonBit.

## Scope

In scope for this implementation:

- RFC 3986 generic syntax with authority-form URIs
  (`//userinfo@host:port/path`)
- Non-hierarchical URIs (`mailto:`, `urn:`, `tel:`, `data:`): the remainder
  after the scheme is the path
- Relative references (path-only, query-only, fragment-only, network-path)
- IPv6 (`[::1]`) and IPvFuture (`[v1.x]`) host literals, including zone IDs
- Percent-encoding validation (components are stored still-encoded; no
  decoding)
- Reference resolution per Section 5.2 with dot-segment removal per
  Section 5.2.4

Out of scope (not required by current tests):

- Percent-decoding or normalization beyond what the tests require
- IDNA / punycode processing
- Scheme-specific semantics (default ports, etc.)

## Required API

Complete the declarations in `rfc3986_spec.mbt`.

Implementation notes:

- You can **freely decide** the project structure (modules/files/directories),
  the parsing strategy, and any internal data structures.
- Do **not** modify the following files:
  - `rfc3986_spec.mbt` - API specification
  - `uri_qc.mbt` - Property-test generators
  - `specs/` folder - Reference documents
  - `*_pub_test.mbt` - Public test files (`uri_pub_test.mbt`)
  - `*_priv_test.mbt` - Private test files (`uri_priv_test.mbt`)
- Implement the required declarations by adding new `.mbt` files as needed.
- **You may add additional test files** (e.g., xxx_test.mbt) if needed for testing and maintenance purposes
  - Create additional test files (e.g., `xxx_test.mbt`) to validate edge cases
  - Derive test scenarios from `specs/rfc3986.txt` and `specs/uri.md`
  - All added tests must remain faithful to the RFC 3986 behaviors used by this repo

Required entry points:

- `Uri::parse(input : String) -> Uri raise`
- `Uri::resolve(base : Uri, reference : String) -> Uri raise`
- `Uri::to_string(self : Uri) -> String`

The parse result type is fixed by the spec: `Uri` is a `pub(all)` struct
whose fields (`scheme`, `userinfo`, `host`, `port`, `path`, `query`,
`fragment`) are read directly by the tests and constructed directly by the
property-test generators in `uri_qc.mbt`.

## Behavioral rules

- Components are stored as parsed, still percent-encoded; `None` means the
  component is absent, `Some("")` means it is present but empty.
- `host` holds IPv6/IPvFuture literals **including** the surrounding
  brackets (e.g. `Some("[::1]")`).
- Schemes may be normalized to lowercase; nothing else is normalized.
- A reference without a scheme parses with `scheme == ""`.
- Reject invalid inputs as the invalid tests require: forbidden raw characters
  (spaces, `<>`, `\`, `^`, backtick, `{}`, `|`, control characters),
  malformed percent-encodings, non-numeric ports, malformed IPv6/IPvFuture
  literals, invalid schemes, and ambiguous authorities.
- `Uri::resolve` follows RFC 3986 Section 5.2 exactly (strict mode: `http:g`
  stays `http:g`); ad-hoc path joining will fail the abnormal examples.
- `Uri::to_string` reproduces exactly the components present, with `?`, `#`,
  `//`, `@`, and `:` delimiters emitted precisely when the corresponding
  component is present (even when empty). `Uri::parse(uri.to_string()) == uri`
  must hold for every well-formed `Uri`; the round-trip is checked by a
  property-based test.

## Test execution

```bash
moon test
```


## Constraints

### 1. Test Requirements

**All tests must pass for task completion**:

The model should keep running until all tests pass.

- **Public tests** (`*_pub_test.mbt`): 16 cases (including two property-based tests), visible in this repository for development and debugging
- **Private tests** (`*_priv_test.mbt`): 125 additional cases that decide the score. They are **withheld while you work** — expect them to be absent from this directory, and do not go looking for them. Your `moon test` therefore exercises the public tests only; the private suite is run against your implementation afterwards.

**CRITICAL - Full Suite Evaluation**:

Passing only the public tests is **INSUFFICIENT**. A green `moon test` is necessary but not sufficient: it covers roughly 10% of the cases that decide the outcome. The task is complete only when the private suite passes too — and you cannot run it yourself.

**Why Private Tests Matter**:
- **Coverage**: Private tests represent 90% of the total evaluation - they are the primary measure of success
- **Comprehensiveness**: Validate full RFC 3986 behavior compliance, including edge cases, corner cases, and subtle semantic rules not exposed in public tests
- **Real-world scenarios**: Test combinations and patterns that occur in actual URIs but may not be obvious from the spec
- **Implementation integrity**: you cannot see these cases, so the only way to pass them is a genuine parser rather than a lookup table for the fixtures you can see

**Evaluation Process**:

Make the public tests pass by running `moon test` in this directory, and
iterate until they do, then `finish`.

There is **no submission step and no evaluation server** in this environment:
`moon test` is the command you run, and the withheld private tests are run
against your implementation afterwards.

Because the withheld tests (~90% of the suite) decide success, a genuine,
general implementation is essential: do **not** hardcode or memorize responses
to the fixtures — build a real parser/resolver that works for arbitrary
inputs within RFC 3986.

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
- Solutions must be real parsers/resolvers, not test-specific lookup tables
- No hardcoded mappings derived from test fixtures
- Implementation should work for arbitrary URIs within RFC 3986

### 3. Software Engineering Standards

**Modularity and Organization**:
- The required declarations in `rfc3986_spec.mbt` belong to the root `uri`
  package. Tests call root-package APIs such as `Uri::parse`, so those
  declarations must be implemented or forwarded from the root package.
- You may organize implementation across root-level files by functional area
  (for example, parsing, validation, resolution, and stringification).
- If you create subdirectories as separate MoonBit packages, wire them through
  package configuration and keep root-package implementations, `pub using`
  re-exports, or forwarding functions so the required root `uri` APIs remain
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
- Logical separation of concerns (splitting → validation → resolution)
- Minimize coupling between modules
- Use appropriate abstractions (types, enums, structs)
- Avoid global mutable state

**Example directory structure**:
```
uri/
├── moon.mod
├── moon.pkg
├── rfc3986_spec.mbt       # API declarations (do not modify)
├── uri.mbt                # Main entry point
├── parser.mbt             # Component splitting and validation
├── resolve.mbt            # Reference resolution (Section 5.2)
└── error.mbt              # Error types
```

These standards ensure your code is maintainable, understandable, and follows professional software engineering practices.

## Documentation

**Write a comprehensive README.md**:

Your implementation must include a `README.md` file that documents:

- **Project overview**: What this parser implements and its purpose
- **Architecture**: High-level design decisions and module organization
- **Implementation approach**: Key algorithms, data structures, and parsing strategy
- **Usage examples**: How to use the API (parsing and resolution code)
- **Testing**: How to run tests and interpret results
- **Design decisions**: Rationale for important technical choices

The README should be written **based on your actual implementation** - describe the code you built, not generic information from specifications. It should help future developers understand your codebase quickly.

## External references

This environment has public network access. You may consult RFC 3986
documentation and discussions online, but treat the vendored spec files in
`specs/` as the authoritative baseline for behavior in this task.
