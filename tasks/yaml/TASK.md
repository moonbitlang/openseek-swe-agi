## Goal

Implement a MoonBit **YAML 1.2.2 parser** that is compatible with this
repository's test suite. The authoritative references are vendored in:

- `specs/1.2.2/spec.md` — the YAML 1.2.2 specification
- `specs/yaml.md` — this repo's parser-oriented summary and conventions

## What This Task Is Really About

This is an exercise in building a **real indentation-sensitive parser**
for a real data format. The goal is to write code that can correctly load
YAML streams in general — not to hardcode behaviors for specific test
strings.

A proper implementation will have:

- A **scanner** layer that handles YAML's lexical shapes: indentation,
  block and flow indicators, plain / single-quoted / double-quoted
  scalars and their line folding, escapes, comments, line breaks
  (LF, CRLF, CR), directives and document markers
- A **parser** for the block structure (sequences, mappings, explicit
  keys, compact nested collections, literal and folded block scalars with
  indentation and chomping indicators) and the flow structure (`[...]`,
  `{...}`, single-pair mappings, multi-line flow scalars)
- A **composer/loader** that applies the semantics: `%TAG` handle
  expansion, tag resolution under the core schema, anchors and aliases,
  key uniqueness, and produces the final `Yaml` value

**Important mindset**: If the test suite were regenerated with different
literal values, different key names, or different whitespace/comment
placement, your implementation should still pass. If it wouldn't, you
haven't built a parser — you've built a lookup table.

## Approach

Build incrementally:

1. **Lines and characters**: line breaks (LF/CRLF/CR), the printable
   character set, indentation analysis, comments, document markers and
   directives.
2. **Scalars**: plain scalars and where they end, single- and
   double-quoted scalars with escapes and folding, block scalars (`|`,
   `>`) with indentation and chomping indicators.
3. **Block collections**: sequences, mappings, explicit keys, compact
   nested forms, indentation rules.
4. **Flow collections**: sequences, mappings, explicit `?` entries,
   single-pair mappings inside sequences, comments and line breaks inside
   flow content.
5. **Loading**: core-schema resolution of plain scalars, explicit tags
   (`!!str`, `!!int`, ...), `%TAG` handles, anchors/aliases, duplicate
   keys, multi-document streams.
6. **Printing**: a serializer whose output parses back to the same
   stream.

Run tests frequently while adding features.

Important: The core logic must be implemented in MoonBit.

## Scope

In scope (YAML 1.2.2, core schema, exactly):

- Streams of zero or more documents: `---`, `...`, bare and explicit
  documents, `%YAML` and `%TAG` directives (reserved directives are
  ignored), byte order marks where the spec allows them
- Scalars: plain, single-quoted, double-quoted (all §5.7 escapes), literal
  and folded block scalars
- Block and flow sequences and mappings, explicit keys, keys of any node
  kind, comments in every position the spec allows
- Node properties: anchors, aliases (as values and as keys), tags
  (standard, local, named-handle, verbatim), tag/content and tag/kind
  validation
- Core-schema resolution: `null`, booleans, decimal/octal/hex integers
  of any size, floats including `.inf`/`.nan`, everything else a string
- Printing: `print` serializes a stream back to YAML text that parses to
  an equal stream (the exact layout is unspecified)

Out of scope:

- YAML 1.1 semantics (`yes`/`no` booleans, `1_000`, sexagesimal numbers,
  `%TAG` directives carrying across documents): a `%YAML 1.1` document is
  processed as 1.2
- Native types for the 1.1 type repository (`!!set`, `!!omap`,
  `!!binary`, `!!timestamp`, ...): such nodes load by their kind
- Cyclic structures: an alias into a node still being loaded is an error

## Required API

Complete the declarations in `yaml_spec.mbt`.

Implementation notes:

- You can **freely decide** the project structure (modules/files), the
  parsing strategy, and any internal data structures.
- Do **not** modify the following files:
  - `yaml_spec.mbt` - API specification (types, `Eq`, `Hash`, `parse`,
    `print`)
  - `yaml_qc.mbt` - Property-test generators
  - `specs/` folder - Reference documents
  - `*_pub_test.mbt` - Public test file (`yaml_pub_test.mbt`)
  - `*_priv_test.mbt` - Private test file (`yaml_priv_test.mbt`)
- Implement the required declarations by adding new `.mbt` files as needed.
- **You may add additional test files** (e.g., `xxx_test.mbt`) if needed
  for testing and maintenance purposes:
  - Create test files to validate edge cases
  - Derive test scenarios from `specs/1.2.2/spec.md`
  - All added tests must remain faithful to YAML 1.2.2

Required entry points:

- `@yaml.parse(input : StringView) -> Array[Yaml] raise`
- `@yaml.print(docs : Array[Yaml]) -> String`

