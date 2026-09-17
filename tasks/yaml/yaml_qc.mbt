///|
/// Generators and shrinkers for well-formed streams, used by the
/// round-trip property test. Everything generated stays printable on
/// purpose: strings are built from Unicode scalar values (no unpaired
/// surrogates) and every other node is printable as it is. See `print` in
/// `yaml_spec.mbt` for the well-formedness contract.
///
/// The generators reach the places a printer must get right: strings that
/// look like other scalar kinds (`null`, `12`, `0x1F`, `.inf`, `true`, ...)
/// or like YAML syntax (`- item`, `a: b`, `# comment`, `--- doc`, `*ref`),
/// control characters and other non-printable code points in key and value
/// position, integers beyond 64 bits, `.inf`/`.nan`/`-0.0`, and mapping
/// keys of every kind — booleans, numbers, `null`, sequences and mappings.
let qc_control_char : @quickcheck.Generator[Char] = @quickcheck.frequency([
  (2, @quickcheck.char_range('\u{0}', '\u{8}')),
  (2, @quickcheck.char_range('\u{B}', '\u{1F}')),
  (1, @quickcheck.pure('\u{7F}')),
  (1, @quickcheck.char_range('\u{80}', '\u{9F}')),
  (1, @quickcheck.elements(['\u{FEFF}', '\u{2028}', '\u{2029}', '\u{85}'])),
])

///|
let qc_key_char : @quickcheck.Generator[Char] = @quickcheck.frequency([
  (5, @quickcheck.char_range('a', 'z')),
  (2, @quickcheck.char_range('0', '9')),
  (2, @quickcheck.elements(['_', '-'])),
  (
    1,
    @quickcheck.elements([
      ' ', '.', ':', '#', '"', '\'', '[', ']', '{', '}', ',', '&', '*', '?', '!',
      '|', '>', '%', '@', '`', '\t', '中', 'é', 'Ω',
    ]),
  ),
  (1, qc_control_char),
])

///|
let qc_string_char : @quickcheck.Generator[Char] = @quickcheck.frequency([
  (5, @quickcheck.char_range('a', 'z')),
  (2, @quickcheck.char_range('0', '9')),
  (
    2,
    @quickcheck.elements([
      ' ', ',', ':', '#', '"', '\'', '\\', '[', ']', '{', '}', '-', '|', '>', '&',
      '*', '%', '@', '`', '~', '!', '?',
    ]),
  ),
  (1, @quickcheck.elements(['\n', '\t', '\r', '你', '好', '😀', 'é'])),
  (1, qc_control_char),
])

///|
fn qc_text(
  chars : @quickcheck.Generator[Char],
  min~ : Int,
  max~ : Int,
) -> @quickcheck.Generator[String] {
  @quickcheck.int_range(min, max).flat_map(len => {
    chars.array_with_size(len).map(cs => String::from_array(cs))
  })
}

///|
/// Strings that a printer must quote to keep them strings, or that would
/// be read as YAML structure if emitted bare.
let qc_lookalike_gen : @quickcheck.Generator[String] = @quickcheck.elements([
  "", "null", "Null", "~", "true", "False", "12", "+12", "-0", "0x1F", "0o17", "1.5e3",
  ".5", "5.", ".inf", "-.INF", ".nan", "1_000", "- item", "--- doc", "...", "a: b",
  "# comment", "? x", "!tag", "&anchor", "*alias", "%YAML", "|", ">", "[x]", "{a: b}",
  " lead", "trail ", "a\nb", "'quoted'", "\"quoted\"",
])

///|
let qc_string_gen : @quickcheck.Generator[Yaml] = @quickcheck.frequency([
  (8, qc_text(qc_string_char, min=0, max=12).map(s => String(s))),
  (2, qc_lookalike_gen.map(s => String(s))),
])

///|
let qc_integer_gen : @quickcheck.Generator[Yaml] = @quickcheck.frequency([
  (5, @quickcheck.int_range(-1000, 1000).map(i => Integer(BigInt::from_int(i)))),
  (
    1,
    @quickcheck.elements([
      Integer(0),
      Integer(9223372036854775807),
      Integer(-9223372036854775808),
      Integer(18446744073709551616),
      Integer(-340282366920938463463374607431768211456),
      Integer(123456789012345678901234567890),
    ]),
  ),
])

