# Protocol Buffers wire format — codec-oriented specification for this repo

This document is a **practical, test-oriented spec** for the `protobuf`
package. It summarizes the Protocol Buffers binary wire format and the
conventions of this repository's streaming Reader/Writer API and test
suite.

It is **not** a verbatim copy of the specification; the authoritative
text is vendored at `specs/encoding.md`.

## Objectives (what the implementation must do)

The `protobuf` package expects an implementation that can:

1. Read wire-format records from any `Reader` — a byte source that may
   deliver its bytes in arbitrarily small chunks — decoding field keys and
   every scalar type of the wire format, length-delimited payloads, packed
   repeated fields, and skipping fields it does not know (groups
   included).
2. Write the same records to any `Writer`, producing the canonical
   (minimal) encodings the specification describes.
3. Reject malformed input by raising an error (any error type works; the
   tests only assert that a call raises): truncated values, overlong
   varints, undefined wire types, field number 0, invalid UTF-8 in
   strings, oversized length prefixes, unbalanced groups.
4. Round-trip: every value written with a `write_*` function reads back
   with the matching `read_*` function, byte-exactly for floating-point
   bit patterns — through a whole-buffer reader and through a reader that
   yields one byte per call alike (checked by property-based tests over
   generated messages; the generators are shipped in
   `protobuf_qc_test.mbt`).

## Primary references

