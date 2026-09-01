## Goal

Implement a MoonBit **WHATWG URL parser** — the `URL` class of the WHATWG
URL Standard, with canonical serialization and the standard's setter
semantics — compatible with this repository's test suite. The
authoritative references are vendored in:

- `specs/url.bs` — the WHATWG URL Standard (Bikeshed source, snapshot)
- `specs/url.md` — this repo's parser-oriented summary and conventions

## What This Task Is Really About

This is an exercise in implementing the **WHATWG URL parsing algorithm**
— a state machine with many special cases — not an RFC 3986 URI
splitter. The test suite is built from the Web Platform Tests (WPT)
`urltestdata.json` and `setters_tests.json` fixtures, which are the
ecosystem's conformance suite for this exact algorithm.

A proper implementation will have:

- a **URL record** model (scheme, username, password, host, port, path,
  query, fragment, opaque-path flag)
- the **basic URL parser** state machine, including relative resolution
  against a base URL, special vs non-special schemes, and `file:` rules
- **host parsing**: domains (with IDNA/punycode where the fixtures need
  it), IPv4 (decimal/octal/hex, overflow rules), IPv6 (with canonical
  compressed serialization), opaque hosts, and the empty host
- **percent-encoding** with the standard's per-component encode sets
- the **URL serializer** and component getters
- the **setter algorithms** (`set_protocol` … `set_hash`) exactly as the
  standard defines them

**Important mindset**: If the fixtures were regenerated with different
hosts, paths, or code points, your implementation should still pass. If
it wouldn't, you haven't built a URL parser — you've built a lookup
table.

## Approach

Build incrementally:

1. URL record model, serializer, and getters for simple absolute URLs.
2. Parser state machine for special schemes and plain domain hosts.
3. Relative resolution against a base URL.
4. Full host parsing: IPv4 canonicalization, IPv6, opaque hosts, the
   domain-to-ASCII step.
5. `file:` handling (Windows drive letters, `localhost`, empty host).
6. Setters matching the standard's setter steps.
7. Percent-encode sets and the tricky serialization corner cases (for
   example the `/.//` path prefix that keeps serialization round-trip
   safe).

Run tests frequently while adding features.

Important: The core logic must be implemented in MoonBit.

## Scope

In scope (as required by `url_spec.mbt` and the tests):

- `Url::parse(input, base?)` — the basic URL parser over the full input
  space: scheme parsing, credentials, hosts, ports, paths (list and
  opaque), query, fragment, tab/newline stripping, relative references
- Serialization and getters: `to_string`, `href`, `protocol`,
  `username`, `password`, `host`, `hostname`, `port`, `pathname`,
  `search`, `hash`, `origin`
- Setters: `set_href`, `set_protocol`, `set_username`, `set_password`,
  `set_host`, `set_hostname`, `set_port`, `set_pathname`, `set_search`,
  `set_hash`
- Enough of IDNA (UTS 46 mapping, punycode encoding, forbidden code
  points) to satisfy the WPT vectors in the suite

Out of scope:

