## Goal

Implement a MoonBit **streaming Protocol Buffers wire-format codec** — a
reader and a writer for the binary encoding, working over chunked byte
sources — that is compatible with this repository's test suite. The
authoritative references are vendored in:

- `specs/encoding.md` — the Protocol Buffers wire-format specification
  ("Encoding", protobuf.dev)
- `specs/protobuf.md` — this repo's codec-oriented summary and conventions

## What This Task Is Really About

This is an exercise in implementing a **real binary codec** for a real
wire format. The goal is to write code that encodes and decodes the
Protocol Buffers wire format in general — not to hardcode behaviors for
specific byte strings.

A proper implementation will have:

- A **streaming input layer** over the `Reader` trait that reassembles
  values from partial reads: a `read` call may return fewer bytes than
  asked for, so every varint, fixed-width value and length-delimited
  payload must be gathered across as many calls as it takes, and end of
  stream in the middle of a value must be an error
- **Varint** encoding and decoding (base-128, at most ten bytes),
  including zigzag for `sint32`/`sint64`, sign extension for negative
  `int32`/`enum` values, and the low-32-bit truncation rules of the
  32-bit readers
- **Fixed-width** little-endian encoding for `fixed32`/`sfixed32`/`float`
  and `fixed64`/`sfixed64`/`double`, bit-exact for floating point
- **Length-delimited** records: `bytes`, UTF-8-validated `string`s,
  packed repeated fields decoded through a window confined to the payload
  (`LimitedReader`), and int32-bounded length prefixes
- **Key handling**: `(field_number << 3) | wire_type` in both directions,
  rejection of field number 0 and the undefined wire types 6 and 7, and
  `read_unknown` to skip any field a decoder does not know — including
  the deprecated but still-on-the-wire groups (SGROUP/EGROUP)

**Important mindset**: If the test suite were regenerated with different
values, different field numbers, or different chunking patterns, your
implementation should still pass. If it wouldn't, you haven't built a
codec — you've built a lookup table.

## Approach

Build incrementally:

1. **Byte plumbing**: `BytesReader`, a "read exactly n bytes" helper that
   loops over partial reads, and `LimitedReader` as a window over another
   reader.
2. **Varints**: read/write with the ten-byte limit, overflow and
   truncation errors; then the typed readers/writers (`int32`, `int64`,
   `uint32`, `uint64`, `sint32`, `sint64`, `bool`, `enum`) on top.
3. **Keys**: `read_tag`/`write_tag` with the validity rules.
4. **Fixed width**: the six little-endian scalar types, bit-exact floats.
5. **Length-delimited**: `bytes`, `string` with strict UTF-8 validation,
   the int32 bound on length prefixes.
6. **Packed fields and unknown fields**: `read_packed` through a
   `LimitedReader`; `read_unknown` for every wire type, groups included.
7. **Chunking**: run everything through the one-byte-per-call reader in
   the public tests and fix whatever assumed a single read fills the
   buffer.

Run tests frequently while adding features.

Important: The core logic must be implemented in MoonBit.

## Scope

In scope (the Protocol Buffers wire format, exactly as `specs/encoding.md`
defines it):

- Keys: field numbers from 1, wire types 0 (VARINT), 1 (I64), 2 (LEN),
  3 (SGROUP), 4 (EGROUP), 5 (I32); 6 and 7 are undefined
- Varints: any encoding of at most ten bytes (non-minimal ones included),
  bits beyond the 64th dropped, an eleventh byte is an overflow; writers
  emit minimal encodings
- Scalars: `int32`, `int64`, `uint32`, `uint64`, `sint32`, `sint64`,
  `bool`, `enum`, `fixed32`, `fixed64`, `sfixed32`, `sfixed64`, `float`,
  `double`, `bytes`, `string`
- Length-delimited payloads with int32-bounded length prefixes; packed
  repeated fields; skipping unknown fields and groups
- Streaming: correct behavior over a reader that returns one byte per call
- Round-tripping: everything `write_*` produces reads back with the
  matching `read_*` (a property-based test checks generated messages
  through a whole-buffer reader and a one-byte reader)

Out of scope:

- `.proto` schema parsing, code generation, message classes, field
  presence/defaults, "last one wins" merging — the API works at the level
  of keys and scalar values
- Text format, JSON mapping, `Any`, well-known types
- Preserving unknown fields (they are skipped, not stored)