- Wire format (local copy): `specs/encoding.md`
- Wire format (online): https://protobuf.dev/programming-guides/encoding/
- The Unicode Standard, chapter 3, table 3-7 ("Well-Formed UTF-8 Byte
  Sequences") for the `string` validity rules:
  https://www.unicode.org/versions/latest/core-spec/chapter-3/#G27506

## Dialect

The dialect is the **Protocol Buffers wire format** as `encoding.md`
defines it — a schema-less codec: the API works at the level of keys and
scalar values, so `.proto` schemas, message classes, field presence,
defaults, and "last one wins" merging are the caller's business, not the
codec's. Where `encoding.md` leaves a decoding question open, the port
pins the reading of the Google reference implementations (C++, Java,
upb/Python), and says so below; the whole fixture corpus has been
cross-checked against `google.protobuf` (Python, protobuf 7.36.1).

## API contract (from `protobuf_spec.mbt`)

```
trait Reader { read(Self, FixedArray[Byte], offset?, max_length?) -> Int? raise }
trait Writer { write(Self, BytesView) -> Unit raise }     // impl for @buffer.Buffer shipped

struct SInt(Int)      // sint32 (zigzag)
struct SInt64(Int64)  // sint64 (zigzag)
struct Enum(UInt)     // enum number as its 32-bit two's-complement pattern

type BytesReader        BytesReader::from_bytes(Bytes); impl Reader
type LimitedReader[T]   impl Reader (constructed inside the package only)

read_tag(reader) -> (field_number, wire_type)
read_varint32 / read_int32 / read_int64 / read_uint32 / read_uint64
read_sint32 -> SInt / read_sint64 -> SInt64
read_fixed32 / read_fixed64 / read_sfixed32 / read_sfixed64
read_float / read_double / read_bool / read_enum -> Enum
read_bytes / read_string
read_packed(reader, read_fn : (LimitedReader[R]) -> M raise) -> Array[M]
read_unknown(reader, tag : (field_number, wire_type))

write_varint(writer, UInt64) / write_tag(writer, (field_number, wire_type))
write_int32 / write_int64 / write_uint32 / write_uint64
write_sint32 / write_sint64 / write_fixed32 / write_fixed64
write_sfixed32 / write_sfixed64 / write_float / write_double
write_bool / write_enum / write_bytes / write_string
```

All `read_*`/`write_*` functions are generic over the reader/writer type;
the tests pass `BytesReader::from_bytes(..) as &Reader`, a one-byte-per-
call chunked reader, and `@buffer.Buffer` as the writer.

## Streaming (the `Reader` contract)

`read(buffer, offset?, max_length?)` copies at most `max_length` bytes
into `buffer` at `offset` and returns `Some(n)` — the count copied, which
may be smaller than requested but is at least 1 while data remains — or
`None` once the stream is exhausted. Consequences for the decoder:

- Every value may arrive split across calls: a ten-byte varint, an
  eight-byte double, a length prefix and its payload, a packed payload.
  Decoders loop until they hold every byte they need.
- End of stream in the middle of a value is an error; end of stream
  *before* a key (`read_tag` at EOF) is also an error, which is how a
  message loop detects the end of its input.
- `LimitedReader[T]` confines reads to a window of `n` bytes of an
  underlying reader: `read` hands out at most the bytes left in the
  window and returns `None` once it is exhausted, even when the underlying
  stream continues. `read_packed` hands one to the element decoder.

## Wire format summary (`specs/encoding.md`)

### Keys ("Message Structure")

A record is a key followed by a value. The key is a varint holding
`(field_number << 3) | wire_type`, so the low three bits are the wire
type and the rest the field number.

| wire type | name   | value                                   |
|-----------|--------|-----------------------------------------|
| 0         | VARINT | one varint                              |
| 1         | I64    | eight bytes, little-endian              |
| 2         | LEN    | varint length prefix, then that many bytes |
| 3         | SGROUP | nothing — opens a (deprecated) group    |
| 4         | EGROUP | nothing — closes the group              |
| 5         | I32    | four bytes, little-endian               |

- `read_tag` returns every wire type in the table, groups included; wire
  types 6 and 7 are undefined and raise.
- Field number 0 is not a field number (numbering starts at 1) and
  raises.
- A key of more than five bytes (a non-minimal encoding, or bits above
  the 32nd) lies outside the format's "uint32 varint"; the reference
  implementations disagree on it, and whether it is accepted is left
  unspecified.

### Varints ("Base 128 Varints")

Base-128, least-significant group first, high bit = "another byte
follows". Rules pinned by the tests:

- At most ten bytes. Any encoding of at most ten bytes is accepted,
  including non-minimal ones (`80 00` is 0) — in values and in keys.
- The payload bits are "interpret[ed] as an unsigned 64-bit integer": the
  bits a tenth byte carries beyond the 64th are dropped (`80 ×9 7F` is
  2^63), as the C++, Java and upb implementations do.
- An eleventh continuation byte is an overflow error; end of stream
  before the final byte is a truncation error.
- The 32-bit readers (`read_varint32`, `read_uint32`, `read_int32`,
  `read_sint32`, `read_enum`) take the **low 32 bits** of whatever varint
  is on the wire; `read_int64`/`read_uint64` take all 64.

Writers always emit the minimal encoding.

### Integers ("More Integer Types")

- `int32`/`int64`: two's complement. A negative `int32` is written
  sign-extended to 64 bits, so it takes ten bytes; reading takes the low
  32 bits (so the five-byte `FF FF FF FF 0F` is also -1).
- `uint32`/`uint64`: plain varints, zero-extended.
- `sint32`/`sint64`: zigzag — `(n << 1) ^ (n >> 31)` / `(n << 1) ^
  (n >> 63)` — then varint; decoding reverses it (`(v >>> 1) ^ -(v & 1)`
  on the 32- or 64-bit value).
- `bool`: written as `00`/`01`; any nonzero varint reads as `true`.
- `enum`: "encoded as if they were int32s". `Enum(UInt)` carries the
  enum number's 32-bit two's-complement pattern; `write_enum` writes it
  exactly like `write_int32` (so `Enum(0xFFFFFFFF)`, enum number -1,
  takes ten bytes) and `read_enum` returns the low 32 bits.

### Fixed width ("Non-varint Numbers")

- I32: `fixed32` (unsigned), `sfixed32` (two's complement), `float`
  (IEEE 754 binary32), four bytes little-endian.
- I64: `fixed64`, `sfixed64`, `double` (binary64), eight bytes
  little-endian.
- Floating-point bit patterns are preserved exactly in both directions:
  NaN payloads, infinities and `-0.0` round-trip bit-for-bit.

### Length-delimited ("Length-Delimited Records")

`LEN` values are a varint length prefix followed by exactly that many
bytes: `bytes`, `string`, embedded messages and packed fields.

- The prefix is a "size encoded as int32 varint" (reference card): it
  must be in `0 ..= 2^31 - 1`. A larger prefix — even one whose low 32
  bits look small, such as 2^32 — is malformed. This applies wherever a
  length prefix is read: `read_bytes`, `read_string`, `read_packed`, and
  `read_unknown` on wire type 2.
- A stream that ends before the payload is complete is an error.
- `string` payloads must be valid UTF-8 (Unicode table 3-7): overlong
  forms, encoded surrogates U+D800..U+DFFF, code points above U+10FFFF,
  truncated sequences and stray continuation bytes are errors. Every
  well-formed scalar value decodes as itself — NUL, C1 controls and a
  leading U+FEFF are ordinary characters and are kept, never stripped.
- `write_string` writes the UTF-8 encoding of the string (which must not
  contain unpaired surrogates); `write_bytes` writes the payload as is.
- Embedded messages are just `bytes` to this API: the tests read a
  submessage with `read_bytes` and decode it with a fresh `BytesReader`,
  and write one by encoding it into a temporary buffer and calling
  `write_bytes`.

### Packed repeated fields ("Repeated Elements")

A packed field is one `LEN` record whose payload is the elements'
encodings back to back, with no keys between them; elements "are decoded
from the LEN record one by one until the payload is exhausted", each
delimited by its own encoding.

- `read_packed(reader, read_fn)` reads the length prefix, then calls
  `read_fn` on a `LimitedReader` confined to exactly the payload until
  the window is exhausted, and returns the elements in order. Nothing
  else delimits elements: a non-minimal varint element is fine, and an
  empty payload yields `[]`.
- "Each pair must contain a whole number of elements": a payload that
  ends inside a varint, or short of a fixed-width element's 4 or 8 bytes,
  is an error — even when more bytes follow the payload.
- Writers produce a packed field by encoding the elements into a
  temporary buffer and writing it with `write_bytes`.

### Unknown fields and groups ("Groups")

`read_unknown(reader, tag)` skips the value of the record whose key has
just been read, so a decoder can pass over fields it does not know:

- wire type 0: a varint; 1: eight bytes; 5: four bytes; 2: a length
  prefix (int32-bounded, as above) and its payload;
- wire type 3 (SGROUP): the group's records up to and including the
  matching end tag — nested groups are skipped recursively, and "Group
  field numbers need to match up. If we encounter 7:EGROUP where we
  expect 8:EGROUP, the message is mal-formed", so an end tag with a
  different field number raises;
- wire type 4 (EGROUP) with no group open, and the undefined types 6 and
  7, raise;
- a value the stream cannot supply (including a group whose end tag never
  arrives) raises.

## Error handling

Any malformed input must raise from the `read_*` function that
encounters it. The tests never inspect the error's type or message, so
any raise-based error design works — but they cover truncation at every
position, overlong varints, bad keys, oversized lengths, invalid UTF-8,
mid-element packed payloads and unbalanced groups, so precise detection
matters much more than the shape of the error value.

## Test-suite conventions

- Wire fixtures are standard base64 (RFC 4648, with padding) decoded with
  `base64_decode` from the public test file, or inline `b"..."` literals.
- Most fixtures are one record: the tests call `read_tag`, assert the
  key, then the typed reader. Table tests (`simple/*`) check both
  directions: `decode(fixture) == value` and `encode(value) == fixture`,
  so writers must produce the canonical bytes.
- `difficult/*` and `middle/*` decode and re-encode whole messages with
  nested submessages, packed fields, repeated fields and `oneof`-style
  optional fields through the public API only.
- `OneByteReader` in the public test file is a `Reader` that returns a
  single byte per call; the `chunked-reader/*` tests and one of the
  property tests decode through it.
- The property tests build random messages (every scalar kind, packed
  fields, unknown fields and groups the decoder must skip, strings with
  control characters and non-BMP code points, special float bit patterns)
  and require `decode(encode(m)) == m` through both readers, plus a
  never-panics property over arbitrary bytes.
