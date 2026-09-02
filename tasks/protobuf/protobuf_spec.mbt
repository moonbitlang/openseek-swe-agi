///|
/// A byte source for the streaming decoder.
///
/// `read` copies at most `max_length` bytes into `buffer` starting at
/// `offset` (`offset` defaults to 0, `max_length` to the room left in
/// `buffer`) and returns how many bytes it copied, or `None` once the
/// stream is exhausted. A source may hand out fewer bytes than requested
/// — a chunked or slow stream — but never zero while data remains: with
/// `max_length >= 1` the result is `Some(n)` with `n >= 1`, or `None`.
/// Decoders built on this trait must keep reading until they hold every
/// byte a value needs — a varint, a fixed-width value or a
/// length-delimited payload may arrive split across many `read` calls —
/// and must raise when the stream ends in the middle of a value.
pub(open) trait Reader {
  fn read(Self, FixedArray[Byte], offset? : Int, max_length? : Int) -> Int? raise
}

///|
/// A byte sink for the encoder: `write` appends the whole view.
pub(open) trait Writer {
  fn write(Self, BytesView) -> Unit raise
}

///|
/// In-memory sink: the tests write wire data into a `@buffer.Buffer`.
pub impl Writer for @buffer.Buffer with fn write(self, bytes : BytesView) {
  self.write_bytes(bytes)
}

///|
/// A `sint32` value: a 32-bit signed integer that travels zigzag-encoded
/// (`zigzag32(n) = (n << 1) ^ (n >> 31)`, so 0, -1, 1, -2, ... map to
/// 0, 1, 2, 3, ...).
pub(all) struct SInt(Int) derive(Eq, Debug)

///|
/// A `sint64` value: a 64-bit signed integer that travels zigzag-encoded
/// (`zigzag64(n) = (n << 1) ^ (n >> 63)`).
pub(all) struct SInt64(Int64) derive(Eq, Debug)

///|
/// An enum value: the 32-bit two's-complement bit pattern of the enum
/// case's number (`Enum(0xFFFFFFFF)` is enum number -1). On the wire an
/// enum is encoded exactly like an `int32`.
pub(all) struct Enum(UInt) derive(Eq, Debug)

///|
/// A reader confined to a window of an underlying reader: `read` hands
/// out at most the bytes left in the window and returns `None` once the
/// window is exhausted, even when the underlying stream has more.
/// `read_packed` uses one to confine the element decoder to a packed
/// payload; the type is constructed only inside the package.
declare pub type LimitedReader[T]

///|
declare pub impl[T : Reader] Reader for LimitedReader[T]

///|
/// A `Reader` over an in-memory `Bytes` value: reads hand out its bytes
/// from the start and return `None` after the last one.
declare pub type BytesReader

///|
declare pub fn BytesReader::from_bytes(bytes : Bytes) -> BytesReader

///|
declare pub impl Reader for BytesReader

///|
/// Read a field key and split it into `(field_number, wire_type)`.
///
/// The key is a varint whose low 32 bits hold
/// `(field_number << 3) | wire_type`. Every wire type the wire format
/// defines comes back: 0 (VARINT), 1 (I64), 2 (LEN), 3 (SGROUP),
/// 4 (EGROUP) and 5 (I32). Raises when the varint is truncated or
/// overlong, when the wire type is 6 or 7 (undefined), or when the field
/// number is 0 (field numbers start at 1). A key of more than five bytes
/// is a non-minimal encoding or carries bits above the 32nd; it lies
/// outside the format's "uint32 varint", and whether it is accepted is
/// unspecified.
declare pub fn[T : Reader] read_tag(reader : T) -> (UInt, UInt) raise

///|
/// Read a varint and return its low 32 bits.
///
/// Varints are base-128, least-significant group first: each byte
/// carries 7 payload bits and its high bit says whether another byte
/// follows. A varint spans at most ten bytes. Readers accept every
/// encoding of at most ten bytes, including non-minimal ones (`80 00` is
/// 0), and keep the value modulo 2^64 when the tenth byte carries bits
/// beyond the 64th; an eleventh continuation byte is an overflow error,
/// and end of stream before the final byte is a truncation error. Every
/// varint reader below shares these rules.
declare pub fn[T : Reader] read_varint32(reader : T) -> UInt raise

