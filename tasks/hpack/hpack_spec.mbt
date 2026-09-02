///|
/// A header field: a name/value pair of opaque octet sequences (RFC 7541
/// section 1.3). HPACK places no restriction on the octets: names and
/// values may be empty and may contain any byte.
pub(all) struct HeaderField {
  name : Bytes
  value : Bytes
} derive(Eq, Debug)

///|
/// The size of this field as a dynamic table entry, as defined by RFC 7541
/// section 4.1: the name length plus the value length plus 32 octets.
///
/// Examples:
///
///     { name: b"content-type", value: b"text/html" }    size() == 53
///     { name: b"", value: b"" }                         size() == 32
declare pub fn HeaderField::size(self : HeaderField) -> Int

///|
/// Decoding errors. Each variant is one of RFC 7541's "MUST be treated as
/// a decoding error" conditions:
///
/// - `InvalidIndex`: an indexed representation, or the indexed name of a
///   literal representation, referenced index 0 (section 6.1) or an index
///   past the end of the combined static + dynamic address space (section
///   2.3.3). The payload is the offending index as decoded from the wire.
/// - `IntegerOverflow`: a prefixed integer (section 5.1) exceeds this
///   package's limit. The limit is the value 2^31 - 1 (the largest `Int`):
///   every integer up to it must be decoded, every integer above it must
///   raise. Section 5.1 also permits a limit on the octet length of an
///   encoding, so a decoder may additionally raise this error for an
///   encoding with more than five continuation octets (more than any value
///   within the limit needs), whatever value those octets spell.
/// - `UnexpectedEof`: the header block ends inside a prefixed integer, or
///   before the declared length of a string literal's data is available,
///   or where a string literal was required (for example the value of a
///   literal representation).
/// - `InvalidHuffman`: a Huffman-encoded string literal violates section
///   5.2: it contains the EOS symbol, its padding is longer than 7 bits, or
///   its padding is not the most-significant bits of the EOS code (that
///   is, not all ones).
/// - `TableSizeExceeded`: a dynamic table size update (section 6.3)
///   requested a maximum size above the decoder's protocol limit; `size~`
///   is the requested size and `max~` the limit.
/// - `InvalidTableSizeUpdate`: a dynamic table size update appeared after a
///   header field of the same block (section 4.2: size updates must occur
///   at the beginning of a header block).
///
/// There are no other decoding errors. The Huffman code of Appendix B is
/// complete (every bit sequence is a prefix of some code), so "no matching
/// code" cannot occur, and every octet value begins one of the five
/// representations of section 6, so there is no invalid representation.
pub(all) suberror HpackError {
  InvalidIndex(Int)
  IntegerOverflow
  UnexpectedEof
  InvalidHuffman
  TableSizeExceeded(size~ : Int, max~ : Int)
  InvalidTableSizeUpdate
} derive(Eq, Debug)

///|
/// An HPACK decoding context: the dynamic table for one direction of one
/// connection. The table persists across `decode` calls, so all header
/// blocks received on a connection must be decoded, in order, by the same
/// decoder.
declare pub type Decoder

///|
/// Create a decoder.
///
/// `max_table_size` (default 4096) plays the role of the protocol's
/// SETTINGS_HEADER_TABLE_SIZE (RFC 7541 section 4.2): it is the initial
/// maximum size of the dynamic table and the limit that a dynamic table
/// size update may not exceed (section 6.3).
declare pub fn Decoder::new(max_table_size? : Int) -> Decoder

///|
/// Decode one header block, returning its header fields in order.
///
/// A header block is a sequence of representations (RFC 7541 section 6),
/// each identified by the high bits of its first octet:
///
///     1xxxxxxx   Indexed Header Field                    (section 6.1)
///     01xxxxxx   Literal with Incremental Indexing       (section 6.2.1)
///     0000xxxx   Literal without Indexing                (section 6.2.2)
///     0001xxxx   Literal Never Indexed                   (section 6.2.3)
///     001xxxxx   Dynamic Table Size Update               (section 6.3)
///
/// Indices resolve through the combined address space of section 2.3.3:
/// 1..61 are the static table (Appendix A) and 62 onward the dynamic
/// table, most recently inserted entry first. A literal representation
/// takes its name either from the entry at a non-zero index (the name is
/// copied, so it survives that entry's eviction — section 4.4) or from a
/// string literal (index 0); its value is always a string literal. String
/// literals (section 5.2) are raw octets or Huffman-coded, per their H
/// bit. Literals with incremental indexing insert the field into the
/// dynamic table (section 4.4): the oldest entries are evicted until the
/// entry fits, and an entry larger than the table's maximum size empties
/// the table and is not inserted. The two other literal forms decode
/// identically but never touch the table. A dynamic table size update
/// sets the table's maximum size, evicting the oldest entries until the
/// table fits (section 4.3); it is only legal before the first header
/// field of a block (any number of updates may appear there) and must not
/// exceed the decoder's protocol limit.
///
/// Raises `HpackError` on malformed input; see the error type for the
/// exact conditions. A block that raises leaves the decoder in an
/// unspecified state, as in HTTP/2, where a decoding error ends the
/// connection.
///
/// Examples:
///
///     wire bytes                          headers
///
///     82                                  ":method: GET"
///                                         (static index 2)
///
///     41 0f "www.example.com"             ":authority: www.example.com"
///                                         (name from index 1, literal
///                                          value; inserted as index 62)
///
///     20 82                               ":method: GET", after setting
///                                         the dynamic table's maximum
///                                         size to 0
declare pub fn Decoder::decode(
  self : Decoder,
  data : BytesView,
) -> Array[HeaderField] raise HpackError

