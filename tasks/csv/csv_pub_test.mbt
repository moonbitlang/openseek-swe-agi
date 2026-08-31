///|
test "edge/quotes/double-quote-escape" {
  let csv_text =
    #|"a""b",c
    #|
  let csv = @csv.parse(csv_text)
  json_inspect(csv.to_test_json(), content={ "records": [["a\"b", "c"]] })
}

///|
test "edge/quotes/multiple-escapes" {
  let csv_text =
    #|"a""b""c",d
    #|
  let csv = @csv.parse(csv_text)
  json_inspect(csv.to_test_json(), content={ "records": [["a\"b\"c", "d"]] })
}

///|
test "edge/quotes/only-quotes" {
  let csv_text =
    #|"""",a
    #|
  let csv = @csv.parse(csv_text)
  json_inspect(csv.to_test_json(), content={ "records": [["\"", "a"]] })
}

///|
test "edge/quotes/quoted-comma" {
  let csv_text =
    #|"a,b",c
    #|
  let csv = @csv.parse(csv_text)
  json_inspect(csv.to_test_json(), content={ "records": [["a,b", "c"]] })
}

///|
test "edge/quotes/quoted-newline" {
  let csv_text =
    #|"a
    #|b",c
    #|
  let csv = @csv.parse(csv_text)
  json_inspect(csv.to_test_json(), content={ "records": [["a\nb", "c"]] })
}

///|
test "edge/quotes/quoted-crlf" {
  let csv_text = "\"a\r\nb\",c\r\n"
  let csv = @csv.parse(csv_text)
  json_inspect(csv.to_test_json(), content={ "records": [["a\r\nb", "c"]] })
}

///|
test "edge/empty/all-empty-fields" {
  let csv_text =
    #|,,
    #|
  let csv = @csv.parse(csv_text)
  json_inspect(csv.to_test_json(), content={ "records": [["", "", ""]] })
}

///|
test "edge/empty/single-empty-field" {
  let csv_text = "\n"
  let csv = @csv.parse(csv_text)
  json_inspect(csv.to_test_json(), content={ "records": [[""]] })
}

///|
test "edge/empty/quoted-empty" {
  let csv_text =
    #|"","",""
    #|
  let csv = @csv.parse(csv_text)
  json_inspect(csv.to_test_json(), content={ "records": [["", "", ""]] })
}

///|
test "edge/line-endings/lf-only" {
  let csv_text = "a,b\nc,d\n"
  let csv = @csv.parse(csv_text)
  json_inspect(csv.to_test_json(), content={
    "records": [["a", "b"], ["c", "d"]],
  })
}
