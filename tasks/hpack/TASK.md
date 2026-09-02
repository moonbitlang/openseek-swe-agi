## Goal

Implement a MoonBit **HPACK codec** — the header compression format of
HTTP/2, RFC 7541 — compatible with this repository's test suite. The
authoritative references are vendored in:

- `specs/rfc7541.txt` — RFC 7541, HPACK: Header Compression for HTTP/2
- `specs/hpack.md` — this repo's codec-oriented summary and conventions

## What This Task Is Really About

This is an exercise in implementing a **real binary compression format**:
a decoder that must accept every legal header block any HTTP/2 peer can
send, and an encoder whose output is pinned byte for byte. The goal is
code that handles arbitrary header blocks in general — not code that
recognizes the fixtures.

A proper implementation will have:

- **Primitive codecs**: RFC 7541's prefixed integers (section 5.1) and
  string literals (section 5.2), including a complete Huffman coder for
  the 257-symbol code of Appendix B with the RFC's padding and EOS rules
- A **static table** (Appendix A, 61 entries) and a **dynamic table**
  with exact size accounting, insertion, eviction, and size updates
  (sections 2.3, 4)
- A **decoder** for the five representations of section 6 that keeps its
  dynamic table across header blocks and raises the right error for
  every malformed input
- An **encoder** implementing the deterministic greedy strategy specified
  in `hpack_spec.mbt` — the one that reproduces the RFC's Appendix C
  worked examples — with both string literal forms, the two non-indexing
  single-field forms, and dynamic table size signalling

**Important mindset**: If the test suite were regenerated with different
header names, values, table sizes, or wire bytes, your implementation
should still pass. If it wouldn't, you haven't built a codec — you've
built a lookup table.

## Approach

Build incrementally:

1. **Integers**: N-bit prefix encoding and decoding, continuation
   octets, the overflow and truncation errors.
2. **Strings**: raw literals, then the Huffman coder (encode with EOS
   padding; decode with the padding/EOS validation of section 5.2).
3. **Tables**: the static table; the dynamic table with entry sizes,
   newest-first indexing, eviction on insert and on size change, and the
   "entry larger than the table" rule.
4. **Decoder**: the five representations, the combined index address
   space, size-update placement and limit checks.
5. **Encoder**: exact/name/literal matching, mirroring insertions and
   evictions, `use_huffman`, the non-indexing forms, `set_max_size` and
   its size updates.

Run tests frequently while adding features.

Important: The core logic must be implemented in MoonBit.

## Scope

In scope (RFC 7541, exactly):

- `Decoder::decode` over arbitrary header blocks: all five
  representations, static and dynamic indexing, raw and Huffman string
  literals, dynamic table size updates, and every "MUST be treated as a
  decoding error" condition of the RFC
- `Encoder::encode` with the greedy strategy of `hpack_spec.mbt`, in raw
  (`use_huffman=false`) and Huffman (`use_huffman=true`) string literal
  forms
- `Encoder::encode_without_indexing` / `Encoder::encode_never_indexed`
  for single fields
- `Encoder::set_max_size` and the resulting dynamic table size updates
  (section 4.2: smallest requested size first, then the final size)
- Round-trip: `decode(encode(headers)) == headers` for any header lists
  and any octets, checked by property-based tests over generated fields

Out of scope:

- HTTP/2 framing, `SETTINGS` negotiation, and header validation
  (header names and values are opaque octet strings)
- Any encoder heuristic beyond the specified strategy (for example
  choosing Huffman only when shorter, or skipping indexing for large
  values)

## Required API

Complete the declarations in `hpack_spec.mbt`.

Implementation notes:

- You can **freely decide** the project structure (modules/files), the
  algorithms, and any internal data structures (`Decoder` and `Encoder`
  are opaque types whose representation is yours).
- Do **not** modify the following files:
  - `hpack_spec.mbt` - API specification (types, errors, `Decoder`,
    `Encoder`)
  - `hpack_qc.mbt` - Property-test generators
  - `specs/` folder - Reference documents
  - `*_pub_test.mbt` - Public test file (`hpack_pub_test.mbt`)
  - `*_priv_test.mbt` - Private test file (`hpack_priv_test.mbt`)
- Implement the required declarations by adding new `.mbt` files as needed.
- **You may add additional test files** (e.g., `xxx_test.mbt`) if needed
  for testing and maintenance purposes:
  - Create test files to validate edge cases
  - Derive test scenarios from `specs/rfc7541.txt`
  - All added tests must remain faithful to RFC 7541

Required entry points:

- `@hpack.HeaderField::size(self : HeaderField) -> Int`
- `@hpack.Decoder::new(max_table_size? : Int) -> Decoder`
- `@hpack.Decoder::decode(self : Decoder, data : BytesView) -> Array[HeaderField] raise HpackError`
- `@hpack.Encoder::new(max_table_size? : Int, use_huffman? : Bool) -> Encoder`
- `@hpack.Encoder::encode(self : Encoder, headers : Array[HeaderField]) -> Bytes`
- `@hpack.Encoder::encode_without_indexing(self : Encoder, header : HeaderField) -> Bytes`
- `@hpack.Encoder::encode_never_indexed(self : Encoder, header : HeaderField) -> Bytes`
- `@hpack.Encoder::set_max_size(self : Encoder, new_size : Int) -> Unit`

The result types are fixed by the spec: `HeaderField` and `HpackError`
are `pub(all)` types in `hpack_spec.mbt` whose values the tests construct
directly and compare with `assert_eq` / pattern matching. The property-test
generators in `hpack_qc.mbt` build fields from these types and check that
decoding the encoder's output reproduces them.

## Behavioral rules

- Follow RFC 7541 exactly; `specs/hpack.md` summarizes the rules the
  tests lean on.
