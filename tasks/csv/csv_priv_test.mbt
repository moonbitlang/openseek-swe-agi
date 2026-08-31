///|
test "edge/line-endings/crlf-only" {
  let csv_text = "a,b\r\nc,d\r\n"
  let csv = @csv.parse(csv_text)
  assert_eq(csv, Doc([["a", "b"], ["c", "d"]]))
}

///|
test "edge/line-endings/no-trailing-newline" {
  let csv_text = "a,b\nc,d"
  let csv = @csv.parse(csv_text)
  assert_eq(csv, Doc([["a", "b"], ["c", "d"]]))
}

///|
test "edge/line-endings/mixed-endings" {
  let csv_text = "a,b\nc,d\r\ne,f\n"
  let csv = @csv.parse(csv_text)
  assert_eq(csv, Doc([["a", "b"], ["c", "d"], ["e", "f"]]))
}

///|
test "edge/unicode/chinese" {
  let csv_text =
    #|中文,测试
    #|
  let csv = @csv.parse(csv_text)
  assert_eq(csv, Doc([["中文", "测试"]]))
}

///|
test "edge/unicode/japanese" {
  let csv_text =
    #|日本語,テスト
    #|
  let csv = @csv.parse(csv_text)
  assert_eq(csv, Doc([["日本語", "テスト"]]))
}

///|
test "edge/unicode/emoji" {
  let csv_text =
    #|😀,🎉
    #|
  let csv = @csv.parse(csv_text)
  assert_eq(csv, Doc([["😀", "🎉"]]))
}

///|
test "edge/unicode/mixed-scripts" {
  let csv_text =
    #|Hello 世界,АБВ
    #|
  let csv = @csv.parse(csv_text)
  assert_eq(csv, Doc([["Hello 世界", "АБВ"]]))
}

///|
test "edge/special/tab-in-field" {
  let csv_text = "a\tb,c\n"
  let csv = @csv.parse(csv_text)
  assert_eq(csv, Doc([["a\tb", "c"]]))
}

///|
test "edge/special/quoted-tab" {
  let csv_text = "\"a\tb\",c\n"
  let csv = @csv.parse(csv_text)
  assert_eq(csv, Doc([["a\tb", "c"]]))
}

///|
test "edge/special/leading-space" {
  let csv_text =
    #| a,b
    #|
  let csv = @csv.parse(csv_text)
  assert_eq(csv, Doc([[" a", "b"]]))
}

///|
test "edge/special/trailing-space" {
  let csv_text =
    #|a ,b
    #|
  let csv = @csv.parse(csv_text)
  assert_eq(csv, Doc([["a ", "b"]]))
}

///|
test "edge/multirow/many-rows" {
  let csv_text =
    #|a,b
    #|c,d
    #|e,f
    #|g,h
    #|i,j
    #|
  let csv = @csv.parse(csv_text)
  assert_eq(
    csv,
    Doc([["a", "b"], ["c", "d"], ["e", "f"], ["g", "h"], ["i", "j"]]),
  )
}

///|
test "edge/multirow/single-row" {
  let csv_text =
    #|a,b,c,d,e
    #|
  let csv = @csv.parse(csv_text)
  assert_eq(csv, Doc([["a", "b", "c", "d", "e"]]))
}

///|
test "edge/fields/single-column" {
  let csv_text =
    #|a
    #|b
    #|c
    #|
  let csv = @csv.parse(csv_text)
  assert_eq(csv, Doc([["a"], ["b"], ["c"]]))
}

///|
test "edge/fields/many-columns" {
  let csv_text =
    #|a,b,c,d,e,f,g,h,i,j
    #|
  let csv = @csv.parse(csv_text)
  assert_eq(csv, Doc([["a", "b", "c", "d", "e", "f", "g", "h", "i", "j"]]))
}

///|
test "edge/real-world/address-data" {
  let csv_text =
    #|name,address,city
    #|"John Doe","123 Main St, Apt 4",Springfield
    #|
  let csv = @csv.parse(csv_text)
  assert_eq(
    csv,
    Doc([
      ["name", "address", "city"],
      ["John Doe", "123 Main St, Apt 4", "Springfield"],
    ]),
  )
}

