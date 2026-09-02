///|
/// Generators and shrinkers for the encode/decode round-trip property.
/// HPACK treats header names and values as opaque octet sequences
/// (RFC 7541 section 1.3), so EVERY `HeaderField` is well-formed and
/// every shrink candidate stays in-dialect by construction. Generation
/// only shapes the distribution: static-table names and common values
/// (so indexed and name-indexed representations are exercised), short
/// ASCII, and arbitrary binary octets (so Huffman coding and raw literals
/// see the full alphabet).
let qc_common_names : Array[Bytes] = [
  b":authority", b":method", b":path", b":scheme", b":status", b"accept", b"accept-encoding",
  b"cache-control", b"content-type", b"cookie", b"user-agent", b"x-custom", b"x-trace-id",
]

///|
let qc_common_values : Array[Bytes] = [
  b"", b"GET", b"POST", b"/", b"https", b"200", b"gzip, deflate", b"application/json",
  b"no-cache",
]

///|
let qc_octet : @quickcheck.Generator[Byte] = @quickcheck.frequency([
  (6, @quickcheck.char_range('a', 'z').map(c => c.to_int().to_byte())),
  (2, @quickcheck.int_range(0x20, 0x7e).map(i => i.to_byte())),
  (2, @quickcheck.int_range(0, 255).map(i => i.to_byte())),
])

///|
fn qc_bytes(min~ : Int, max~ : Int) -> @quickcheck.Generator[Bytes] {
  @quickcheck.int_range(min, max).flat_map(len => {
    qc_octet.array_with_size(len).map(octets => Bytes::from_array(octets))
  })
}

///|
let qc_name_gen : @quickcheck.Generator[Bytes] = @quickcheck.frequency([
  (3, @quickcheck.elements(qc_common_names)),
  (5, qc_bytes(min=1, max=12)),
  (1, qc_bytes(min=0, max=2)),
])

///|
let qc_value_gen : @quickcheck.Generator[Bytes] = @quickcheck.frequency([
  (3, @quickcheck.elements(qc_common_values)),
  (6, qc_bytes(min=0, max=16)),
])

///|
pub impl @quickcheck.Arbitrary for HeaderField with fn arbitrary(size, rand) {
  { name: qc_name_gen.run(size, rand), value: qc_value_gen.run(size, rand), }
}

///|
/// Shrink a field by shrinking its name and its value with the core
/// `Bytes` instance (whose candidates only drop or simplify octets, so
/// they are always valid header octets).
pub impl @quickcheck.Shrink for HeaderField with fn shrink(self) {
  @quickcheck.Shrink::shrink(self.name)
  .map(n => { name: n, value: self.value, })
  .concat(
    @quickcheck.Shrink::shrink(self.value).map(v => {
      name: self.name,
      value: v,
    }),
  )
}