- Indices are 1-based over the combined address space: 1..61 the static
  table, 62 onward the dynamic table newest first. Index 0 is
  `InvalidIndex(0)`; an index past the end is `InvalidIndex(index)`.
- Entry size is `name.length() + value.length() + 32`. Only literals with
  incremental indexing insert. Insertion evicts the oldest entries until
  the entry fits; an entry larger than the maximum size empties the table
  and is not inserted. A size update evicts down to the new maximum.
- Decoder size updates are legal only before the first field of a block
  (`InvalidTableSizeUpdate` otherwise) and must not exceed the decoder's
  limit (`TableSizeExceeded(size~, max~)`); `Decoder::new(max_table_size)`
  (default 4096) is both the initial maximum and that limit.
- Integers above 2^31 − 1 are `IntegerOverflow`; a block that ends inside
  an integer or a string is `UnexpectedEof`; Huffman data with an EOS
  symbol, more than 7 bits of padding, or padding that is not all ones is
  `InvalidHuffman`.
- The encoder is deterministic: exact match → indexed field with the
  smallest index; name match → literal with incremental indexing using
  the smallest name index (static before dynamic) and inserting; else a
  literal name and value, inserting. `use_huffman=true` Huffman-codes
  every string literal, `false` writes them raw. RFC 7541 Appendix
  C.3–C.6 are this encoder's exact output.
- `set_max_size` takes effect immediately in the encoder's table and is
  signalled at the start of the next `encode` output: the smallest size
  requested since the previous block, then the final size (one update
  when they coincide). The single-field forms never emit size updates and
  never insert.
- `decode(encode(headers)) == headers` must hold for every header list
  and every octet string, across consecutive blocks on the same
  encoder/decoder pair and in both string literal forms; this is checked
  by property-based tests over generated fields (generators are shipped
  in `hpack_qc.mbt`, do not modify), together with "decode never panics"
  over arbitrary octets.

## Test execution

```bash
moon test
```

## Constraints

### 1. Test Requirements

**All tests must pass for task completion**:

The model should keep running until all tests pass.

- **Public tests** (`*_pub_test.mbt`): 18 cases (including three
  property-based tests), visible in this repository for development and
  debugging
- **Private tests** (`*_priv_test.mbt`): 165 additional cases that decide
  the score. They are **withheld while you work** — expect them to be
  absent from this directory, and do not go looking for them. Your
  `moon test` therefore exercises the public tests only; the private
  suite is run against your implementation afterwards.

**CRITICAL - Full Suite Evaluation**:

Passing only the public tests is **INSUFFICIENT**. A green `moon test`
is necessary but not sufficient: it covers roughly 10% of the cases that
decide the outcome. The task is complete only when the private suite
passes too — and you cannot run it yourself.

**Why Private Tests Matter**:
- **Coverage**: Private tests represent ~90% of the total evaluation -
  they are the primary measure of success
- **Comprehensiveness**: They carry the full static table, the RFC
  Appendix C stories in both directions, the cross-implementation
  compatibility vectors, every decoding-error condition, dynamic table
  eviction and size-update behavior, and byte-level encoder expectations
- **Real-world scenarios**: The compatibility vectors are real header
  blocks produced by go-hpack, nghttp2, python-hpack, node, haskell-http2
  and swift-nio encoders
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
arbitrary HPACK header blocks.

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
- Solutions must be real encoders/decoders, not test-specific lookup tables
- No hardcoded mappings derived from test fixtures
- Implementation should work for arbitrary HPACK header blocks

### 3. Software Engineering Standards

**Modularity and Organization**:
- The required declarations in `hpack_spec.mbt` belong to the root `hpack`
  package. Tests call the root-package API `@hpack.Decoder::decode`, so
  those declarations must be implemented in (or forwarded to) the root
  package.
- You may organize implementation across root-level files by functional
  area (for example, integer coding, Huffman coding, tables, decoder,
  encoder).
- If you create subdirectories as separate MoonBit packages, wire them
  through package configuration and keep root-package implementations,
  `pub using` re-exports, or forwarding functions so the required root
  `hpack` API remains available.
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
- Logical separation of concerns (primitive coding → table state →
  encode/decode)
- Minimize coupling between modules
- Use appropriate abstractions (types, enums, structs)
- Avoid global mutable state

**Example directory structure**:
```
hpack/
├── moon.mod
├── moon.pkg
├── hpack_spec.mbt         # API specification (do not modify)
├── hpack_qc.mbt           # Property-test generators (do not modify)
├── integer.mbt            # Prefixed integer coding
├── huffman.mbt            # Huffman tables and codec
├── static_table.mbt       # Appendix A
├── dynamic_table.mbt      # Dynamic table, eviction, size accounting
├── decoder.mbt            # Header block decoding
└── encoder.mbt            # Greedy encoding strategy
```

These standards ensure your code is maintainable, understandable, and
follows professional software engineering practices.

## Documentation

**Write a comprehensive README.md**:

Your implementation must include a `README.md` file that documents:

- **Project overview**: What this codec implements and its purpose
- **Architecture**: High-level design decisions and module organization
- **Implementation approach**: Key algorithms, data structures, and
  coding strategy
- **Usage examples**: How to use the API (decoding a header block,
  encoding a header list)
- **Testing**: How to run tests and interpret results
- **Design decisions**: Rationale for important technical choices

The README should be written **based on your actual implementation** -
describe the code you built, not generic information from specifications.
It should help future developers understand your codebase quickly.

## External references

This environment has public network access. You may consult RFC 7541 and
HPACK resources online (for example the hpack-test-case corpus), but treat
the vendored spec files in `specs/` as the authoritative baseline for
behavior in this task.
