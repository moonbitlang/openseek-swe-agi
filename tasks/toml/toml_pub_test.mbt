///|
test "invalid/array/double-comma-01" {
  let toml_text =
    #|double-comma-01 = [1,,2]
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/array/double-comma-02" {
  let toml_text =
    #|double-comma-02 = [1,2,,]
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/array/missing-separator-01" {
  let toml_text =
    #|arrr = [true false]
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/array/missing-separator-02" {
  let toml_text =
    #|wrong = [ 1 2 3 ]
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/array/no-close-01" {
  let toml_text =
    #|no-close-01 = [ 1, 2, 3
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/array/no-close-02" {
  let toml_text =
    #|no-close-02 = [1,
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/array/no-close-03" {
  let toml_text =
    #|no-close-03 = [42 #]
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/array/no-close-04" {
  let toml_text =
    #|no-close-04 = [{ key = 42
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/array/no-close-05" {
  let toml_text =
    #|no-close-05 = [{ key = 42}
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/array/no-close-06" {
  let toml_text =
    #|no-close-06 = [{ key = 42 #}]
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/array/no-close-07" {
  let toml_text =
    #|no-close-07 = [{ key = 42} #]
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/array/no-close-08" {
  let toml_text =
    #|no-close-08 = [
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/array/no-comma-01" {
  let toml_text =
    #|no-comma-01 = [true false]
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/array/no-comma-02" {
  let toml_text =
    #|no-comma-02 = [ 1 2 3 ]
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/array/no-comma-03" {
  let toml_text =
    #|no-comma-03 = [ 1 #,]
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/array/only-comma-01" {
  let toml_text =
    #|only-comma-01 = [,]
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/array/only-comma-02" {
  let toml_text =
    #|only-comma-02 = [,,]
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/bool/almost-false-with-extra" {
  let toml_text =
    #|almost-false-with-extra = falsify
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/bool/almost-false" {
  let toml_text =
    #|almost-false            = fals
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/bool/almost-true-with-extra" {
  let toml_text =
    #|almost-true-with-extra  = truthy
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/bool/almost-true" {
  let toml_text =
    #|almost-true             = tru
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/bool/capitalized-false" {
  let toml_text =
    #|capitalized-false        = False
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/bool/capitalized-true" {
  let toml_text =
    #|capitalized-true         = True
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/bool/just-f" {
  let toml_text =
    #|just-f                  = f
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/bool/just-t" {
  let toml_text =
    #|just-t                  = t
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/bool/mixed-case-false" {
  let toml_text =
    #|mixed-case-false        = falsE
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/bool/mixed-case-true" {
  let toml_text =
    #|mixed-case-true         = trUe
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/bool/mixed-case" {
  let toml_text =
    #|mixed-case              = valid   = False
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/bool/starting-same-false" {
  let toml_text =
    #|starting-same-false     = falsey
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/bool/starting-same-true" {
  let toml_text =
    #|starting-same-true      = truer
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/bool/wrong-case-false" {
  let toml_text =
    #|wrong-case-false        = FALSE
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/bool/wrong-case-true" {
  let toml_text =
    #|wrong-case-true         = TRUE
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/control/bare-cr" {
  let toml_text = "# The following line contains a single carriage return control character\r\n\r"
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/control/bare-formfeed" {
  let toml_text = "bare-formfeed     = \u{0C}\n"
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/control/bare-null" {
  let toml_text = "bare-null         = \"some value\" \u{00}\n"
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/control/bare-vertical-tab" {
  let toml_text = "bare-vertical-tab = \u{0B}\n"
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/control/comment-cr" {
  let toml_text = "comment-cr   = \"Carriage return in comment\" # \ra=1\n"
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/control/comment-del" {
  let toml_text = "comment-del  = \"0x7f\"   # \u{7F}\n"
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/control/comment-ff" {
  let toml_text = "comment-ff   = \"0x7f\"   # \u{0C}\n"
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/control/comment-lf" {
  let toml_text = "comment-lf   = \"ctrl-P\" # \u{10}\n"
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/control/comment-null" {
  let toml_text = "comment-null = \"null\"   # \u{00}\n"
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/control/comment-us" {
  let toml_text = "comment-us   = \"ctrl-_\" # \u{1F}\n"
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/control/only-ff" {
  let toml_text = "\u{0C}"
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/control/only-null" {
  let toml_text = "\u{00}"
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/control/only-vt" {
  let toml_text = "\u{0B}"
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/control/string-bs" {
  let toml_text = "string-bs   = \"backspace\u{08}\"\n"
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/control/string-cr" {
  let toml_text = "string-cr   = \"null\r\"\n"
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "valid/array/bool" {
  let toml_text =
    #|a = [true, false]
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, { "a": Array([Bool(true), Bool(false)]) })
}

