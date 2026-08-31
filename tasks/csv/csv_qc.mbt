///|
let field_char : @quickcheck.Generator[Char] = @quickcheck.frequency() <| [
  (4, @quickcheck.char_range('a', 'z')),
  (4, @quickcheck.char_range('0', '9')),
  (3, @quickcheck.elements([',', '"', '\n', '\r'])),
  (1, @quickcheck.elements([' ', '你', '好', '😀', 'é'])),
]

///|
let field : @quickcheck.Generator[String] = @quickcheck.int_range(0, 9).flat_map() <| len => {
  field_char.array_with_size(len).map(chars => String::from_array(chars))
}

///|
let records : @quickcheck.Generator[Array[Array[String]]] = @quickcheck.int_range(
  1, 6,
).flat_map() <| cols => {
  @quickcheck.int_range(0, 7).flat_map() <| rows => {
    field.array_with_size(cols).array_with_size(rows)
  }
}

///|
pub impl @quickcheck.Arbitrary for Doc with fn arbitrary(size, rand) {
  records.run(size, rand)
}

///|
pub impl @quickcheck.Shrink for Doc with fn shrink(self) {
  @quickcheck.Shrink::shrink(self.0).map(records => Doc(records))
}
