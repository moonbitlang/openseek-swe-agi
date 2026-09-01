///|
/// Generators and shrinkers for well-formed documents, used by the
/// round-trip property test. Everything generated stays printable on
/// purpose: strings are built from Unicode scalar values (no unpaired
/// surrogates), and date/time components stay within their TOML ranges
/// (year 0..9999, real calendar dates, second <= 60 for leap seconds,
/// nanosecond below 1_000_000_000, |offset| <= 23:59). See `print` in
/// `toml_spec.mbt` for the well-formedness contract.
///
/// Both generators reach the characters a printer must escape — `"`, `\`,
/// and the control characters — in key *and* value position, so a printer
/// that quotes without escaping fails the round-trip.
///
/// The control set is the whole range a basic string must escape:
/// U+0000-U+0008, U+000A-U+001F and U+007F. Tab (U+0009) is the one
/// control character that may stand for itself. U+007F is the awkward
/// member — it sits above C0, so the common `c < 0x20` test leaves it raw
/// and emits invalid TOML.
let qc_control_char : @quickcheck.Generator[Char] = @quickcheck.frequency([
  (1, @quickcheck.char_range('\u{0}', '\u{8}')),
  (2, @quickcheck.char_range('\u{A}', '\u{1F}')),
  (1, @quickcheck.pure('\u{7F}')),
])

///|
let qc_key_char : @quickcheck.Generator[Char] = @quickcheck.frequency([
  (5, @quickcheck.char_range('a', 'z')),
  (2, @quickcheck.char_range('0', '9')),
  (2, @quickcheck.elements(['_', '-'])),
  (
    1,
    @quickcheck.elements([
      ' ', '.', '"', '\'', '[', '=', '\\', '\t', '中', 'é', 'Ω',
    ]),
  ),
  (1, qc_control_char),
])