///|
test "edge/real-world/description-with-newlines" {
  let csv_text =
    #|id,description
    #|1,"Line 1
    #|Line 2
    #|Line 3"
    #|
  let csv = @csv.parse(csv_text)
  assert_eq(csv, Doc([["id", "description"], ["1", "Line 1\nLine 2\nLine 3"]]))
}

///|
test "edge/real-world/numeric-data" {
  let csv_text =
    #|id,price,quantity
    #|1,19.99,100
    #|2,0.50,1000
    #|
  let csv = @csv.parse(csv_text)
  assert_eq(
    csv,
    Doc([
      ["id", "price", "quantity"],
      ["1", "19.99", "100"],
      ["2", "0.50", "1000"],
    ]),
  )
}

///|
test "edge/real-world/quoted-numbers" {
  let csv_text =
    #|"1","2","3"
    #|"4","5","6"
    #|
  let csv = @csv.parse(csv_text)
  assert_eq(csv, Doc([["1", "2", "3"], ["4", "5", "6"]]))
}

///|
test "edge/boundary/long-field" {
  let long_value = "a".repeat(1000)
  let csv_text = long_value + ",b\n"
  // Just verify it parses and has correct structure
  match @csv.parse(csv_text) {
    Doc([[first, second]]) => {
      assert_eq(first.length(), 1000)
      assert_eq(second, "b")
    }
    _ => fail("Unexpected row structure")
  }
}

///|
test "edge/boundary/long-quoted-field" {
  let long_value = "a".repeat(1000)
  let csv_text = "\"" + long_value + "\",b\n"
  match @csv.parse(csv_text) {
    Doc([[first, second]]) => {
      assert_eq(first.length(), 1000)
      assert_eq(second, "b")
    }
    _ => fail("Unexpected row structure")
  }
}

///|
test "invalid/unclosed-quote" {
  let csv_text =
    #|"unclosed
    #|
  @test.assert_raise(() => @csv.parse(csv_text))
}

///|
test "valid/simple-single-row" {
  let csv_text =
    #|a,b,c
    #|
  let csv = @csv.parse(csv_text)
  assert_eq(csv, Doc([["a", "b", "c"]]))
}

///|
test "valid/simple-multiple-rows" {
  let csv_text =
    #|name,age,city
    #|Alice,30,NYC
    #|Bob,25,LA
    #|
  let csv = @csv.parse(csv_text)
  assert_eq(
    csv,
    Doc([["name", "age", "city"], ["Alice", "30", "NYC"], ["Bob", "25", "LA"]]),
  )
}

///|
test "valid/quoted-fields" {
  let csv_text =
    #|a,"b,c",d
    #|1,"2,3",4
    #|
  let csv = @csv.parse(csv_text)
  assert_eq(csv, Doc([["a", "b,c", "d"], ["1", "2,3", "4"]]))
}

///|
test "valid/escaped-quotes" {
  let csv_text =
    #|"a""b","c""d""e"
    #|
  let csv = @csv.parse(csv_text)
  assert_eq(csv, Doc([["a\"b", "c\"d\"e"]]))
}

///|
test "invalid/quote-in-unquoted-field" {
  let csv_text =
    #|a,b"c,d
    #|
  @test.assert_raise(() => @csv.parse(csv_text))
}

///|
test "invalid/text-after-quoted-field" {
  let csv_text =
    #|"quoted"text,b
    #|
  @test.assert_raise(() => @csv.parse(csv_text))
}

///|
test "invalid/inconsistent-field-count" {
  let csv_text =
    #|a,b,c
    #|1,2
    #|
  @test.assert_raise(() => @csv.parse(csv_text))
}

///|
test "invalid/mid/unclosed-quote-multiline" {
  let csv_text =
    #|a,"b
    #|c
    #|d,e
    #|
  @test.assert_raise(() => @csv.parse(csv_text))
}

///|
test "invalid/mid/quote-in-middle-of-unquoted" {
  let csv_text =
    #|a,b"c"d,e
    #|
  @test.assert_raise(() => @csv.parse(csv_text))
}