///|
/// An HPACK encoding context: the dynamic table for one direction of one
/// connection. The encoder mirrors the insertions and evictions its output
/// will cause in the receiving decoder, so all header blocks sent on a
/// connection must be encoded, in order, by the same encoder.
declare pub type Encoder

///|
/// Create an encoder.
///
/// `max_table_size` (default 4096) is the maximum size of the encoder's
/// dynamic table (RFC 7541 section 4.2). `use_huffman` (default true)
/// selects how string literals are written: `false` writes every string
/// literal as raw octets (H bit 0); `true` writes every string literal —
/// names and values alike — Huffman-coded (H bit 1), even when the code is
/// longer than the raw octets. Both forms are byte-for-byte deterministic:
/// RFC 7541's Appendix C.3/C.5 and C.4/C.6 examples are exactly this
/// encoder's output with `use_huffman` false and true respectively.
declare pub fn Encoder::new(
  max_table_size? : Int,
  use_huffman? : Bool,
) -> Encoder

///|
/// Encode a header block.
///
/// If `set_max_size` was called since the previous block, the output
/// starts with the dynamic table size update(s) that RFC 7541 section 4.2
/// requires: the smallest size requested since the previous block, then
/// the final size — one update if they are equal, two otherwise. Then,
/// for each field in order, the greedy strategy that the Appendix C worked
/// examples follow:
///
/// 1. if some entry of the combined address space matches name and value
///    exactly, emit an Indexed Header Field (section 6.1) with the
///    smallest such index (the static table precedes the dynamic table);
/// 2. otherwise, if some entry has the same name, emit a Literal Header
///    Field with Incremental Indexing (section 6.2.1) with the smallest
///    such name index and a literal value, and insert the field into the
///    dynamic table, evicting the oldest entries until it fits (section
///    4.4; a field larger than the table's maximum size empties the table
///    and is not inserted);
/// 3. otherwise, emit a Literal Header Field with Incremental Indexing
///    with a literal name and a literal value, and insert the field as in
///    rule 2.
///
/// Examples (`use_huffman=false`):
///
///     headers                              wire bytes
///
///     ":method: GET"                       82
///     ":authority: www.example.com"        41 0f "www.example.com"
///     "custom-key: custom-value"           40 0a "custom-key"
///                                             0c "custom-value"
///     the same field again                 be        (dynamic index 62)
///     ":method: GET", after                20 82
///     set_max_size(0)
declare pub fn Encoder::encode(
  self : Encoder,
  headers : Array[HeaderField],
) -> Bytes

///|
/// Encode one header field as a Literal Header Field without Indexing
/// (RFC 7541 section 6.2.2): the `0000` prefix, then the name as the
/// smallest index of an entry with that name in the combined address
/// space when one exists (a 4-bit prefix integer) and as a string literal
/// otherwise (index 0), then the value as a string literal. The dynamic
/// table is not changed, and no dynamic table size update is emitted —
/// this is a single field representation, not a header block, so a
/// pending update stays pending for the next `encode`.
declare pub fn Encoder::encode_without_indexing(
  self : Encoder,
  header : HeaderField,
) -> Bytes

///|
/// Encode one header field as a Literal Header Field Never Indexed (RFC
/// 7541 section 6.2.3), the form for values that intermediaries must not
/// insert into any table. Identical to `encode_without_indexing` except
/// for the `0001` prefix.
declare pub fn Encoder::encode_never_indexed(
  self : Encoder,
  header : HeaderField,
) -> Bytes

///|
/// Change the maximum size of the encoder's dynamic table, evicting the
/// oldest entries until the table fits (RFC 7541 section 4.3). The change
/// is signalled to the peer at the start of the next `encode` output (see
/// `encode`). `new_size` must not exceed the peer's protocol limit, which
/// the encoder does not know and does not check.
declare pub fn Encoder::set_max_size(self : Encoder, new_size : Int) -> Unit