The result type is fixed by the spec: `Yaml` is a `pub(all)` enum in
`yaml_spec.mbt` whose values the tests construct directly and compare with
`assert_eq` (using the `Eq` implementation shipped in the spec — floats
compare IEEE-style with NaN == NaN — and the `Hash` that makes `Yaml`
values usable as `Map` keys). The property-test generators in
`yaml_qc.mbt` build streams from this type and check
`parse(print(docs)) == docs`.

## Behavioral rules

- Follow YAML 1.2.2 exactly, with the core schema (§10.3) for resolution;
  `%YAML 1.1` documents are processed as 1.2.
- `parse` returns every document of the stream, in order: `[]` for an
  empty or comment-only stream, `Null` for an empty document.
- Plain scalars resolve by the core-schema regular expressions; quoted
  and block scalars are always strings; integers are unbounded
  (`BigInt`).
- Explicit standard tags force their resolution (`!!int "12"` is
  `Integer(12)`, `!!str 12` is `String("12")`); content that does not
  satisfy the tag, or a tag on the wrong kind of node, is an error. Every
  other tag loads the node by its kind.
- `%TAG` directives are honoured when expanding shorthands and scope to
  one document; an undeclared named handle is an error.
- Aliases are copies of the most recent preceding node with that anchor;
  undefined aliases, aliases to a previous document's anchors, cycles and
  properties on aliases are errors.
- Mappings are maps with node keys: keys are unique by node equality
  (`1` and `0x1` collide, `1` and `"1"` do not), duplicates are an error,
  entry order is not part of the value.
- Reject structural and lexical errors as required by the invalid tests:
  tabs as indentation, wrong indentation, unterminated quoted scalars and
  flow collections, invalid escapes, content after a completed node,
  misplaced or repeated directives, block collections on the `---` line,
  C0 control characters, misplaced byte order marks, and the other rules
  of the spec — in every document of the stream.
- `print` emits YAML text whose exact layout is unspecified, but
  `parse(print(docs)) == docs` must hold for every well-formed stream (see
  `yaml_spec.mbt` for the well-formedness contract); the round-trip is
  checked by a property-based test over generated streams.

## Test execution

```bash
moon test
```

## Constraints

### 1. Test Requirements

**All tests must pass for task completion**:

The model should keep running until all tests pass.

- **Public tests** (`*_pub_test.mbt`): 49 cases (including two
  property-based tests), visible in this repository for development and
  debugging
- **Private tests** (`*_priv_test.mbt`): 403 additional cases
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
- **Comprehensiveness**: Validate full YAML 1.2.2 compliance, including
  edge cases, corner cases, and subtle semantic rules not exposed in
  public tests
- **Real-world scenarios**: Test combinations and patterns that occur in
  actual YAML files (most cases come from the official YAML test suite)
  but may not be obvious from the spec
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
arbitrary YAML 1.2.2 input.

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
- Implementation should work for arbitrary valid YAML 1.2.2 inputs

### 3. Software Engineering Standards

**Modularity and Organization**:
- The required declarations in `yaml_spec.mbt` belong to the root `yaml`
  package. Tests call the root-package API `@yaml.parse` and
  `@yaml.print`, so those declarations must be implemented in (or
  forwarded to) the root package.
- You may organize implementation across root-level files by functional
  area (for example, scanning, block structure, flow structure, scalars,
  loading, printing).
- If you create subdirectories as separate MoonBit packages, wire them
  through package configuration and keep root-package implementations,
  `pub using` re-exports, or forwarding functions so the required root
  `yaml` API remains available.
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
- Logical separation of concerns (scanning → parsing → loading)
- Minimize coupling between modules
- Use appropriate abstractions (types, enums, structs)
- Avoid global mutable state

**Example directory structure**:
```
yaml/
├── moon.mod
├── moon.pkg
├── yaml_spec.mbt          # API specification (do not modify)
├── yaml_qc.mbt            # Property-test generators (do not modify)
├── yaml.mbt               # Main entry point
├── scanner.mbt            # Lines, indentation, characters
├── scalars.mbt            # Plain/quoted/block scalars, escapes, folding
├── block.mbt              # Block sequences and mappings
├── flow.mbt               # Flow sequences and mappings
├── loader.mbt             # Tags, schema resolution, anchors, keys
└── printer.mbt            # Serialization
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
  resulting stream)
- **Testing**: How to run tests and interpret results
- **Design decisions**: Rationale for important technical choices

The README should be written **based on your actual implementation** -
describe the code you built, not generic information from specifications.
It should help future developers understand your codebase quickly.

## External references

This environment has public network access. You may consult upstream YAML
documentation, the YAML test suite and discussions online, but treat the
vendored spec files in `specs/` as the authoritative baseline for behavior
in this task.
