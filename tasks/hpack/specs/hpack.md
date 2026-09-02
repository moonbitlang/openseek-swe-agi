# HPACK (RFC 7541) — codec-oriented specification for this repo

This document is a **practical, test-oriented spec** for the `hpack`
package. It summarizes the required behavior of **RFC 7541, HPACK: Header
Compression for HTTP/2**, and the conventions used by this repository's
MoonBit API and test suite.

It is **not** a verbatim copy of the RFC; the authoritative text is
vendored at `specs/rfc7541.txt`.

## Objectives (what the implementation must do)

The `hpack` package expects an implementation that can:

1. Decode HPACK header blocks into an ordered list of header fields,
   maintaining the dynamic table across blocks exactly as RFC 7541
   sections 2.3, 4 and 6 prescribe.
2. Raise the right `HpackError` for every input the RFC says MUST be
   treated as a decoding error.
3. Encode header lists into header blocks with the deterministic greedy
   strategy documented in `hpack_spec.mbt` — the strategy that reproduces
   the RFC's Appendix C worked examples byte for byte — in both string
   literal forms (raw and Huffman), plus the two non-indexing single-field
   forms and dynamic table size updates.
4. Round-trip: a decoder must reproduce the fields the encoder was given,
   for any sequence of blocks and any octets (checked by property-based
   tests over generated fields; the generators are shipped in
   `hpack_qc.mbt`).

## Primary references

- RFC 7541 (local copy): `specs/rfc7541.txt`
- RFC 7541 (online): https://www.rfc-editor.org/rfc/rfc7541
- Decoder compatibility vectors in the test suite come from the
  cross-implementation corpus at https://github.com/http2jp/hpack-test-case
  (go-hpack, nghttp2, python-hpack, node, haskell-http2, swift-nio) and
  from RFC 7541 Appendix C.

## Dialect

The dialect is **RFC 7541 exactly**, with the two implementation limits
the RFC leaves open fixed as follows (see `hpack_spec.mbt`):

- prefixed integers are limited to the value 2^31 − 1 (the largest
  `Int`); larger values are `IntegerOverflow`. An encoding with more than
  five continuation octets may also be rejected (section 5.1 permits an
  octet-length limit);
- the decoder's protocol limit on the dynamic table size — HTTP/2's
  `SETTINGS_HEADER_TABLE_SIZE` — is the `max_table_size` given to
  `Decoder::new` (default 4096).

There are no other extensions or restrictions: names and values are
opaque octet strings (empty and binary values included), Huffman-decoded
octets are not validated as text, and the decoder accepts every legal
representation form regardless of what the encoder in this package would
have chosen.

## Data model (from `hpack_spec.mbt`)

```
struct HeaderField { name : Bytes; value : Bytes }
HeaderField::size(self) -> Int                       // name + value + 32

suberror HpackError {
  InvalidIndex(Int)                                  // index 0 or past the end
  IntegerOverflow                                    // integer above 2^31 - 1
  UnexpectedEof                                      // block ends too early
  InvalidHuffman                                     // section 5.2 violations
  TableSizeExceeded(size~ : Int, max~ : Int)         // update above the limit
  InvalidTableSizeUpdate                             // update after a field
}

Decoder::new(max_table_size? : Int) -> Decoder
Decoder::decode(self, data : BytesView) -> Array[HeaderField] raise HpackError

Encoder::new(max_table_size? : Int, use_huffman? : Bool) -> Encoder
Encoder::encode(self, headers : Array[HeaderField]) -> Bytes
Encoder::encode_without_indexing(self, header : HeaderField) -> Bytes
Encoder::encode_never_indexed(self, header : HeaderField) -> Bytes
Encoder::set_max_size(self, new_size : Int) -> Unit
```

`HeaderField` is `pub(all)`: tests construct fields directly and compare
decoded arrays with `assert_eq` (structural equality on the octets;
order is significant). `Decoder` and `Encoder` are opaque — their
representation is yours.

## Index address space (section 2.3.3)

Indices are 1-based and cover the static table followed by the dynamic
table:

- 1..61: the static table of Appendix A, in the RFC's order;
- 62..61 + n: the dynamic table's n entries, **most recently inserted
  first** (62 is the newest entry);