## Required API

Complete the declarations in `protobuf_spec.mbt`.

Implementation notes:

- You can **freely decide** the project structure (modules/files), the
  decoding strategy, and any internal data structures — including the
  representations of `BytesReader` and `LimitedReader`, which are
  declared as opaque types.
- Do **not** modify the following files:
  - `protobuf_spec.mbt` - API specification (traits, types, `declare`d
    entry points)
  - `protobuf_qc_test.mbt` - Property-test generators
  - `specs/` folder - Reference documents
  - `*_pub_test.mbt` - Public test file (`protobuf_pub_test.mbt`)
  - `*_priv_test.mbt` - Private test file (`protobuf_priv_test.mbt`)
- Implement the required declarations by adding new `.mbt` files as needed.
- **You may add additional test files** (e.g., `xxx_test.mbt`) if needed
  for testing and maintenance purposes:
  - Create test files to validate edge cases
  - Derive test scenarios from `specs/encoding.md`
  - All added tests must remain faithful to the wire format

Required entry points (see `protobuf_spec.mbt` for exact signatures and
semantics):

- `@protobuf.BytesReader::from_bytes(bytes : Bytes) -> BytesReader`, with
  `impl Reader for BytesReader` and `impl[T : Reader] Reader for
  LimitedReader[T]`
- readers, all `fn[T : Reader] (reader : T) -> ... raise`: `read_tag`,
  `read_varint32`, `read_int32`, `read_int64`, `read_uint32`,
  `read_uint64`, `read_sint32`, `read_sint64`, `read_fixed32`,
  `read_fixed64`, `read_sfixed32`, `read_sfixed64`, `read_float`,
  `read_double`, `read_bool`, `read_enum`, `read_bytes`, `read_string`,
  plus `read_packed(reader, read_fn)` and `read_unknown(reader, tag)`
- writers, all `fn[T : Writer] (writer : T, v) -> Unit raise`:
  `write_varint`, `write_tag`, `write_int32`, `write_int64`,
  `write_uint32`, `write_uint64`, `write_sint32`, `write_sint64`,
  `write_fixed32`, `write_fixed64`, `write_sfixed32`, `write_sfixed64`,
  `write_float`, `write_double`, `write_bool`, `write_enum`,
  `write_bytes`, `write_string`

The `Reader` and `Writer` traits, the `impl Writer for @buffer.Buffer`,
and the `SInt`, `SInt64` and `Enum` value types are shipped in
`protobuf_spec.mbt`. The tests drive the API through `&Reader` trait
objects (`BytesReader::from_bytes(..) as &Reader`, and their own
one-byte-per-call reader) and write into `@buffer.Buffer`.

## Behavioral rules

- Follow `specs/encoding.md` exactly; where it leaves a decoding question
  open, `specs/protobuf.md` and the `protobuf_spec.mbt` docstrings pin the
  reading of the Google reference implementations.
- `Reader::read` may return fewer bytes than requested (never zero while
  data remains) and `None` at end of stream. Decoders must loop until a
  value is complete and raise when the stream ends inside a value —
  including inside a key, a packed payload, or a group being skipped.
- Keys: `(field_number << 3) | wire_type`. `read_tag` returns wire types
  0–5 (groups included), raises on 6 and 7 and on field number 0.
- Varints: accept any encoding of at most ten bytes (`80 00` is 0), drop
  bits beyond the 64th, raise on an eleventh continuation byte. Writers
  emit minimal encodings. The 32-bit readers take the low 32 bits of the
  varint on the wire.
- `int32`/`enum` negative values are written sign-extended (ten bytes);
  `bool` is written `00`/`01` and any nonzero varint reads as `true`;
  `sint32`/`sint64` use zigzag.
- Fixed-width values are little-endian; `float`/`double` bit patterns
  (NaN payloads, infinities, `-0.0`) are preserved exactly.
- Length prefixes must fit in an int32 (`0 ..= 2^31 - 1`); larger ones
  are malformed even when their low 32 bits look small.
- `string` payloads must be valid UTF-8 (overlong forms, surrogates, code
  points above U+10FFFF, truncated sequences and stray continuation bytes
  are errors); every well-formed scalar value is kept as is, a leading
  U+FEFF included.