///|
test "valid/array/empty" {
  let toml_text =
    #|thevoid = [[[[[]]]]]
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, { "thevoid": Array([Array([Array([Array([Array([])])])])]) })
}

///|
test "valid/array/nospaces" {
  let toml_text =
    #|ints = [1,2,3]
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, { "ints": Array([Integer(1), Integer(2), Integer(3)]) })
}

///|
test "valid/array/string-quote-comma-01" {
  let toml_text =
    #|title = [
    #|"Client: \"XXXX\", Job: XXXX",
    #|"Code: XXXX"
    #|]
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "title": Array([String("Client: \"XXXX\", Job: XXXX"), String("Code: XXXX")]),
  })
}

///|
test "valid/array/string-quote-comma-02" {
  let toml_text =
    #|title = [ " \", ",]
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, { "title": Array([String(" \", ")]) })
}

///|
test "valid/array/string-with-comma-01" {
  let toml_text =
    #|title = [
    #|"Client: XXXX, Job: XXXX",
    #|"Code: XXXX"
    #|]
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "title": Array([String("Client: XXXX, Job: XXXX"), String("Code: XXXX")]),
  })
}

///|
test "valid/array/string-with-comma-02" {
  let toml_text =
    #|title = [
    #|"""Client: XXXX,
    #|Job: XXXX""",
    #|"Code: XXXX"
    #|]
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "title": Array([String("Client: XXXX,\nJob: XXXX"), String("Code: XXXX")]),
  })
}

///|
test "valid/array/strings" {
  let toml_text =
    #|string_array = [ "all", 'strings', """are the same""", '''type''']
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "string_array": Array([
      String("all"),
      String("strings"),
      String("are the same"),
      String("type"),
    ]),
  })
}

///|
test "valid/bool/bool" {
  let toml_text =
    #|t = true
    #|f = false
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, { "f": Bool(false), "t": Bool(true) })
}

///|
test "valid/comment/after-literal-no-ws" {
  let toml_text =
    #|inf=inf#infinity
    #|nan=nan#not a number
    #|true=true#true
    #|false=false#false
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "false": Bool(false),
    "inf": Float(@double.infinity),
    "nan": Float(@double.not_a_number),
    "true": Bool(true),
  })
}

///|
test "valid/comment/at-eof2" {
  let toml_text =
    #|# This is a full-line comment
    #|key = "value" # This is a comment at the end of a line
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, { "key": String("value") })
}

///|
test "valid/comment/at-eof" {
  let toml_text =
    #|# This is a full-line comment
    #|key = "value" # This is a comment at the end of a line
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, { "key": String("value") })
}

///|
test "valid/comment/everywhere" {
  let toml_text =
    #|# Top comment.
    #|  # Top comment.
    #|# Top comment.
    #|
    #|# [no-extraneous-groups-please]
    #|
    #|[group] # Comment
    #|answer = 42 # Comment
    #|# no-extraneous-keys-please = 999
    #|# Inbetween comment.
    #|more = [ # Comment
    #|  # What about multiple # comments?
    #|  # Can you handle it?
    #|  #
    #|          # Evil.
    #|# Evil.
    #|  42, 42, # Comments within arrays are fun.
    #|  # What about multiple # comments?
    #|  # Can you handle it?
    #|  #
    #|          # Evil.
    #|# Evil.
    #|# ] Did I fool you?
    #|] # Hopefully not.
    #|
    #|# Make sure the space between the datetime and "#" isn't lexed.
    #|dt = 1979-05-27T07:32:12-07:00  # c
    #|d = 1979-05-27 # Comment
    #|
    #|[[aot]] # Comment
    #|k = 98 # Comment
    #|[[aot]]# Comment
    #|k = 99# Comment
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "aot": Array([Table({ "k": Integer(98) }), Table({ "k": Integer(99) })]),
    "group": Table({
      "answer": Integer(42),
      "d": LocalDate({ year: 1979, month: 5, day: 27, }),
      "dt": Datetime(
        { year: 1979, month: 5, day: 27, },
        { hour: 7, minute: 32, second: 12, nanosecond: 0, },
        offset=-420,
      ),
      "more": Array([Integer(42), Integer(42)]),
    }),
  })
}

