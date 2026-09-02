///|
/// One field for the property tests, tagged by scalar kind. Each kind has
/// a fixed field number (1..18, in declaration order) and its natural
/// wire type, so a message — an `Array[QcValue]` — can be written with
/// `qc_encode` and read back with `qc_decode` without a schema. The two
/// `QcSkipped*` kinds are fields the decoder does not know: a group
/// (field 19, SGROUP..EGROUP) and a plain value under field 20, both of
/// which `qc_decode` must pass over with `read_unknown`, so they are
/// absent from the decoded message (`qc_visible`).
///
/// Equality compares floats by bit pattern: the wire round-trip is
/// bit-exact, so NaN payloads and -0.0 must survive unchanged.
pub(all) enum QcValue {
  QcInt32(Int)
  QcInt64(Int64)
  QcUInt32(UInt)
  QcUInt64(UInt64)
  QcSInt32(Int)
  QcSInt64(Int64)
  QcBool(Bool)
  QcEnum(UInt)
  QcFixed32(UInt)
  QcFixed64(UInt64)
  QcSFixed32(Int)
  QcSFixed64(Int64)
  QcFloat(Float)
  QcDouble(Double)
  QcBytes(Bytes)
  QcString(String)
  QcPackedDouble(Array[Double])
  QcPackedSInt32(Array[Int])
  QcSkippedGroup(Array[QcValue])
  QcSkippedValue(QcValue)
} derive(Debug)

///|
fn qc_doubles_equal(a : Array[Double], b : Array[Double]) -> Bool {
  guard a.length() == b.length() else { return false }
  for i in 0..<a.length() {
    if a[i].reinterpret_as_uint64() != b[i].reinterpret_as_uint64() {
      return false
    }
  }
  true
}

///|
pub impl Eq for QcValue with fn equal(self, other) {
  match (self, other) {
    (QcInt32(a), QcInt32(b)) => a == b
    (QcInt64(a), QcInt64(b)) => a == b
    (QcUInt32(a), QcUInt32(b)) => a == b
    (QcUInt64(a), QcUInt64(b)) => a == b
    (QcSInt32(a), QcSInt32(b)) => a == b
    (QcSInt64(a), QcSInt64(b)) => a == b
    (QcBool(a), QcBool(b)) => a == b
    (QcEnum(a), QcEnum(b)) => a == b
    (QcFixed32(a), QcFixed32(b)) => a == b
    (QcFixed64(a), QcFixed64(b)) => a == b
    (QcSFixed32(a), QcSFixed32(b)) => a == b
    (QcSFixed64(a), QcSFixed64(b)) => a == b
    (QcFloat(a), QcFloat(b)) =>
      a.reinterpret_as_uint() == b.reinterpret_as_uint()
    (QcDouble(a), QcDouble(b)) =>
      a.reinterpret_as_uint64() == b.reinterpret_as_uint64()
    (QcBytes(a), QcBytes(b)) => a == b
    (QcString(a), QcString(b)) => a == b
    (QcPackedDouble(a), QcPackedDouble(b)) => qc_doubles_equal(a, b)
    (QcPackedSInt32(a), QcPackedSInt32(b)) => a == b
    (QcSkippedGroup(a), QcSkippedGroup(b)) => a == b
    (QcSkippedValue(a), QcSkippedValue(b)) => a == b
    _ => false
  }
}