///|
test "invalid/mid/mismatched-field-counts-complex" {
  let csv_text =
    #|a,b,c,d,e
    #|1,2,3
    #|4,5,6,7,8
    #|9,10
    #|
  @test.assert_raise(() => @csv.parse(csv_text))
}

///|
test "invalid/mid/improper-quote-escape" {
  let csv_text =
    #|a,"b\"c",d
    #|
  @test.assert_raise(() => @csv.parse(csv_text))
}

///|
test "invalid/hard/quote-after-data" {
  let csv_text =
    #|a,b,c
    #|1,2"3,4
    #|
  @test.assert_raise(() => @csv.parse(csv_text))
}

///|
test "invalid/hard/unescaped-quote-in-quoted-field" {
  let csv_text =
    #|a,b,c
    #|1,"2"3",4
    #|
  @test.assert_raise(() => @csv.parse(csv_text))
}

///|
test "invalid/hard/unclosed-quote-eof" {
  let csv_text =
    #|a,b,c
    #|1,"2
  @test.assert_raise(() => @csv.parse(csv_text))
}

///|
test "invalid/hard/text-between-quoted-fields" {
  let csv_text =
    #|"a"x"b","c"
    #|
  @test.assert_raise(() => @csv.parse(csv_text))
}

///|
test "invalid/hard/odd-number-of-quotes-in-field" {
  let csv_text =
    #|a,b,c
    #|1,"""2,3
    #|
  @test.assert_raise(() => @csv.parse(csv_text))
}

///|
test "invalid/hard/multiline-unquoted-field" {
  let csv_text =
    #|a,b,c
    #|1,2
    #|3,4
    #|
  @test.assert_raise(() => @csv.parse(csv_text))
}

///|
test "invalid/quote/single-quote-start" {
  // Starting with a quote but not properly quoted field
  let csv_text =
    #|"a,b
    #|
  @test.assert_raise(() => @csv.parse(csv_text))
}

///|
test "invalid/quote/space-before-quote" {
  // Space before opening quote in field that looks quoted
  // " "hello"  - this might be ambiguous but typically invalid
  let csv_text =
    #|a, "b",c
    #|
  @test.assert_raise(() => @csv.parse(csv_text))
}

///|
test "invalid/structure/extra-fields-mid-file" {
  // First row has 3 fields, second row has 5 fields
  let csv_text =
    #|a,b,c
    #|1,2,3,4,5
    #|
  @test.assert_raise(() => @csv.parse(csv_text))
}

///|
test "invalid/quote/lone-quote-field" {
  // A single quote character as a field
  let csv_text =
    #|a,",c
    #|
  @test.assert_raise(() => @csv.parse(csv_text))
}

///|
test "invalid/quote/triple-quote-odd" {
  // Triple quote without proper escaping
  let csv_text =
    #|a,""",c
    #|
  @test.assert_raise(() => @csv.parse(csv_text))
}

///|
test "valid/empty-fields" {
  let csv_text =
    #|a,,c
    #|,b,
    #|
  let csv = @csv.parse(csv_text)
  assert_eq(csv, Doc([["a", "", "c"], ["", "b", ""]]))
}

///|
test "valid/newline-in-quoted-field" {
  let csv_text =
    #|a,"b
    #|c",d
    #|
  let csv = @csv.parse(csv_text)
  assert_eq(csv, Doc([["a", "b\nc", "d"]]))
}

///|
test "valid/crlf-line-endings" {
  let csv_text = "a,b,c\r\n1,2,3\r\n"
  let csv = @csv.parse(csv_text)
  assert_eq(csv, Doc([["a", "b", "c"], ["1", "2", "3"]]))
}

///|
test "valid/empty-csv" {
  let csv_text = ""
  let csv = @csv.parse(csv_text)
  assert_eq(csv, Doc([]))
}

///|
test "valid/single-field" {
  let csv_text =
    #|hello
    #|
  let csv = @csv.parse(csv_text)
  assert_eq(csv, Doc([["hello"]]))
}