///|
test "valid/comment/noeol" {
  let toml_text =
    #|# single comment without any eol characters
  let toml = @toml.parse(toml_text)
  assert_eq(toml, Map([]))
}

///|
test "valid/comment/nonascii" {
  let toml_text =
    #|# ~  ÿ ퟿  ￿ 𐀀 􏿿
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, Map([]))
}

///|
test "valid/comment/tricky" {
  let toml_text =
    #|[section]#attached comment
    #|#[notsection]
    #|one = "11"#cmt
    #|two = "22#"
    #|three = '#'
    #|
    #|four = """# no comment
    #|# nor this
    #|#also not comment"""#is_comment
    #|
    #|five = 5.5#66
    #|six = 6#7
    #|8 = "eight"
    #|#nine = 99
    #|ten = 10e2#1
    #|eleven = 1.11e1#23
    #|
    #|["hash#tag"]
    #|"#!" = "hash bang"
    #|arr3 = [ "#", '#', """###""" ]
    #|arr4 = [ 1,# 9, 9,
    #|2#,9
    #|,#9
    #|3#]
    #|,4]
    #|arr5 = [[[[#["#"],
    #|["#"]]]]#]
    #|]
    #|tbl1 = { "#" = '}#'}#}}
    #|
    #|
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "hash#tag": Table({
      "#!": String("hash bang"),
      "arr3": Array([String("#"), String("#"), String("###")]),
      "arr4": Array([Integer(1), Integer(2), Integer(3), Integer(4)]),
      "arr5": Array([Array([Array([Array([Array([String("#")])])])])]),
      "tbl1": Table({ "#": String("}#") }),
    }),
    "section": Table({
      "8": String("eight"),
      "eleven": Float(11.1),
      "five": Float(5.5),
      "four": String("# no comment\n# nor this\n#also not comment"),
      "one": String("11"),
      "six": Integer(6),
      "ten": Float(1000.0),
      "three": String("#"),
      "two": String("22#"),
    }),
  })
}

///|
test "valid/empty-crlf" {
  let toml_text = "\r\n"
  let toml = @toml.parse(toml_text)
  assert_eq(toml, Map([]))
}

///|
test "valid/empty-lf" {
  let toml_text =
    #|
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, Map([]))
}

///|
test "valid/empty-nothing" {
  let toml_text =
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, Map([]))
}

///|
test "valid/empty-space" {
  let toml_text =
    #| 
  let toml = @toml.parse(toml_text)
  assert_eq(toml, Map([]))
}

///|
test "valid/empty-tab" {
  let toml_text =
    #|	
  let toml = @toml.parse(toml_text)
  assert_eq(toml, Map([]))
}

///|
test "valid/example" {
  let toml_text =
    #|best-day-ever = 1987-07-05T17:45:00Z
    #|
    #|[numtheory]
    #|boring = false
    #|perfection = [6, 28, 496]
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "best-day-ever": Datetime(
      { year: 1987, month: 7, day: 5, },
      { hour: 17, minute: 45, second: 0, nanosecond: 0, },
      offset=0,
    ),
    "numtheory": Table({
      "boring": Bool(false),
      "perfection": Array([Integer(6), Integer(28), Integer(496)]),
    }),
  })
}

///|
test "valid/float/exponent" {
  let toml_text =
    #|lower = 3e2
    #|upper = 3E2
    #|neg = 3e-2
    #|pos = 3E+2
    #|zero = 3e0
    #|pointlower = 3.1e2
    #|pointupper = 3.1E2
    #|minustenth = -1E-1
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "lower": Float(300.0),
    "minustenth": Float(-0.1),
    "neg": Float(0.03),
    "pointlower": Float(310.0),
    "pointupper": Float(310.0),
    "pos": Float(300.0),
    "upper": Float(300.0),
    "zero": Float(3.0),
  })
}