///|
/// Write one field's key and value with the `write_*` API. Known kinds
/// use field numbers 1..18; a skipped value is written under field 20
/// with its own wire type, and a skipped group as field 19's
/// SGROUP..EGROUP records around its members.
fn[W : @protobuf.Writer] qc_write_field(
  buf : W,
  field : QcValue,
  number~ : UInt,
) -> Unit raise {
  match field {
    QcInt32(v) => {
      buf |> @protobuf.write_tag((number, 0))
      buf |> @protobuf.write_int32(v)
    }
    QcInt64(v) => {
      buf |> @protobuf.write_tag((number, 0))
      buf |> @protobuf.write_int64(v)
    }
    QcUInt32(v) => {
      buf |> @protobuf.write_tag((number, 0))
      buf |> @protobuf.write_uint32(v)
    }
    QcUInt64(v) => {
      buf |> @protobuf.write_tag((number, 0))
      buf |> @protobuf.write_uint64(v)
    }
    QcSInt32(v) => {
      buf |> @protobuf.write_tag((number, 0))
      buf |> @protobuf.write_sint32(v)
    }
    QcSInt64(v) => {
      buf |> @protobuf.write_tag((number, 0))
      buf |> @protobuf.write_sint64(v)
    }
    QcBool(v) => {
      buf |> @protobuf.write_tag((number, 0))
      buf |> @protobuf.write_bool(v)
    }
    QcEnum(v) => {
      buf |> @protobuf.write_tag((number, 0))
      buf |> @protobuf.write_enum(Enum(v))
    }
    QcFixed32(v) => {
      buf |> @protobuf.write_tag((number, 5))
      buf |> @protobuf.write_fixed32(v)
    }
    QcFixed64(v) => {
      buf |> @protobuf.write_tag((number, 1))
      buf |> @protobuf.write_fixed64(v)
    }
    QcSFixed32(v) => {
      buf |> @protobuf.write_tag((number, 5))
      buf |> @protobuf.write_sfixed32(v)
    }
    QcSFixed64(v) => {
      buf |> @protobuf.write_tag((number, 1))
      buf |> @protobuf.write_sfixed64(v)
    }
    QcFloat(v) => {
      buf |> @protobuf.write_tag((number, 5))
      buf |> @protobuf.write_float(v)
    }
    QcDouble(v) => {
      buf |> @protobuf.write_tag((number, 1))
      buf |> @protobuf.write_double(v)
    }
    QcBytes(v) => {
      buf |> @protobuf.write_tag((number, 2))
      buf |> @protobuf.write_bytes(v)
    }
    QcString(v) => {
      buf |> @protobuf.write_tag((number, 2))
      buf |> @protobuf.write_string(v)
    }
    QcPackedDouble(xs) => {
      let inner = @buffer.Buffer()
      for x in xs {
        inner |> @protobuf.write_double(x)
      }
      buf |> @protobuf.write_tag((number, 2))
      buf |> @protobuf.write_bytes(inner.to_bytes())
    }
    QcPackedSInt32(xs) => {
      let inner = @buffer.Buffer()
      for x in xs {
        inner |> @protobuf.write_sint32(x)
      }
      buf |> @protobuf.write_tag((number, 2))
      buf |> @protobuf.write_bytes(inner.to_bytes())
    }
    QcSkippedGroup(members) => {
      buf |> @protobuf.write_tag((number, 3))
      for item in members {
        qc_write_field(buf, item, number=qc_field_number(item))
      }
      buf |> @protobuf.write_tag((number, 4))
    }
    QcSkippedValue(inner) => qc_write_field(buf, inner, number~)
  }
}

///|
fn qc_field_number(field : QcValue) -> UInt {
  match field {
    QcInt32(_) => 1
    QcInt64(_) => 2
    QcUInt32(_) => 3
    QcUInt64(_) => 4
    QcSInt32(_) => 5
    QcSInt64(_) => 6
    QcBool(_) => 7
    QcEnum(_) => 8
    QcFixed32(_) => 9
    QcFixed64(_) => 10
    QcSFixed32(_) => 11
    QcSFixed64(_) => 12
    QcFloat(_) => 13
    QcDouble(_) => 14
    QcBytes(_) => 15
    QcString(_) => 16
    QcPackedDouble(_) => 17
    QcPackedSInt32(_) => 18
    QcSkippedGroup(_) => 19
    QcSkippedValue(_) => 20
  }
}

///|
/// Encode a field list with the `write_*` API.
fn qc_encode(fields : Array[QcValue]) -> Bytes raise {
  let buf = @buffer.Buffer()
  for field in fields {
    qc_write_field(buf, field, number=qc_field_number(field))
  }
  buf.to_bytes()
}

///|
/// The fields `qc_decode` is expected to return: everything that is not
/// skipped as unknown.
fn qc_visible(fields : Array[QcValue]) -> Array[QcValue] {
  fields.filter(field => {
    match field {
      QcSkippedGroup(_) | QcSkippedValue(_) => false
      _ => true
    }
  })
}