///|
test "edge/whitespace-preservation" {
  let csv_text =
    #| a , b , c 
    #|
  let csv = @csv.parse(csv_text)
  assert_eq(csv, Doc([[" a ", " b ", " c "]]))
}

///|
test "edge/quoted-empty-field" {
  let csv_text =
    #|a,"",c
    #|
  let csv = @csv.parse(csv_text)
  assert_eq(csv, Doc([["a", "", "c"]]))
}

///|
test "edge/only-commas" {
  let csv_text =
    #|,,,
    #|
  let csv = @csv.parse(csv_text)
  assert_eq(csv, Doc([["", "", "", ""]]))
}

///|
test "edge/unicode-content" {
  let csv_text =
    #|名前,年齢
    #|太郎,30
    #|花子,25
    #|
  let csv = @csv.parse(csv_text)
  assert_eq(
    csv,
    Doc([["名前", "年齢"], ["太郎", "30"], ["花子", "25"]]),
  )
}

///|
test "valid/cr-line-endings" {
  let csv_text = "a,b,c\r1,2,3\r"
  let csv = @csv.parse(csv_text)
  assert_eq(csv, Doc([["a", "b", "c"], ["1", "2", "3"]]))
}

///|
test "valid/quoted-eof-no-newline" {
  let csv_text = "\"a\",\"b\""
  let csv = @csv.parse(csv_text)
  assert_eq(csv, Doc([["a", "b"]]))
}

///|
test "mid/multi-line-multiple-fields" {
  let csv_text =
    #|name,address,notes
    #|John,"123 Main St
    #|Apt 4B
    #|New York, NY","Important
    #|customer"
    #|Jane,"456 Oak Ave
    #|Boston, MA",Regular
    #|
  let csv = @csv.parse(csv_text)
  assert_eq(
    csv,
    Doc([
      ["name", "address", "notes"],
      ["John", "123 Main St\nApt 4B\nNew York, NY", "Important\ncustomer"],
      ["Jane", "456 Oak Ave\nBoston, MA", "Regular"],
    ]),
  )
}

///|
test "mid/complex-quote-escaping" {
  let csv_text =
    #|field1,field2,field3
    #|"He said ""Hello""","She replied ""Hi there""","They said ""Goodbye"""
    #|"""quoted""","middle""quote""here","""start and end"""
    #|
  let csv = @csv.parse(csv_text)
  assert_eq(
    csv,
    Doc([
      ["field1", "field2", "field3"],
      ["He said \"Hello\"", "She replied \"Hi there\"", "They said \"Goodbye\""],
      ["\"quoted\"", "middle\"quote\"here", "\"start and end\""],
    ]),
  )
}

///|
test "mid/mixed-quoted-unquoted" {
  let csv_text =
    #|id,"name",age,"email",city
    #|1,"Alice",30,alice@example.com,"New York"
    #|2,Bob,"25","bob@example.com",Boston
    #|3,"Charlie","35","charlie@example.com","San Francisco"
    #|
  let csv = @csv.parse(csv_text)
  assert_eq(
    csv,
    Doc([
      ["id", "name", "age", "email", "city"],
      ["1", "Alice", "30", "alice@example.com", "New York"],
      ["2", "Bob", "25", "bob@example.com", "Boston"],
      ["3", "Charlie", "35", "charlie@example.com", "San Francisco"],
    ]),
  )
}

///|
test "mid/many-columns" {
  let csv_text =
    #|col1,col2,col3,col4,col5,col6,col7,col8,col9,col10
    #|a,b,c,d,e,f,g,h,i,j
    #|1,2,3,4,5,6,7,8,9,10
    #|
  let csv = @csv.parse(csv_text)
  assert_eq(
    csv,
    Doc([
      [
        "col1", "col2", "col3", "col4", "col5", "col6", "col7", "col8", "col9", "col10",
      ],
      ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j"],
      ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"],
    ]),
  )
}