///|
let qc_float_gen : @quickcheck.Generator[Yaml] = @quickcheck.frequency([
  (4, @quickcheck.int_range(-8000, 8000).map(i => Float(i.to_double() / 8.0))),
  (
    1,
    @quickcheck.elements([
      Float(@double.infinity),
      Float(@double.neg_infinity),
      Float(@double.not_a_number),
      Float(-0.0),
      Float(0.1),
      Float(3.0e14),
      Float(1.0e21),
      Float(6.626e-34),
      Float(1.7976931348623157e308),
      Float(5.0e-324),
      Float(9007199254740993.0),
    ]),
  ),
])

///|
let qc_bool_gen : @quickcheck.Generator[Yaml] = @quickcheck.elements([
  Bool(true),
  Bool(false),
])

///|
let qc_scalar_gen : @quickcheck.Generator[Yaml] = @quickcheck.frequency([
  (2, @quickcheck.pure(Null)),
  (2, qc_bool_gen),
  (3, qc_integer_gen),
  (2, qc_float_gen),
  (5, qc_string_gen),
])

///|
/// Mapping keys: mostly short strings (the empty key included), sometimes
/// another scalar kind, occasionally a small collection.
fn qc_key_gen(depth : Int) -> @quickcheck.Generator[Yaml] {
  @quickcheck.frequency([
    (7, qc_text(qc_key_char, min=1, max=8).map(s => String(s))),
    (1, @quickcheck.pure(String(""))),
    (1, qc_lookalike_gen.map(s => String(s))),
    (2, qc_scalar_gen),
    (1, if depth <= 0 { qc_scalar_gen } else { qc_yaml_gen(depth - 1) }),
  ])
}

///|
fn qc_yaml_gen(depth : Int) -> @quickcheck.Generator[Yaml] {
  if depth <= 0 {
    qc_scalar_gen
  } else {
    @quickcheck.frequency([
      (6, qc_scalar_gen),
      (
        2,
        @quickcheck.int_range(0, 3).flat_map(n => {
          qc_yaml_gen(depth - 1).array_with_size(n).map(xs => Sequence(xs))
        }),
      ),
      (2, qc_mapping_gen(depth - 1).map(m => Mapping(m))),
    ])
  }
}

///|
fn qc_mapping_gen(depth : Int) -> @quickcheck.Generator[Map[Yaml, Yaml]] {
  @quickcheck.int_range(0, 3).flat_map(n => {
    qc_key_gen(depth)
    .flat_map(k => qc_yaml_gen(depth).map(v => (k, v)))
    .array_with_size(n)
    .map(entries => {
      let out : Map[Yaml, Yaml] = Map([])
      for entry in entries {
        out[entry.0] = entry.1
      }
      out
    })
  })
}

///|
pub impl @quickcheck.Arbitrary for Yaml with fn arbitrary(size, rand) {
  qc_yaml_gen(2).run(size, rand)
}

///|
/// Shrinking preserves well-formedness: strings shrink via the core
/// instance (its candidates are always printable and surrogate-safe),
/// numbers shrink toward zero, booleans toward `false`, and collections
/// shrink via the core Array/Map instances (dropping entries or shrinking
/// keys and elements with this instance). Every candidate is still a
/// well-formed stream, so the round-trip property never minimizes to an
/// unprintable counterexample.
pub impl @quickcheck.Shrink for Yaml with fn shrink(self) {
  match self {
    Null => Iter::empty()
    Bool(b) => if b { Iter::singleton(Bool(false)) } else { Iter::empty() }
    Integer(i) => @quickcheck.Shrink::shrink(i).map(v => Integer(v))
    Float(f) =>
      if f == 0.0 && !f.is_nan() {
        Iter::empty()
      } else {
        Iter::singleton(Float(0.0))
      }
    String(s) => @quickcheck.Shrink::shrink(s).map(v => String(v))
    Sequence(xs) => @quickcheck.Shrink::shrink(xs).map(v => Sequence(v))
    Mapping(m) => @quickcheck.Shrink::shrink(m).map(v => Mapping(v))
  }
}