///|
/// Decode a field list written by `qc_encode`: read keys until end of
/// stream, dispatching each field number to the matching `read_*` call
/// (17 and 18 through `read_packed`); any other key — the skipped kinds
/// — goes through `read_unknown`.
fn[R : @protobuf.Reader] qc_decode(reader : R) -> Array[QcValue] raise {
  let fields : Array[QcValue] = []
  for ;; {
    let next = try reader |> @protobuf.read_tag() catch {
      _ => None
    } noraise {
      v => Some(v)
    }
    guard next is Some(tag) else { break }
    match tag.0 {
      1 => fields.push(QcInt32(reader |> @protobuf.read_int32()))
      2 => fields.push(QcInt64(reader |> @protobuf.read_int64()))
      3 => fields.push(QcUInt32(reader |> @protobuf.read_uint32()))
      4 => fields.push(QcUInt64(reader |> @protobuf.read_uint64()))
      5 => fields.push(QcSInt32((reader |> @protobuf.read_sint32()).0))
      6 => fields.push(QcSInt64((reader |> @protobuf.read_sint64()).0))
      7 => fields.push(QcBool(reader |> @protobuf.read_bool()))
      8 => fields.push(QcEnum((reader |> @protobuf.read_enum()).0))
      9 => fields.push(QcFixed32(reader |> @protobuf.read_fixed32()))
      10 => fields.push(QcFixed64(reader |> @protobuf.read_fixed64()))
      11 => fields.push(QcSFixed32(reader |> @protobuf.read_sfixed32()))
      12 => fields.push(QcSFixed64(reader |> @protobuf.read_sfixed64()))
      13 => fields.push(QcFloat(reader |> @protobuf.read_float()))
      14 => fields.push(QcDouble(reader |> @protobuf.read_double()))
      15 => fields.push(QcBytes(reader |> @protobuf.read_bytes()))
      16 => fields.push(QcString(reader |> @protobuf.read_string()))
      17 => {
        let xs = reader
          |> @protobuf.read_packed(r => r |> @protobuf.read_double())
        fields.push(QcPackedDouble(xs))
      }
      18 => {
        let xs = reader
          |> @protobuf.read_packed(r => r |> @protobuf.read_sint32())
        fields.push(QcPackedSInt32(xs.map(s => s.0)))
      }
      _ => reader |> @protobuf.read_unknown(tag)
    }
  }
  fields
}

///|
/// Generators. Every kind mixes ordinary values with its wire-format
/// boundary values (varint length breakpoints, extremes, special float
/// bit patterns). NaN bit patterns are canonicalized to the quiet NaNs
/// `0x7FC00000` / `0x7FF8000000000000` so generated values survive any
/// float plumbing bit-for-bit.
let qc_int32_gen : @quickcheck.Generator[Int] = @quickcheck.frequency([
  (4, @quickcheck.int_range(-1000, 1000)),
  (
    2,
    @quickcheck.elements([
      0, 1, -1, 127, 128, -128, 16383, 16384, 2097151, 2097152, 268435455, 268435456,
      2147483647, -2147483648,
    ]),
  ),
])

///|
let qc_int64_gen : @quickcheck.Generator[Int64] = @quickcheck.frequency([
  (4, @quickcheck.int_range(-1000, 1000).map(i => i.to_int64())),
  (
    2,
    @quickcheck.elements([
      0L, 1L, -1L, 127L, 128L, 34359738367L, 34359738368L, 72057594037927935L, 72057594037927936L,
      9223372036854775807L, -9223372036854775808L,
    ]),
  ),
])

///|
let qc_uint32_gen : @quickcheck.Generator[UInt] = @quickcheck.frequency([
  (4, @quickcheck.int_range(0, 1000).map(i => i.reinterpret_as_uint())),
  (
    2,
    @quickcheck.elements([
      0, 1, 127, 128, 16383, 16384, 2097151, 2097152, 268435455, 268435456, 2147483647,
      2147483648, 4294967295,
    ]),
  ),
])