///|
test "mid/special-characters" {
  let csv_text =
    #|symbols,math,currency
    #|"@#$%","<>=≠","$€¥£"
    #|"&*()","±∞÷","¢₹₽₩"
    #|
  let csv = @csv.parse(csv_text)
  assert_eq(
    csv,
    Doc([
      ["symbols", "math", "currency"],
      ["@#$%", "<>=≠", "$€¥£"],
      ["&*()", "±∞÷", "¢₹₽₩"],
    ]),
  )
}

///|
test "mid/tab-characters" {
  let csv_text = "a\tb\tc\n1\t2\t3\n"
  let csv = @csv.parse(csv_text)
  assert_eq(csv, Doc([["a\tb\tc"], ["1\t2\t3"]]))
}

///|
test "mid/quoted-newlines-only" {
  let csv_text =
    #|a,"b
    #|
    #|c",d
    #|
  let csv = @csv.parse(csv_text)
  assert_eq(csv, Doc([["a", "b\n\nc", "d"]]))
}

///|
test "invalid/mid/empty-lines-between-records" {
  let csv_text =
    #|a,b,c
    #|1,2,3
    #|
    #|4,5,6
    #|
  @test.assert_raise(() => @csv.parse(csv_text))
}

///|
test "mid/trailing-comma" {
  let csv_text =
    #|a,b,c,
    #|1,2,3,
    #|
  let csv = @csv.parse(csv_text)
  assert_eq(csv, Doc([["a", "b", "c", ""], ["1", "2", "3", ""]]))
}

///|
test "invalid/mid/blank-line-first" {
  let csv_text = "\na,b,c\n"
  @test.assert_raise(() => @csv.parse(csv_text))
}

///|
test "mid/semicolon-separator" {
  let csv_text = "a;b;c\n"
  let csv = @csv.parse(csv_text)
  // Semicolons should be part of the field since comma is the separator
  assert_eq(csv, Doc([["a;b;c"]]))
}

///|
test "hard/deeply-nested-quotes" {
  let csv_text =
    #|field1,field2
    #|"He said ""She said """"Hello"""" to me""","A ""B ""C"" D"" E"
    #|
  let csv = @csv.parse(csv_text)
  assert_eq(
    csv,
    Doc([
      ["field1", "field2"],
      ["He said \"She said \"\"Hello\"\" to me\"", "A \"B \"C\" D\" E"],
    ]),
  )
}

///|
test "hard/many-empty-fields" {
  let csv_text =
    #|,,,,,,,,,
    #|,,,,,,,,,
    #|,,,,,,,,,
    #|
  let csv = @csv.parse(csv_text)
  assert_eq(
    csv,
    Doc([
      ["", "", "", "", "", "", "", "", "", ""],
      ["", "", "", "", "", "", "", "", "", ""],
      ["", "", "", "", "", "", "", "", "", ""],
    ]),
  )
}

///|
test "hard/alternating-quoted-unquoted" {
  let csv_text =
    #|"a",b,"c",d,"e",f,"g",h,"i",j
    #|1,"2",3,"4",5,"6",7,"8",9,"10"
    #|
  let csv = @csv.parse(csv_text)
  assert_eq(
    csv,
    Doc([
      ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j"],
      ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"],
    ]),
  )
}

///|
test "hard/complex-multiline-records" {
  let csv_text =
    #|id,description,metadata
    #|1,"Line 1
    #|Line 2
    #|Line 3","Meta 1
    #|Meta 2"
    #|2,"Single line","Multi
    #|line
    #|meta"
    #|3,"A ""quoted"" word
    #|on multiple
    #|lines","Simple"
    #|
  let csv = @csv.parse(csv_text)
  assert_eq(
    csv,
    Doc([
      ["id", "description", "metadata"],
      ["1", "Line 1\nLine 2\nLine 3", "Meta 1\nMeta 2"],
      ["2", "Single line", "Multi\nline\nmeta"],
      ["3", "A \"quoted\" word\non multiple\nlines", "Simple"],
    ]),
  )
}

///|
test "hard/consecutive-quotes-pattern" {
  let csv_text =
    #|a,b,c
    #|"""",""""""," """""
    #|
  let csv = @csv.parse(csv_text)
  assert_eq(csv, Doc([["a", "b", "c"], ["\"", "\"\"", " \"\""]]))
}