///|
/// Read an `int32`: a varint whose low 32 bits are the two's-complement
/// value. Negative numbers travel sign-extended to 64 bits (ten bytes),
/// but any varint decodes by its low 32 bits, so `FF FF FF FF 0F` is -1
/// as well.
declare pub fn[T : Reader] read_int32(reader : T) -> Int raise

///|
/// Read an `int64`: a varint reinterpreted as a two's-complement 64-bit
/// value.
declare pub fn[T : Reader] read_int64(reader : T) -> Int64 raise

///|
/// Read a `uint32`: a varint truncated to its low 32 bits.
declare pub fn[T : Reader] read_uint32(reader : T) -> UInt raise

///|
/// Read a `uint64`: a full 64-bit varint.
declare pub fn[T : Reader] read_uint64(reader : T) -> UInt64 raise

///|
/// Read a `sint32`: the low 32 bits of a varint, zigzag-decoded
/// (`(n >>> 1) ^ -(n & 1)`).
declare pub fn[T : Reader] read_sint32(reader : T) -> SInt raise

///|
/// Read a `sint64`: a 64-bit varint, zigzag-decoded.
declare pub fn[T : Reader] read_sint64(reader : T) -> SInt64 raise

///|
/// Read a `fixed32`: exactly 4 bytes, little-endian, unsigned.
declare pub fn[T : Reader] read_fixed32(reader : T) -> UInt raise

///|
/// Read a `fixed64`: exactly 8 bytes, little-endian, unsigned.
declare pub fn[T : Reader] read_fixed64(reader : T) -> UInt64 raise

///|
/// Read an `sfixed32`: exactly 4 bytes, little-endian, two's-complement.
declare pub fn[T : Reader] read_sfixed32(reader : T) -> Int raise

///|
/// Read an `sfixed64`: exactly 8 bytes, little-endian, two's-complement.
declare pub fn[T : Reader] read_sfixed64(reader : T) -> Int64 raise

///|
/// Read a `float`: 4 bytes, IEEE 754 binary32, little-endian. The bit
/// pattern is preserved exactly (NaN payloads, infinities, -0.0).
declare pub fn[T : Reader] read_float(reader : T) -> Float raise

///|
/// Read a `double`: 8 bytes, IEEE 754 binary64, little-endian. The bit
/// pattern is preserved exactly.
declare pub fn[T : Reader] read_double(reader : T) -> Double raise

///|
/// Read a `bool`: a varint, `false` iff its value is zero (`02` is true).
declare pub fn[T : Reader] read_bool(reader : T) -> Bool raise

///|
/// Read an enum value: a varint truncated to its low 32 bits, exactly
/// like `int32`, returned as its bit pattern. Both the ten-byte
/// sign-extended form and `FF FF FF FF 0F` decode to `Enum(0xFFFFFFFF)`.
declare pub fn[T : Reader] read_enum(reader : T) -> Enum raise

///|
/// Read a `bytes` field: a length prefix followed by exactly that many
/// payload bytes. The prefix is a varint that must fit in an `int32`
/// (0 ..= 2^31 - 1): a larger length is an error, and so is a stream
/// that ends before the payload is complete. `read_string`, `read_packed`
/// and `read_unknown` (wire type 2) read their length prefixes the same
/// way.
declare pub fn[T : Reader] read_bytes(reader : T) -> Bytes raise

///|
/// Read a `string` field: a length-delimited payload that must be valid
/// UTF-8. Overlong encodings, encoded surrogates (U+D800..U+DFFF), code
/// points above U+10FFFF, truncated sequences and stray continuation
/// bytes are errors. Every scalar value decodes as itself: NUL, C1
/// controls and a leading U+FEFF are ordinary characters and are kept.
declare pub fn[T : Reader] read_string(reader : T) -> String raise

///|
/// Read a packed repeated field.
///
/// A packed field is a length-delimited payload holding the elements'
/// encodings back to back with no keys between them. `read_packed` reads
/// the length prefix, then applies `read_fn` repeatedly to a
/// `LimitedReader` confined to exactly the payload until the payload is
/// exhausted, and returns the elements in order. Each element is
/// delimited by its own encoding, so a non-minimal varint element is
/// fine; a payload that ends in the middle of an element — a varint with
/// no final byte, or a fixed-width element short of its 4 or 8 bytes —
/// is an error. An empty payload yields an empty array.
declare pub fn[M, R : Reader] read_packed(
  reader : R,
  read_fn : (LimitedReader[R]) -> M raise,
) -> Array[M] raise