///|
let qc_string_char : @quickcheck.Generator[Char] = @quickcheck.frequency([
  (5, @quickcheck.char_range('a', 'z')),
  (2, @quickcheck.char_range('0', '9')),
  (2, @quickcheck.elements([' ', ',', '=', '#', '"', '\'', '\\', '[', ']'])),
  (1, @quickcheck.elements(['\t', '你', '好', '😀', 'é'])),
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
let qc_key_gen : @quickcheck.Generator[String] = @quickcheck.frequency([
  (9, qc_text(qc_key_char, min=1, max=8)),
  (1, @quickcheck.pure("")),
])

///|
let qc_string_gen : @quickcheck.Generator[Toml] = qc_text(
  qc_string_char,
  min=0,
  max=12,
).map(s => String(s))

///|
let qc_integer_gen : @quickcheck.Generator[Toml] = @quickcheck.frequency([
  (5, @quickcheck.int_range(-1000, 1000).map(i => Integer(i.to_int64()))),
  (
    1,
    @quickcheck.elements([
      Integer(9223372036854775807),
      Integer(-9223372036854775808),
      Integer(0),
    ]),
  ),
])

///|
let qc_float_gen : @quickcheck.Generator[Toml] = @quickcheck.frequency([
  (4, @quickcheck.int_range(-8000, 8000).map(i => Float(i.to_double() / 8.0))),
  (
    1,
    @quickcheck.elements([
      Float(@double.infinity),
      Float(@double.neg_infinity),
      Float(@double.not_a_number),
      Float(-0.0),
      Float(3.0e14),
      Float(6.626e-34),
      Float(1.7976931348623157e308),
      Float(5.0e-324),
    ]),
  ),
])

///|
let qc_bool_gen : @quickcheck.Generator[Toml] = @quickcheck.elements([
  Bool(true),
  Bool(false),
])

///|
fn qc_days_in(year : Int, month : Int) -> Int {
  if month == 2 {
    if (year % 4 == 0 && year % 100 != 0) || year % 400 == 0 {
      29
    } else {
      28
    }
  } else if month == 4 || month == 6 || month == 9 || month == 11 {
    30
  } else {
    31
  }
}

///|
let qc_date_gen : @quickcheck.Generator[Date] = @quickcheck.frequency([
  (4, @quickcheck.int_range(1900, 2100)),
  // 0 and 9999 are the ends of `date-fullyear = 4DIGIT`; 1900 and 2000 pin
  // the two halves of the Gregorian century rule.
  (1, @quickcheck.elements([0, 1, 9999, 1900, 2000, 2024])),
]).flat_map(year => {
  @quickcheck.int_range(1, 12).flat_map(month => {
    @quickcheck.int_range(1, qc_days_in(year, month)).map(day => {
      year,
      month,
      day,
    })
  })
})

///|
let qc_nanosecond_gen : @quickcheck.Generator[Int] = @quickcheck.frequency([
  (3, @quickcheck.pure(0)),
  (1, @quickcheck.int_range(0, 999_999_999)),
  (1, @quickcheck.elements([1, 600_000_000, 999_999_999, 123_456_789])),
])

///|
let qc_second_gen : @quickcheck.Generator[Int] = @quickcheck.frequency([
  (9, @quickcheck.int_range(0, 59)),
  // RFC 3339 leap second
  (1, @quickcheck.pure(60)),
])

///|
let qc_time_gen : @quickcheck.Generator[Time] = @quickcheck.int_range(0, 23).flat_map(hour => {
    @quickcheck.int_range(0, 59).flat_map(minute => {
      qc_second_gen.flat_map(second => {
        qc_nanosecond_gen.map(nanosecond => {
          hour,
          minute,
          second,
          nanosecond,
        })
      })
    })
  },
)

///|
let qc_offset_gen : @quickcheck.Generator[Int] = @quickcheck.frequency([
  (3, @quickcheck.pure(0)),
  (2, @quickcheck.elements([-420, 60, 570, -1439, 1439])),
  (2, @quickcheck.int_range(-1439, 1439)),
])

///|
let qc_datetime_gen : @quickcheck.Generator[Toml] = qc_date_gen.flat_map(d => {
  qc_time_gen.flat_map(t => qc_offset_gen.map(o => Datetime(d, t, offset=o)))
})

///|
let qc_scalar_gen : @quickcheck.Generator[Toml] = @quickcheck.frequency([
  (3, qc_string_gen),
  (3, qc_integer_gen),
  (2, qc_float_gen),
  (2, qc_bool_gen),
  (1, qc_datetime_gen),
  (1, qc_date_gen.flat_map(d => qc_time_gen.map(t => LocalDatetime(d, t)))),
  (1, qc_date_gen.map(d => LocalDate(d))),
  (1, qc_time_gen.map(t => LocalTime(t))),
])

///|
fn qc_toml_gen(depth : Int) -> @quickcheck.Generator[Toml] {
  if depth <= 0 {
    qc_scalar_gen
  } else {
    @quickcheck.frequency([
      (6, qc_scalar_gen),
      (
        2,
        @quickcheck.int_range(0, 3).flat_map(n => {
          qc_toml_gen(depth - 1).array_with_size(n).map(xs => Array(xs))
        }),
      ),
      (2, qc_table_gen(depth - 1).map(m => Table(m))),
    ])
  }
}

///|
fn qc_table_gen(depth : Int) -> @quickcheck.Generator[Map[String, Toml]] {
  @quickcheck.int_range(0, 3).flat_map(n => {
    qc_key_gen
    .flat_map(k => qc_toml_gen(depth).map(v => (k, v)))
    .array_with_size(n)
    .map(entries => {
      let out : Map[String, Toml] = Map([])
      for entry in entries {
        out[entry.0] = entry.1
      }
      out
    })
  })
}

///|
pub impl @quickcheck.Arbitrary for Toml with fn arbitrary(size, rand) {
  qc_toml_gen(2).run(size, rand)
}

///|
/// Shrinking preserves well-formedness: strings shrink via the core
/// instance (its candidates are always printable), numbers shrink toward
/// zero, datetimes shrink toward a fixed simple value of the same kind,
/// and containers shrink via the core Array/Map instances (dropping
/// entries or shrinking elements with this instance). Every candidate is
/// still a well-formed document, so the round-trip property never
/// minimizes to an unprintable counterexample.
pub impl @quickcheck.Shrink for Toml with fn shrink(self) {
  match self {
    String(s) => @quickcheck.Shrink::shrink(s).map(v => String(v))
    Integer(i) => @quickcheck.Shrink::shrink(i).map(v => Integer(v))
    Float(f) =>
      if f == 0.0 && !f.is_nan() {
        Iter::empty()
      } else {
        Iter::singleton(Float(0.0))
      }
    Bool(b) => if b { Iter::singleton(Bool(false)) } else { Iter::empty() }
    Datetime(d, t, offset=o) => {
      let out : Array[Toml] = []
      if o != 0 {
        out.push(Datetime(d, t, offset=0))
      }
      if t.nanosecond != 0 {
        out.push(Datetime(d, { ..t, nanosecond: 0, }, offset=o))
      }
      let base : Toml = Datetime(qc_base_date, qc_base_time, offset=0)
      if self != base {
        out.push(base)
      }
      out.iter()
    }
    LocalDatetime(d, t) => {
      let out : Array[Toml] = []
      if t.nanosecond != 0 {
        out.push(LocalDatetime(d, { ..t, nanosecond: 0, }))
      }
      let base : Toml = LocalDatetime(qc_base_date, qc_base_time)
      if self != base {
        out.push(base)
      }
      out.iter()
    }
    LocalDate(d) =>
      if d == qc_base_date {
        Iter::empty()
      } else {
        Iter::singleton(LocalDate(qc_base_date))
      }
    LocalTime(t) => {
      let out : Array[Toml] = []
      if t.nanosecond != 0 {
        out.push(LocalTime({ ..t, nanosecond: 0, }))
      }
      let base : Toml = LocalTime(qc_base_time)
      if self != base {
        out.push(base)
      }
      out.iter()
    }
    Array(xs) => @quickcheck.Shrink::shrink(xs).map(v => Array(v))
    Table(m) => @quickcheck.Shrink::shrink(m).map(v => Table(v))
  }
}

///|
let qc_base_date : Date = { year: 2000, month: 1, day: 1, }

///|
let qc_base_time : Time = { hour: 0, minute: 0, second: 0, nanosecond: 0, }