///|
let qc_uint64_gen : @quickcheck.Generator[UInt64] = @quickcheck.frequency([
  (
    4,
    @quickcheck.int_range(0, 1000).map(i => i.to_int64().reinterpret_as_uint64()),
  ),
  (
    2,
    @quickcheck.elements([
      0, 1, 127, 128, 34359738367, 34359738368, 72057594037927935, 72057594037927936,
      9223372036854775807, 9223372036854775808, 18446744073709551615,
    ]),
  ),
])

///|
let qc_float_bits_gen : @quickcheck.Generator[UInt] = @quickcheck.frequency([
  (
    3,
    @quickcheck.elements([
      0x00000000, 0x80000000, 0x3F800000, 0xBF800000, 0x7F800000, 0xFF800000, 0x7FC00000,
      0x00000001, 0x007FFFFF, 0x7F7FFFFF,
    ]),
  ),
  (
    3,
    @quickcheck.int_range(-2147483648, 2147483647).map(bits => {
      let bits = bits.reinterpret_as_uint()
      // canonicalize NaNs to the quiet NaN
      if (bits & 0x7F800000) == 0x7F800000 && (bits & 0x007FFFFF) != 0 {
        0x7FC00000
      } else {
        bits
      }
    }),
  ),
])

///|
let qc_float_gen : @quickcheck.Generator[Float] = qc_float_bits_gen.map(bits => {
  Float::reinterpret_from_uint(bits)
})

///|
let qc_double_gen : @quickcheck.Generator[Double] = @quickcheck.frequency([
  (
    3,
    @quickcheck.elements([
      0.0, -0.0, 1.5, -2.5, @double.infinity, @double.neg_infinity, @double.not_a_number,
      5.0e-324, 1.7976931348623157e308, 1.0e-9, 3.14159,
    ]),
  ),
  (3, @quickcheck.int_range(-8000, 8000).map(i => i.to_double() / 8.0)),
])

///|
let qc_byte_gen : @quickcheck.Generator[Byte] = @quickcheck.int_range(0, 255).map(i => {
    i.to_byte()
  },
)

///|
let qc_bytes_gen : @quickcheck.Generator[Bytes] = @quickcheck.int_range(0, 12).flat_map(len => {
    qc_byte_gen.array_with_size(len).map(arr => Bytes::from_array(arr))
  },
)

///|
/// String characters: anything goes as long as the string is valid
/// UTF-8, so mix ASCII with control characters and multi-byte scalars.
let qc_char_gen : @quickcheck.Generator[Char] = @quickcheck.frequency([
  (5, @quickcheck.char_range('a', 'z')),
  (2, @quickcheck.char_range('0', '9')),
  (
    2,
    @quickcheck.elements([' ', '!', '"', '\\', '/', '=', '\n', '\t', '\u{0}']),
  ),
  (
    1,
    @quickcheck.elements([
      'é', '中', '文', '😀', '\u{7FF}', '\u{FEFF}', '\u{FFFD}', '\u{10FFFF}',
    ]),
  ),
])

///|
let qc_string_gen : @quickcheck.Generator[String] = @quickcheck.int_range(0, 12).flat_map(len => {
    qc_char_gen.array_with_size(len).map(cs => String::from_array(cs))
  },
)

///|
/// A known (non-skipped) field.
let qc_known_gen : @quickcheck.Generator[QcValue] = @quickcheck.frequency([
  (3, qc_int32_gen.map(v => QcInt32(v))),
  (3, qc_int64_gen.map(v => QcInt64(v))),
  (3, qc_uint32_gen.map(v => QcUInt32(v))),
  (3, qc_uint64_gen.map(v => QcUInt64(v))),
  (3, qc_int32_gen.map(v => QcSInt32(v))),
  (3, qc_int64_gen.map(v => QcSInt64(v))),
  (1, @quickcheck.elements([QcBool(true), QcBool(false)])),
  (2, qc_uint32_gen.map(v => QcEnum(v))),
  (2, qc_uint32_gen.map(v => QcFixed32(v))),
  (2, qc_uint64_gen.map(v => QcFixed64(v))),
  (2, qc_int32_gen.map(v => QcSFixed32(v))),
  (2, qc_int64_gen.map(v => QcSFixed64(v))),
  (2, qc_float_gen.map(v => QcFloat(v))),
  (2, qc_double_gen.map(v => QcDouble(v))),
  (3, qc_bytes_gen.map(v => QcBytes(v))),
  (3, qc_string_gen.map(v => QcString(v))),
  (
    2,
    @quickcheck.int_range(0, 4).flat_map(n => {
      qc_double_gen.array_with_size(n).map(xs => QcPackedDouble(xs))
    }),
  ),
  (
    2,
    @quickcheck.int_range(0, 4).flat_map(n => {
      qc_int32_gen.array_with_size(n).map(xs => QcPackedSInt32(xs))
    }),
  ),
])