///|
/// Skip the value of a field whose key `tag` — `(field_number,
/// wire_type)` — has just been read: how a decoder passes over a field
/// it does not know. Wire type 0 skips a varint, 1 eight bytes, 5 four
/// bytes, and 2 a length prefix plus payload. Wire type 3 opens a group:
/// skip records, nested groups recursively, up to and including the end
/// tag whose field number matches `field_number`; an end tag with a
/// different field number is malformed. Wire type 4 is an end tag with
/// no group to close, and 6 and 7 are undefined: all three raise, as does
/// a stream that ends inside the skipped value.
declare pub fn[T : Reader] read_unknown(
  reader : T,
  tag : (UInt, UInt),
) -> Unit raise

///|
/// Write a varint: the minimal base-128 encoding, least-significant
/// 7-bit group first, high bit set on every byte but the last
/// (`0 -> 00`, `300 -> AC 02`, `2^64 - 1` -> ten bytes).
declare pub fn[T : Writer] write_varint(
  writer : T,
  input : UInt64,
) -> Unit raise

///|
/// Write a field key: the varint of `(field_number << 3) | wire_type`.
declare pub fn[T : Writer] write_tag(
  writer : T,
  tag : (UInt, UInt),
) -> Unit raise

///|
/// Write an `int32`: sign-extended to 64 bits, then written as a varint,
/// so negative values always take ten bytes.
declare pub fn[T : Writer] write_int32(writer : T, v : Int) -> Unit raise

///|
/// Write an `int64` as a varint of its two's-complement bits.
declare pub fn[T : Writer] write_int64(writer : T, v : Int64) -> Unit raise

///|
/// Write a `uint32` as a varint (zero-extended).
declare pub fn[T : Writer] write_uint32(writer : T, v : UInt) -> Unit raise

///|
/// Write a `uint64` as a varint.
declare pub fn[T : Writer] write_uint64(writer : T, v : UInt64) -> Unit raise

///|
/// Write a `sint32`: zigzag32 then varint, so small magnitudes stay
/// short (`-1 -> 01`, `1 -> 02`, `-2147483648 -> FF FF FF FF 0F`).
declare pub fn[T : Writer] write_sint32(writer : T, v : Int) -> Unit raise

///|
/// Write a `sint64`: zigzag64 then varint.
declare pub fn[T : Writer] write_sint64(writer : T, v : Int64) -> Unit raise

///|
/// Write a `fixed32`: 4 bytes, little-endian.
declare pub fn[T : Writer] write_fixed32(writer : T, v : UInt) -> Unit raise

///|
/// Write a `fixed64`: 8 bytes, little-endian.
declare pub fn[T : Writer] write_fixed64(writer : T, v : UInt64) -> Unit raise

///|
/// Write an `sfixed32`: its two's-complement bits, 4 bytes
/// little-endian.
declare pub fn[T : Writer] write_sfixed32(writer : T, v : Int) -> Unit raise

///|
/// Write an `sfixed64`: its two's-complement bits, 8 bytes
/// little-endian.
declare pub fn[T : Writer] write_sfixed64(writer : T, v : Int64) -> Unit raise

///|
/// Write a `float`: its IEEE 754 binary32 bits, 4 bytes little-endian,
/// preserved exactly.
declare pub fn[T : Writer] write_float(writer : T, v : Float) -> Unit raise

///|
/// Write a `double`: its IEEE 754 binary64 bits, 8 bytes little-endian,
/// preserved exactly.
declare pub fn[T : Writer] write_double(writer : T, v : Double) -> Unit raise

///|
/// Write a `bool` as a one-byte varint: `00` or `01`.
declare pub fn[T : Writer] write_bool(writer : T, v : Bool) -> Unit raise

///|
/// Write an enum value exactly as `write_int32` writes its number: the
/// bit pattern is sign-extended from 32 to 64 bits and written as a
/// varint, so `Enum(0xFFFFFFFF)` (enum number -1) takes ten bytes.
declare pub fn[T : Writer] write_enum(writer : T, v : Enum) -> Unit raise

///|
/// Write a `bytes` field: a varint length prefix followed by the
/// payload.
declare pub fn[T : Writer] write_bytes(writer : T, v : Bytes) -> Unit raise

///|
/// Write a `string` field: its UTF-8 encoding, length-prefixed like
/// `bytes`. The string must not contain unpaired surrogates.
declare pub fn[T : Writer] write_string(writer : T, v : String) -> Unit raise
