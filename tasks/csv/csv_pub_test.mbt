///|
test "edge/quotes/double-quote-escape" {
  let csv_text =
    #|"a""b",c
    #|
  let csv = @csv.parse(csv_text)
  assert_eq(csv, [["a\"b", "c"]])
}

///|
test "edge/quotes/multiple-escapes" {
  let csv_text =
    #|"a""b""c",d
    #|
  let csv = @csv.parse(csv_text)
  assert_eq(csv, [["a\"b\"c", "d"]])
}

///|
test "edge/quotes/only-quotes" {
  let csv_text =
    #|"""",a
    #|
  let csv = @csv.parse(csv_text)
  assert_eq(csv, [["\"", "a"]])
}

///|
test "edge/quotes/quoted-comma" {
  let csv_text =
    #|"a,b",c
    #|
  let csv = @csv.parse(csv_text)
  assert_eq(csv, [["a,b", "c"]])
}

///|
test "edge/quotes/quoted-newline" {
  let csv_text =
    #|"a
    #|b",c
    #|
  let csv = @csv.parse(csv_text)
  assert_eq(csv, [["a\nb", "c"]])
}

///|
test "edge/quotes/quoted-crlf" {
  let csv_text = "\"a\r\nb\",c\r\n"
  let csv = @csv.parse(csv_text)
  assert_eq(csv, [["a\r\nb", "c"]])
}

///|
test "edge/empty/all-empty-fields" {
  let csv_text =
    #|,,
    #|
  let csv = @csv.parse(csv_text)
  assert_eq(csv, [["", "", ""]])
}

///|
test "edge/empty/single-empty-field" {
  let csv_text = "\n"
  let csv = @csv.parse(csv_text)
  assert_eq(csv, [[""]])
}

///|
test "edge/empty/quoted-empty" {
  let csv_text =
    #|"","",""
    #|
  let csv = @csv.parse(csv_text)
  assert_eq(csv, [["", "", ""]])
}

///|
test "edge/line-endings/lf-only" {
  let csv_text = "a,b\nc,d\n"
  let csv = @csv.parse(csv_text)
  assert_eq(csv, [["a", "b"], ["c", "d"]])
}

///|
/// Minimal RFC 4180 field escaper for the roundtrip property: quote when the
/// field contains a structural char, double the quotes inside; an empty field
/// is always quoted so a one-empty-field record stays distinguishable from an
/// empty document.
fn escape_field(f : String) -> String {
  let mut needs_quoting = f.is_empty()
  for c in f {
    if c is (',' | '"' | '\n' | '\r') {
      needs_quoting = true
    }
  }
  if !needs_quoting {
    return f
  }
  let sb = StringBuilder()
  sb.write_char('"')
  for c in f {
    if c == '"' {
      sb.write_char('"')
    }
    sb.write_char(c)
  }
  sb.write_char('"')
  sb.to_string()
}

///|
test "qc/roundtrips" {
  @quickcheck.check(
    (fields : Array[String]) => {
      let line = fields.map(escape_field).join(",")
      @csv.parse(line) == [fields]
    },
    filter=(fields : Array[String]) => !fields.is_empty(),
    count=200,
  )
}

///|
test "qc/never-panics" {
  @quickcheck.check((s : String) => {
    try @csv.parse(s) catch {
      _ => true
    } noraise {
      _ => true
    }
  })
}