///|
test "hard/mixed-line-endings" {
  let csv_text = "a,b,c\r\n1,2,3\n4,5,6\r\n7,8,9\n"
  let csv = @csv.parse(csv_text)
  assert_eq(
    csv,
    Doc([["a", "b", "c"], ["1", "2", "3"], ["4", "5", "6"], ["7", "8", "9"]]),
  )
}

///|
test "hard/quoted-field-with-all-special-chars" {
  let csv_text =
    #|field
    #|"comma,quote""newline
    #|tab	space end"
    #|
  let csv = @csv.parse(csv_text)
  assert_eq(csv, Doc([["field"], ["comma,quote\"newline\ntab\tspace end"]]))
}

///|
test "hard/rfc4180-example" {
  let csv_text =
    #|Year,Make,Model,Description,Price
    #|1997,Ford,E350,"ac, abs, moon",3000.00
    #|1999,Chevy,"Venture ""Extended Edition""","",4900.00
    #|1999,Chevy,"Venture ""Extended Edition, Very Large""",,5000.00
    #|1996,Jeep,Grand Cherokee,"MUST SELL!
    #|air, moon roof, loaded",4799.00
    #|
  let csv = @csv.parse(csv_text)
  assert_eq(
    csv,
    Doc([
      ["Year", "Make", "Model", "Description", "Price"],
      ["1997", "Ford", "E350", "ac, abs, moon", "3000.00"],
      ["1999", "Chevy", "Venture \"Extended Edition\"", "", "4900.00"],
      [
        "1999", "Chevy", "Venture \"Extended Edition, Very Large\"", "", "5000.00",
      ],
      [
        "1996", "Jeep", "Grand Cherokee", "MUST SELL!\nair, moon roof, loaded", "4799.00",
      ],
    ]),
  )
}

///|
test "hard/only-newlines-in-quoted-field" {
  let csv_text =
    #|a,b,c
    #|1,"
    #|
    #|
    #|",3
    #|
  let csv = @csv.parse(csv_text)
  assert_eq(csv, Doc([["a", "b", "c"], ["1", "\n\n\n", "3"]]))
}

///|
test "hard/unicode-emoji-and-symbols" {
  let csv_text =
    #|emoji,symbols,text
    #|"😀😃😄","→←↑↓","Hello 世界"
    #|"🎉🎊🎈","★☆✓✗","Привет мир"
    #|"❤️💙💚","♠♣♥♦","مرحبا العالم"
    #|
  let csv = @csv.parse(csv_text)
  assert_eq(
    csv,
    Doc([
      ["emoji", "symbols", "text"],
      ["😀😃😄", "→←↑↓", "Hello 世界"],
      ["🎉🎊🎈", "★☆✓✗", "Привет мир"],
      ["❤️💙💚", "♠♣♥♦", "مرحبا العالم"],
    ]),
  )
}

///|
test "hard/single-column-many-rows" {
  let csv_text =
    #|value
    #|1
    #|2
    #|3
    #|4
    #|5
    #|6
    #|7
    #|8
    #|9
    #|10
    #|
  let csv = @csv.parse(csv_text)
  assert_eq(
    csv,
    Doc([
      ["value"],
      ["1"],
      ["2"],
      ["3"],
      ["4"],
      ["5"],
      ["6"],
      ["7"],
      ["8"],
      ["9"],
      ["10"],
    ]),
  )
}

///|
test "hard/quoted-commas-everywhere" {
  let csv_text =
    #|"a,b","c,d,e","f,g,h,i"
    #|"1,2","3,4,5","6,7,8,9"
    #|
  let csv = @csv.parse(csv_text)
  assert_eq(
    csv,
    Doc([["a,b", "c,d,e", "f,g,h,i"], ["1,2", "3,4,5", "6,7,8,9"]]),
  )
}

///|
test "edge/implicit-close-quote" {
  let csv_text = "a,b,\"c\"\"\""
  let csv = @csv.parse(csv_text)
  assert_eq(csv, Doc([["a", "b", "c\""]]))
}