///|
/// A group's members: known fields, occasionally a nested group.
let qc_member_gen : @quickcheck.Generator[QcValue] = @quickcheck.frequency([
  (6, qc_known_gen),
  (
    1,
    @quickcheck.int_range(0, 2).flat_map(n => {
      qc_known_gen.array_with_size(n).map(xs => QcSkippedGroup(xs))
    }),
  ),
])

///|
let qc_value_gen : @quickcheck.Generator[QcValue] = @quickcheck.frequency([
  (12, qc_known_gen),
  (
    1,
    @quickcheck.int_range(0, 3).flat_map(n => {
      qc_member_gen.array_with_size(n).map(xs => QcSkippedGroup(xs))
    }),
  ),
  (1, qc_known_gen.map(v => QcSkippedValue(v))),
])

///|
pub impl @quickcheck.Arbitrary for QcValue with fn arbitrary(size, rand) {
  qc_value_gen.run(size, rand)
}

///|
/// Shrinking keeps the kind (and so the field number) and shrinks the
/// payload with the core instances; every candidate is still a valid
/// value of the same kind, so counterexamples minimize without leaving
/// the dialect.
pub impl @quickcheck.Shrink for QcValue with fn shrink(self) {
  match self {
    QcInt32(v) => @quickcheck.Shrink::shrink(v).map(x => QcInt32(x))
    QcInt64(v) => @quickcheck.Shrink::shrink(v).map(x => QcInt64(x))
    QcUInt32(v) => @quickcheck.Shrink::shrink(v).map(x => QcUInt32(x))
    QcUInt64(v) => @quickcheck.Shrink::shrink(v).map(x => QcUInt64(x))
    QcSInt32(v) => @quickcheck.Shrink::shrink(v).map(x => QcSInt32(x))
    QcSInt64(v) => @quickcheck.Shrink::shrink(v).map(x => QcSInt64(x))
    QcBool(v) => if v { Iter::singleton(QcBool(false)) } else { Iter::empty() }
    QcEnum(v) => @quickcheck.Shrink::shrink(v).map(x => QcEnum(x))
    QcFixed32(v) => @quickcheck.Shrink::shrink(v).map(x => QcFixed32(x))
    QcFixed64(v) => @quickcheck.Shrink::shrink(v).map(x => QcFixed64(x))
    QcSFixed32(v) => @quickcheck.Shrink::shrink(v).map(x => QcSFixed32(x))
    QcSFixed64(v) => @quickcheck.Shrink::shrink(v).map(x => QcSFixed64(x))
    QcFloat(v) =>
      if v.reinterpret_as_uint() == 0 {
        Iter::empty()
      } else {
        Iter::singleton(QcFloat(0.0))
      }
    QcDouble(v) =>
      if v.reinterpret_as_uint64() == 0 {
        Iter::empty()
      } else {
        Iter::singleton(QcDouble(0.0))
      }
    QcBytes(v) => @quickcheck.Shrink::shrink(v).map(x => QcBytes(x))
    QcString(v) => @quickcheck.Shrink::shrink(v).map(x => QcString(x))
    QcPackedDouble(xs) =>
      @quickcheck.Shrink::shrink(xs.map(x => x.reinterpret_as_uint64())).map(bs => {
        QcPackedDouble(bs.map(b => b.reinterpret_as_double()))
      })
    QcPackedSInt32(xs) =>
      @quickcheck.Shrink::shrink(xs).map(x => QcPackedSInt32(x))
    QcSkippedGroup(xs) =>
      @quickcheck.Shrink::shrink(xs).map(x => QcSkippedGroup(x))
    QcSkippedValue(v) =>
      @quickcheck.Shrink::shrink(v).map(x => QcSkippedValue(x))
  }
}