///|
test "valid/float/float" {
  let toml_text =
    #|pi = 3.14
    #|pospi = +3.14
    #|negpi = -3.14
    #|zero-intpart = 0.123
    #|leading-zero-fractional = 0.0123
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "leading-zero-fractional": Float(0.0123),
    "negpi": Float(-3.14),
    "pi": Float(3.14),
    "pospi": Float(3.14),
    "zero-intpart": Float(0.123),
  })
}

///|
test "valid/float/zero" {
  let toml_text =
    #|zero = 0.0
    #|signed-pos = +0.0
    #|signed-neg = -0.0
    #|exponent = 0e0
    #|exponent-two-0 = 0e00
    #|exponent-signed-pos = +0e0
    #|exponent-signed-neg = -0e0
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "exponent": Float(0.0),
    "exponent-signed-neg": Float(-0.0),
    "exponent-signed-pos": Float(0.0),
    "exponent-two-0": Float(0.0),
    "signed-neg": Float(-0.0),
    "signed-pos": Float(0.0),
    "zero": Float(0.0),
  })
}

///|
test "valid/integer/float64-max" {
  let toml_text =
    #|# Maximum and minimum safe float64 natural numbers. Mainly here for
    #|# -int-as-float.
    #|max_int =  9_007_199_254_740_991
    #|min_int = -9_007_199_254_740_991
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "max_int": Integer(9007199254740991),
    "min_int": Integer(-9007199254740991),
  })
}

///|
test "invalid/integer/int64-overflow-01" {
  let toml_text =
    #|# 2^63, one past the signed 64-bit maximum
    #|v = 9223372036854775808
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "valid/datetime/nanoseconds" {
  let toml_text =
    #|# Full nanosecond precision must survive parsing.
    #|odt = 1979-05-27T07:32:00.123456789Z
    #|ldt = 1979-05-27T07:32:00.999999999
    #|lt = 07:32:00.000000001
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "odt": Datetime(
      { year: 1979, month: 5, day: 27, },
      { hour: 7, minute: 32, second: 0, nanosecond: 123456789, },
      offset=0,
    ),
    "ldt": LocalDatetime({ year: 1979, month: 5, day: 27, }, {
      hour: 7,
      minute: 32,
      second: 0,
      nanosecond: 999999999,
    }),
    "lt": LocalTime({ hour: 7, minute: 32, second: 0, nanosecond: 1, }),
  })
}

///|
test "valid/datetime/leap-second" {
  let toml_text =
    #|# RFC 3339: time-second = 2DIGIT ; 00-58, 00-59, 00-60 based on
    #|#                                ; leap second rules
    #|offset = 1990-12-31T23:59:60Z
    #|local = 1990-12-31T23:59:60
    #|lt = 23:59:60
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "offset": Datetime(
      { year: 1990, month: 12, day: 31, },
      { hour: 23, minute: 59, second: 60, nanosecond: 0, },
      offset=0,
    ),
    "local": LocalDatetime({ year: 1990, month: 12, day: 31, }, {
      hour: 23,
      minute: 59,
      second: 60,
      nanosecond: 0,
    }),
    "lt": LocalTime({ hour: 23, minute: 59, second: 60, nanosecond: 0, }),
  })
}

///|
test "invalid/datetime/offset-hour-24" {
  let toml_text =
    #|# RFC 3339 time-numoffset uses time-hour, which is 00-23,
    #|# so +24:00 is out of range even though 24 hours is a real span.
    #|d = 1985-06-18 17:04:07+24:00
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "quickcheck: roundtrips" {
  @quickcheck.check(
    (doc : Map[String, @toml.Toml]) => @toml.parse(@toml.print(doc)) == doc,
    count=300,
  )
}

///|
test "quickcheck: parse should never panic" {
  @quickcheck.check((s : String) => {
    try @toml.parse(s) catch {
      _ => true
    } noraise {
      _ => true
    }
  })
}