///|
test "valid/unicode/rtl-text" {
  // Right-to-left text (Arabic, Hebrew)
  let csv_text =
    #|language,greeting,direction
    #|Arabic,"مرحبا بالعالم",RTL
    #|Hebrew,"שלום עולם",RTL
    #|
  let csv = @csv.parse(csv_text)
  assert_eq(
    csv,
    Doc([
      ["language", "greeting", "direction"],
      ["Arabic", "مرحبا بالعالم", "RTL"],
      ["Hebrew", "שלום עולם", "RTL"],
    ]),
  )
}

///|
test "valid/unicode/zero-width-characters" {
  // Zero-width characters (ZWJ, ZWNJ)
  let csv_text = "a,b\u200Bc,d\n" // Zero-width space
  let csv = @csv.parse(csv_text)
  assert_eq(csv, Doc([["a", "b\u200Bc", "d"]]))
}

///|
test "valid/unicode/combining-characters" {
  // Combining diacritical marks
  let csv_text =
    #|name,normalized
    #|"café","café"
    #|"naïve","naïve"
    #|
  let csv = @csv.parse(csv_text)
  assert_eq(
    csv,
    Doc([
      ["name", "normalized"],
      ["café", "cafe\u0301"],
      ["naïve", "nai\u0308ve"],
    ]),
  )
}

///|
test "valid/edge/bom-at-start" {
  // UTF-8 BOM at the start of file
  let csv_text = "\u{FEFF}a,b,c\n1,2,3\n"
  // BOM may be included in first field or stripped
  // depending on implementation
  // Just verify it parses successfully
  let records = @csv.parse(csv_text)
  assert_true(records.length() > 0)
}

///|
test "valid/edge/very-long-field" {
  // Field with many characters
  let long_value = "x".repeat(1000)
  let csv_text = "short,\"\{long_value}\",short\n"
  assert_eq(@csv.parse(csv_text), Doc([["short", long_value, "short"]]))
}

///|
test "valid/edge/many-columns" {
  // Record with many columns
  let csv_text = "c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,c15,c16,c17,c18,c19,c20\nv1,v2,v3,v4,v5,v6,v7,v8,v9,v10,v11,v12,v13,v14,v15,v16,v17,v18,v19,v20\n"
  let csv = @csv.parse(csv_text)
  assert_eq(
    csv,
    Doc([
      [
        "c1", "c2", "c3", "c4", "c5", "c6", "c7", "c8", "c9", "c10", "c11", "c12",
        "c13", "c14", "c15", "c16", "c17", "c18", "c19", "c20",
      ],
      [
        "v1", "v2", "v3", "v4", "v5", "v6", "v7", "v8", "v9", "v10", "v11", "v12",
        "v13", "v14", "v15", "v16", "v17", "v18", "v19", "v20",
      ],
    ]),
  )
}

///|
test "valid/edge/crlf-in-quoted-field" {
  // CRLF inside quoted field
  let csv_text = "a,\"b\r\nc\",d\n"
  let csv = @csv.parse(csv_text)
  assert_eq(csv, Doc([["a", "b\r\nc", "d"]]))
}

///|
test "valid/edge/tabs-in-field" {
  // Tab characters in fields (tabs are not delimiters in CSV)
  let csv_text =
    #|a,b	with	tabs,c
    #|1,2	also	tabs,3
    #|
  let csv = @csv.parse(csv_text)
  assert_eq(
    csv,
    Doc([["a", "b\twith\ttabs", "c"], ["1", "2\talso\ttabs", "3"]]),
  )
}

///|
test "valid/edge/numeric-data" {
  // Various numeric formats (all treated as strings in CSV)
  let csv_text =
    #|int,float,scientific,negative
    #|123,3.14,1.23e10,-456
    #|0,0.0,1e-5,-0.001
    #|
  let csv = @csv.parse(csv_text)
  assert_eq(
    csv,
    Doc([
      ["int", "float", "scientific", "negative"],
      ["123", "3.14", "1.23e10", "-456"],
      ["0", "0.0", "1e-5", "-0.001"],
    ]),
  )
}