- 0 is never a valid index (in a literal representation it means "the
  name follows as a string literal").

`InvalidIndex` carries the index as decoded from the wire.

## Dynamic table (section 4)

- Entry size is `name.length() + value.length() + 32`
  (`HeaderField::size`).
- Only Literal Header Fields with Incremental Indexing insert entries
  (section 6.2.1); the other two literal forms never do.
- Insertion (section 4.4): evict the oldest entries until the new entry
  fits, then insert it at the front. An entry larger than the maximum
  size empties the table and is **not** inserted (not an error). A
  literal may take its name from the very entry the insertion evicts, so
  resolve the name before evicting.
- Size changes (sections 4.2, 4.3, 6.3): a dynamic table size update sets
  the maximum size, evicting the oldest entries until the table fits; size
  0 empties it. On the decoder side an update is legal only before the
  first header field of a block (several updates in a row are fine) and
  must not exceed the decoder's protocol limit — `TableSizeExceeded`
  carries the requested size and the limit; an update after a field is
  `InvalidTableSizeUpdate`.
- `Decoder::new(max_table_size)` sets both the initial maximum size and
  the protocol limit; `Encoder::new(max_table_size)` sets the encoder's
  maximum size, which `set_max_size` may later lower or raise.

## Primitive types (section 5)

- **Integers** (5.1): an N-bit prefix (N = 7 for indexed fields and string
  lengths, 6 for incremental-indexing literals, 5 for size updates, 4 for
  the non-indexing literals). Values below `2^N − 1` fit in the prefix;
  otherwise the prefix is all ones and `value − (2^N − 1)` follows in
  little-endian base-128 continuation octets (high bit set on all but the
  last). Values above 2^31 − 1 are `IntegerOverflow`; running out of
  octets mid-integer is `UnexpectedEof`. The encoder always produces the
  minimal encoding.
- **String literals** (5.2): an H bit and a 7-bit-prefix length, then
  `length` octets — raw when H is 0, Huffman-coded (Appendix B) when H
  is 1. A length past the end of the block is `UnexpectedEof`. Huffman
  data is decoded MSB first; the trailing incomplete code is padding,
  which must be at most 7 bits and must be all ones (a prefix of the EOS
  code); an EOS symbol inside the data is an error. All three violations
  are `InvalidHuffman`. The Huffman code is complete, so there is no
  "unknown code" case; a length-0 Huffman string is the empty string.

## Representations (section 6)

| first octet | representation                        | prefix | effect on the table |
|-------------|---------------------------------------|--------|---------------------|
| `1xxxxxxx`  | Indexed Header Field (6.1)            | 7      | none                |
| `01xxxxxx`  | Literal with Incremental Indexing (6.2.1) | 6  | inserts             |
| `0000xxxx`  | Literal without Indexing (6.2.2)      | 4      | none                |
| `0001xxxx`  | Literal Never Indexed (6.2.3)         | 4      | none                |
| `001xxxxx`  | Dynamic Table Size Update (6.3)       | 5      | sets the maximum    |

Every octet value begins exactly one of these, so there is no "invalid
representation" error. In the three literal forms the prefix integer is
a name index (0 = literal name string follows), then the value string.

## Encoder strategy (Appendix C)

`Encoder::encode` processes one header block:

1. If `set_max_size` was called since the previous block, first emit the
   size update(s) of section 4.2: the smallest size requested in the
   interval, then the final size (one update if they coincide).
2. For each field, in order:
   - exact (name, value) match in the combined address space → Indexed
     Header Field with the smallest such index;
   - else name match → Literal with Incremental Indexing, smallest
     matching name index (the static table comes first), literal value,
     insert;
   - else → Literal with Incremental Indexing, literal name and value,
     insert.

`use_huffman=false` writes every string literal raw; `use_huffman=true`
Huffman-codes every string literal, even when that is longer. With the
default 4096-octet table these two settings reproduce Appendix C.3 and
C.4; with a 256-octet table, C.5 and C.6.

`encode_without_indexing` / `encode_never_indexed` emit one field in the
corresponding form (name by smallest index when present, else literal;
value literal), never insert, and never emit a size update.

## Error handling

`Decoder::decode` raises `HpackError`; tests match on the variant (and,
for `InvalidIndex` and `TableSizeExceeded`, on the payload). The encoder
never raises. After a decoding error the decoder's state is unspecified.