- Networking, DNS, or fetch behavior
- The `URLSearchParams` API
- Validation-error reporting (the standard's non-fatal "validation
  errors" are not observable in this suite)

## Required API

Complete the declarations in `url_spec.mbt`.

Implementation notes:

- You can **freely decide** the project structure (modules/files), the
  parsing strategy, and any internal data structures.
- Do **not** modify the following files:
  - `url_spec.mbt` - API specification (the `Url` type and its methods)
  - `url_qc.mbt` - Property-test generators
  - `specs/` folder - Reference documents
  - `*_pub_test.mbt` - Public test file (`url_pub_test.mbt`)
  - `*_priv_test.mbt` - Private test file (`url_priv_test.mbt`)
- Implement the required declarations by adding new `.mbt` files as
  needed.
- **You may add additional test files** (e.g., `xxx_test.mbt`) if needed
  for testing and maintenance purposes:
  - Create test files to validate edge cases
  - Derive test scenarios from `specs/url.bs`
  - All added tests must remain faithful to the WHATWG URL Standard

Required entry points (see `url_spec.mbt` for exact signatures and
semantics):

- `@url.Url::parse(input : String, base? : Url) -> Url raise`
- getters `to_string`, `href`, `protocol`, `username`, `password`,
  `host`, `hostname`, `port`, `pathname`, `search`, `hash`, `origin`
- setters `set_href`, `set_protocol`, `set_username`, `set_password`,
  `set_host`, `set_hostname`, `set_port`, `set_pathname`, `set_search`,
  `set_hash`

`Url` is an opaque type declared in `url_spec.mbt`: you define its
representation. Tests only observe a `Url` through the getters and
mutate it through the setters, so the setters must mutate the receiver
in place (like the JavaScript `URL` class).

## Behavioral rules

- Follow the WHATWG URL Standard's basic URL parser exactly; the WPT
  fixtures transcribed into the test files are the canonical expected
  results.
- `parse` raises on any input the algorithm rejects (the error type is
  yours to choose; tests only assert that it raises). Setters never
  raise: an invalid new value leaves the URL unchanged, exactly as the
  standard's setter steps do.
- Serialization must be canonical and deterministic: lowercased scheme,
  host in canonical form (IDNA-mapped domain, dotted-decimal IPv4,
  compressed IPv6), default ports omitted, dot segments resolved at
  parse time, percent-encoding per the component's encode set, and the
  `/.//` prefix where the standard requires it.
- `parse(to_string(u))` must succeed and observe identically to `u`
  (same href and same getters) for every `u` produced by a successful
  parse — the standard's idempotence guarantee, checked by a
  property-based test over generated inputs (generators are shipped in
  `url_qc.mbt`, do not modify).

## Test execution

```bash
moon test
```

## Constraints

### 1. Test Requirements

**All tests must pass for task completion**:

The model should keep running until all tests pass.

- **Public tests** (`*_pub_test.mbt`): 129 cases (including two
  property-based tests), visible in this repository for development and
  debugging
- **Private tests** (`*_priv_test.mbt`): 1093 additional cases, vendored
  as ordinary files in this local task and run by `moon test`

**CRITICAL - Full Suite Evaluation**:

Passing only the public tests is **INSUFFICIENT** and will result in
task failure. The task is complete **only when both public and private
test suites in this directory pass**.

**Why Private Tests Matter**:
- **Coverage**: Private tests represent ~90% of the total evaluation -
  they are the primary measure of success
- **Comprehensiveness**: They carry the bulk of the WPT conformance
  vectors — host parsing, `file:` URLs, relative resolution, IDNA,
  percent-encoding, and all nine setter families
- **Real-world scenarios**: WPT vectors encode the URL behavior real
  browsers agree on, including many corner cases invisible in the
  public slice
- **Implementation integrity**: Even though these tests are visible
  here, the goal is a genuine parser, not a lookup table for fixture
  outputs

**Evaluation Process**:

Make all tests pass locally by running `moon test` in this directory.
Iterate until they pass, then `finish`.

There is **no submission step and no evaluation server** in this
environment. `moon test` is the grading command for this vendored native
workflow.

Because the private tests (~90% of the suite) decide success, a genuine,
general implementation is essential: do **not** hardcode or memorize
responses to the fixtures — build a real parser that works for arbitrary
URL input.

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
- Implementation should work for arbitrary URL input

### 3. Software Engineering Standards

**Modularity and Organization**:
- The required declarations in `url_spec.mbt` belong to the root `url`
  package. Tests call the root-package API `@url.Url::parse`, so those
  declarations must be implemented in (or forwarded to) the root
  package.
- You may organize implementation across root-level files by functional
  area (for example, parser state machine, host parsing, IDNA,
  percent-encoding, serialization, setters).
- If you create subdirectories as separate MoonBit packages, wire them
  through package configuration and keep root-package implementations,
  `pub using` re-exports, or forwarding functions so the required root
  `url` API remains available.
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
- Logical separation of concerns (state machine → host parsing →
  serialization → setters)
- Minimize coupling between modules
- Use appropriate abstractions (types, enums, structs)
- Avoid global mutable state

**Example directory structure**:
```
url/
├── moon.mod
├── moon.pkg
├── url_spec.mbt           # API specification (do not modify)
├── url_qc.mbt             # Property-test generators (do not modify)
├── url.mbt                # Url type and API entry points
├── parser.mbt             # Basic URL parser state machine
├── host.mbt               # Host parsing (domain/IPv4/IPv6/opaque)
├── idna.mbt               # Domain-to-ASCII (UTS 46 subset, punycode)
├── percent.mbt            # Percent-encoding and encode sets
├── serialize.mbt          # URL and host serialization
└── setters.mbt            # Setter algorithms
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
- **Usage examples**: How to use the API (parsing code, reading and
  mutating the resulting URL)
- **Testing**: How to run tests and interpret results
- **Design decisions**: Rationale for important technical choices

The README should be written **based on your actual implementation** -
describe the code you built, not generic information from
specifications. It should help future developers understand your
codebase quickly.

## External references

This environment has public network access. You may consult the WHATWG
URL Standard online (https://url.spec.whatwg.org/) and the WPT url test
suite, but treat the vendored spec files in `specs/` as the
authoritative baseline for behavior in this task.
