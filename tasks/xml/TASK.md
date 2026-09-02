## Goal

Implement a MoonBit **XML 1.0 (Fifth Edition) parser** — a non-validating
processor that checks well-formedness and processes the internal DTD
subset — that is compatible with this repository's test suite. The
authoritative references are vendored in:

- `specs/REC-xml-20081126.html` — Extensible Markup Language (XML) 1.0
  (Fifth Edition), W3C Recommendation (verbatim)
- `specs/xml.md` — this repo's parser-oriented summary and conventions

## What This Task Is Really About

This is an exercise in building a **real parser** for a real data format.
The goal is to write code that can correctly parse XML documents in
general — not to hardcode behaviors for specific test strings.

A proper implementation will have:

- A **tokenizer/scanner** layer for XML's lexical shapes (tags, attribute
  values with both quote styles, comments, processing instructions, CDATA
  sections, character and entity references, the character classes of
  `Char`, `NameStartChar` and `NameChar`, line-end normalization)
- A **parser** for the document grammar (XML declaration, document type
  declaration with its internal subset, element nesting, content) and for
  every markup declaration kind (`ELEMENT`, `ATTLIST`, `ENTITY`,
  `NOTATION`) with their exact grammar
- An **entity and attribute layer** that applies the rules a
  non-validating processor must follow (section 5.1): construction of
  entity replacement text, expansion of internal entities in content and
  in attribute values, attribute-value normalization by declared type,
  default attributes, and the well-formedness constraints on references
  (declared, no recursion, no `<` in attribute values, no external
  entities in attribute values, ...)

**Important mindset**: If the test suite were regenerated with different
element names, different entity values, different white-space placement
or a different mix of declarations, your implementation should still
pass. If it wouldn't, you haven't built a parser — you've built a lookup
table.

## Approach

Build incrementally:

1. **Characters and names**: line-end normalization (section 2.11), the
   `Char` production, the Fifth Edition `Name` productions.
2. **Elements and content**: start/end/empty-element tags, attributes,
   nesting, character data, CDATA sections, comments, PIs, character
   references, the predefined entities.
3. **The prolog**: the XML declaration (position and pseudo-attribute
   order), `Misc`, the document type declaration and the syntax of every
   declaration in the internal subset.
4. **Entities and attribute semantics**: replacement text (section 4.5),
   entity expansion in content (parsed as content) and in attribute
   values (included in literal), attribute-value normalization (section
   3.3.3), defaults, the "Entity Declared" logic and `EntityRef`.
5. **Printing**: `print` for the round-trip property.

Run tests frequently while adding features.

Important: The core logic must be implemented in MoonBit.

## Scope

In scope (XML 1.0 Fifth Edition, well-formedness only):

- Every well-formedness constraint and the full document grammar,
  including the grammar of the internal DTD subset
- The duties of a non-validating processor with respect to the internal
  subset: internal entity expansion, attribute-value normalization by
  declared type, default attribute values (section 5.1)
- Character data as merged `Text` events; comments and PIs everywhere
  they may appear, including inside the internal subset
- `EntityRef` events for references the parser recognizes but cannot
  expand without reading external entities (external parsed entities;
  undeclared entities when "Entity Declared" is only a validity
  constraint)
- Printing: `print` serializes events back to XML text that parses to an
  equal event sequence (the exact layout is unspecified)

Out of scope:

- Validation (content models, ID rules, `#REQUIRED`, root-name
  matching — all validity constraints are ignored, never reported)
- Reading the external subset, external entities or parameter entities
  (never fetched; parameter entities are never expanded)
- Namespace processing (`a:b` is a plain name, `xmlns` an ordinary
  attribute)
- Encodings: the input is already decoded, so encoding declarations are
  only checked for syntax and reported
- XML 1.1

## Required API

Complete the declarations in `xml_spec.mbt`.

Implementation notes:

- You can **freely decide** the project structure (modules/files), the
  parsing strategy, and any internal data structures.
- Do **not** modify the following files:
  - `xml_spec.mbt` - API specification (`Event`, `parse`, `print`)
  - `xml_qc_test.mbt` - Property-test generators
  - `specs/` folder - Reference documents
  - `*_pub_test.mbt` - Public test file (`xml_pub_test.mbt`)
  - `*_priv_test.mbt` - Private test file (`xml_priv_test.mbt`)
- Implement the required declarations by adding new `.mbt` files as needed.
- **You may add additional test files** (e.g., `xxx_test.mbt`) if needed
  for testing and maintenance purposes:
  - Create test files to validate edge cases
  - Derive test scenarios from `specs/REC-xml-20081126.html`
  - All added tests must remain faithful to XML 1.0 (Fifth Edition)

Required entry points:

- `@xml.parse(input : StringView) -> Array[Event] raise`
- `@xml.print(events : Array[Event]) -> String`

The result type is fixed by the spec: `Event` is a `pub(all)` enum in
`xml_spec.mbt` whose values the tests construct directly and compare with
`assert_eq` (attributes are a `Map`, so their order is irrelevant). The
property-test generators in `xml_qc_test.mbt` build event sequences from
it and check `parse(print(events)) == events`.

## Behavioral rules

- Follow XML 1.0 (Fifth Edition) exactly: every well-formedness
  constraint is an error; no validity constraint is.
- Every element is `Start` then `End`, whether written `<a/>` or
  `<a></a>`; attributes are a map of normalized values including
  defaults from the internal subset.
- Character data merges into one `Text` per run (text, CDATA, character
  references and expanded entities together); empty text is no event;
  there is no `Text` outside the root element.
- Line ends are normalized on input (CRLF and CR become LF); characters
  from character references are not.
- The XML declaration is reported as written (`None` for omitted parts);
  any `1.x` version is accepted; encoding names are checked for syntax
  only.
- Comments and PIs are events wherever they occur, including inside the
  internal subset, in document order; PI data starts after the white
  space following the target.
- The internal subset is processed per section 5.1: declarations up to
  the first parameter-entity reference between declarations are used
  (first declaration wins); later ones are checked but only used when
  `standalone="yes"`. Parameter entities are never expanded.
- Entity references in content: predefined and internal entities expand
  (replacement text parsed as well-formed content); external parsed
  entities, and undeclared entities where "Entity Declared" is only a
  validity constraint (external subset or parameter-entity reference
  present, not `standalone="yes"`), become `EntityRef`; unparsed
  entities and other undeclared entities are errors. In attribute
  values every unexpandable reference is an error.
- No namespace processing and no encoding processing (see Scope).
- `print` emits XML text whose exact layout is unspecified, but
  `parse(print(events)) == events` must hold for every well-formed event
  sequence (see `xml_spec.mbt` for the well-formedness contract); the
  round-trip is checked by a property-based test over generated documents
  and by deterministic tests covering every character that must be
  escaped.

## Test execution

```bash
moon test
```

## Constraints

### 1. Test Requirements

**All tests must pass for task completion**:

The model should keep running until all tests pass.

- **Public tests** (`*_pub_test.mbt`): 78 cases (including two
  property-based tests), visible in this repository for development and
  debugging
- **Private tests** (`*_priv_test.mbt`): 719 additional cases
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
- **Comprehensiveness**: Validate full XML 1.0 (Fifth Edition)
  well-formedness checking and internal-subset processing, drawn from the
  W3C XML Conformance Test Suite, including edge cases, corner cases, and
  subtle rules not exposed in public tests
- **Real-world scenarios**: Test combinations and patterns that occur in
  actual XML documents but may not be obvious from the spec
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
arbitrary XML 1.0 input.

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
- Implementation should work for arbitrary well-formed XML 1.0 input

### 3. Software Engineering Standards

**Modularity and Organization**:
- The required declarations in `xml_spec.mbt` belong to the root `xml`
  package. Tests call the root-package API `@xml.parse` and `@xml.print`,
  so those declarations must be implemented in (or forwarded to) the root
  package.
- You may organize implementation across root-level files by functional
  area (for example, character classes, scanning, the prolog and DTD,
  content, entities, printing).
- If you create subdirectories as separate MoonBit packages, wire them
  through package configuration and keep root-package implementations,
  `pub using` re-exports, or forwarding functions so the required root
  `xml` API remains available.
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
- Logical separation of concerns (scanning → document grammar → entity
  and attribute semantics → printing)
- Minimize coupling between modules
- Use appropriate abstractions (types, enums, structs)
- Avoid global mutable state

**Example directory structure**:
```
xml/
├── moon.mod
├── moon.pkg
├── xml_spec.mbt           # API specification (do not modify)
├── xml.mbt                # Main entry point
├── chars.mbt              # Char / Name character classes
├── scanner.mbt            # Cursor, white space, names, literals
├── prolog.mbt             # XML declaration, DOCTYPE, internal subset
├── content.mbt            # Elements, attributes, character data
├── entities.mbt           # Replacement text, expansion, normalization
└── printer.mbt            # print
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
  resulting events)
- **Testing**: How to run tests and interpret results
- **Design decisions**: Rationale for important technical choices

The README should be written **based on your actual implementation** -
describe the code you built, not generic information from specifications.
It should help future developers understand your codebase quickly.

## External references

This environment has public network access. You may consult the W3C XML
specifications and the XML Conformance Test Suite online, but treat the
vendored spec files in `specs/` as the authoritative baseline for behavior
in this task.