- Packed fields: elements are decoded from a `LimitedReader` confined to
  the payload until it is exhausted; a payload ending inside an element
  is an error; an empty payload is an empty array.
- `read_unknown` skips a varint / 8 bytes / a prefixed payload / 4 bytes
  for wire types 0/1/2/5, skips a whole group (nested groups included)
  for wire type 3 and raises when its end tag carries a different field
  number, and raises for wire types 4 (no group open), 6 and 7.
- `decode(encode(m)) == m` must hold for every message the generators in
  `protobuf_qc_test.mbt` produce — through `BytesReader` and through a
  one-byte-per-call reader — and reading arbitrary bytes must never
  panic; property-based tests check both.

## Test execution

```bash
moon test
```

## Constraints

### 1. Test Requirements

**All tests must pass for task completion**:

The model should keep running until all tests pass.

- **Public tests** (`*_pub_test.mbt`): 20 cases (including four
  property-based tests), visible in this repository for development and
  debugging
- **Private tests** (`*_priv_test.mbt`): 145 additional cases
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
- **Comprehensiveness**: Validate every scalar type at its boundaries
  (varint length breakpoints, extremes, special float bit patterns),
  canonical encodings in both directions, malformed input of every kind,
  and whole messages with nested submessages, packed and repeated fields
- **Real-world scenarios**: Test byte sequences as real protobuf runtimes
  emit and reject them — every fixture has been cross-checked against the
  official `google.protobuf` implementation
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
responses to the fixtures you can see — build a real codec that works for
arbitrary wire-format input.

### 2. Code Quality Requirements

**Correctness**:
- Zero compiler errors, warnings, or diagnostics
- No runtime panics or unhandled edge cases (malformed input must raise,
  never crash)
- Proper error handling with meaningful error messages

**Formatting**:
- Run `moon fmt` to format all code
- Run `moon info` to generate interface files (`.mbti`)
- Follow MoonBit style conventions consistently

**Implementation Integrity**:
- Solutions must be real encoders/decoders, not test-specific lookup tables
- No hardcoded mappings derived from test fixtures
- Implementation should work for arbitrary wire-format input

### 3. Software Engineering Standards

**Modularity and Organization**:
- The required declarations in `protobuf_spec.mbt` belong to the root
  `protobuf` package. Tests call the root-package API (`@protobuf.read_tag`
  and friends), so those declarations must be implemented in (or
  forwarded to) the root package.
- You may organize implementation across root-level files by functional
  area (for example, byte plumbing, varints, fixed-width scalars,
  length-delimited records, keys and unknown fields, writers).
- If you create subdirectories as separate MoonBit packages, wire them
  through package configuration and keep root-package implementations,
  `pub using` re-exports, or forwarding functions so the required root
  `protobuf` API remains available.
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
- Logical separation of concerns (byte plumbing → wire coding → typed
  helpers)
- Minimize coupling between modules
- Use appropriate abstractions (types, enums, structs)
- Avoid global mutable state

**Example directory structure**:
```
protobuf/
├── moon.mod
├── moon.pkg
├── protobuf_spec.mbt      # API specification (do not modify)
├── protobuf_qc_test.mbt   # Property-test generators (do not modify)
├── readers.mbt            # BytesReader, LimitedReader, read-exactly helpers
├── varint.mbt             # Varint and zigzag coding
├── decode.mbt             # Typed readers, keys, packed and unknown fields
├── encode.mbt             # Typed writers
└── utf8.mbt               # UTF-8 validation for strings
```

These standards ensure your code is maintainable, understandable, and
follows professional software engineering practices.

## Documentation

**Write a comprehensive README.md**:

Your implementation must include a `README.md` file that documents:

- **Project overview**: What this codec implements and its purpose
- **Architecture**: High-level design decisions and module organization
- **Implementation approach**: Key algorithms, data structures, and
  streaming strategy
- **Usage examples**: How to use the API (reading a message from a
  `Reader`, writing one to a `Writer`)
- **Testing**: How to run tests and interpret results
- **Design decisions**: Rationale for important technical choices

The README should be written **based on your actual implementation** -
describe the code you built, not generic information from specifications.
It should help future developers understand your codebase quickly.

## External references

This environment has public network access. You may consult the Protocol
Buffers encoding guide online (https://protobuf.dev/programming-guides/encoding/),
but treat the vendored spec files in `specs/` as the authoritative
baseline for behavior in this task.
