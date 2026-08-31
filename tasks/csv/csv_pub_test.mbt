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
test "quickcheck: roundtrips" {
  @quickcheck.check(
    (doc : @csv.Doc) => @csv.parse(@csv.print(doc)) == doc,
    count=300,
  )
}

///|
test "quickcheck: parse should never panic" {
  @quickcheck.check((s : String) => {
    try @csv.parse(s) catch {
      _ => true
    } noraise {
      _ => true
    }
  })
}
