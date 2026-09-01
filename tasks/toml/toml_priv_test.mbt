///|
test "invalid/control/string-del" {
  let toml_text = "string-del  = \"null\u{7F}\"\n"
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/control/string-lf" {
  let toml_text = "string-lf   = \"null\u{10}\"\n"
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/control/string-null" {
  let toml_text = "string-null = \"null\u{00}\"\n"
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/control/string-us" {
  let toml_text = "string-us   = \"null\u{1F}\"\n"
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/datetime/day-zero" {
  let toml_text =
    #|foo = 1997-09-00T09:09:09.09Z
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/datetime/feb-30" {
  let toml_text =
    #|"only 28 or 29 days in february" = 1988-02-30T15:15:15Z
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/datetime/mday-under" {
  let toml_text =
    #|# date-mday       = 2DIGIT  ; 01-28, 01-29, 01-30, 01-31 based on
    #|#                           ; month/year
    #|d = 2006-01-00T00:00:00-00:00
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/datetime/minute-over" {
  let toml_text =
    #|# time-minute     = 2DIGIT  ; 00-59
    #|d = 2006-01-01T00:60:00-00:00
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/datetime/month-over" {
  let toml_text =
    #|# date-month      = 2DIGIT  ; 01-12
    #|d = 2006-13-01T00:00:00-00:00
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/datetime/month-under" {
  let toml_text =
    #|# date-month      = 2DIGIT  ; 01-12
    #|d = 2007-00-01T00:00:00-00:00
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/datetime/no-secs" {
  let toml_text =
    #|# No seconds in time.
    #|no-secs = 1987-07-05T17:45Z
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/datetime/no-t" {
  let toml_text =
    #|# No "t" or "T" between the date and time.
    #|no-t = 1987-07-0517:45:00Z
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/datetime/offset-plus-no-minute" {
  let toml_text =
    #|foo = 1997-09-09T09:09:09.09+09
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/datetime/only-TZ" {
  let toml_text =
    #|foo = TZ
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/datetime/only-T" {
  let toml_text =
    #|foo = T
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/datetime/only-Tdot" {
  let toml_text =
    #|foo = T.
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/datetime/second-over" {
  let toml_text =
    #|# time-second     = 2DIGIT  ; 00-58, 00-59, 00-60 based on leap second
    #|#                           ; rules
    #|d = 2006-01-01T00:00:61-00:00
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/datetime/second-trailing-dot" {
  let toml_text =
    #|foo = 1997-09-09T09:09:09.
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/datetime/second-trailing-dotz" {
  let toml_text =
    #|foo = 2016-09-09T09:09:09.Z
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/datetime/time-no-leads" {
  let toml_text =
    #|# Leading 0 is always required.
    #|d = 2023-10-01T1:32:00Z
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/datetime/trailing-x" {
  let toml_text =
    #|sign=2020-01-01x
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/float/double-dot-01" {
  let toml_text =
    #|double-dot-01 = 0..1
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/float/double-dot-02" {
  let toml_text =
    #|double-dot-02 = 0.1.2
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/float/leading-dot-neg" {
  let toml_text =
    #|leading-dot-neg = -.12345
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/float/leading-dot-plus" {
  let toml_text =
    #|leading-dot-plus = +.12345
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/float/leading-dot" {
  let toml_text =
    #|leading-dot = .12345
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/float/leading-zero-neg" {
  let toml_text =
    #|leading-zero-neg = -03.14
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/float/leading-zero-plus" {
  let toml_text =
    #|leading-zero-plus = +03.14
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/float/leading-zero" {
  let toml_text =
    #|leading-zero = 03.14
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/float/trailing-dot-01" {
  let toml_text =
    #|trailing-point = 1.
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/float/trailing-dot-02" {
  let toml_text =
    #|a = 1.
    #|b = 2
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/float/trailing-dot-min" {
  let toml_text =
    #|trailing-dot-min = -1.
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/float/trailing-dot-plus" {
  let toml_text =
    #|trailing-dot-plus = +1.
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/float/trailing-dot" {
  let toml_text =
    #|trailing-dot = 1.
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/float/trailing-exp" {
  let toml_text =
    #|trailing-exp = 0.0E
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/float/trailing-us" {
  let toml_text =
    #|trailing-us = 1.2_
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/float/us-after-dot" {
  let toml_text =
    #|us-after-dot = 1._2
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/float/us-before-dot" {
  let toml_text =
    #|us-before-dot = 1_.2
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/inline-table/bad-key-syntax" {
  let toml_text =
    #|tbl = { a = 1, [b] }
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/inline-table/double-comma" {
  let toml_text =
    #|t = {x=3,,y=4}
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/inline-table/empty-01" {
  let toml_text =
    #|t = {,}
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/inline-table/empty-02" {
  let toml_text =
    #|t = {,
    #|}
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/inline-table/empty-03" {
  let toml_text =
    #|t = {
    #|,
    #|}
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/inline-table/linebreak-01" {
  let toml_text =
    #|# No newlines are allowed between the curly braces unless they are valid within
    #|# a value.
    #|simple = { a = 1 
    #|}
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/inline-table/linebreak-02" {
  let toml_text =
    #|t = {a=1,
    #|b=2}
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/inline-table/linebreak-03" {
  let toml_text =
    #|t = {a=1
    #|,b=2}
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/inline-table/linebreak-04" {
  let toml_text =
    #|json_like = {
    #|          first = "Tom",
    #|          last = "Preston-Werner"
    #|}
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/inline-table/no-close-01" {
  let toml_text =
    #|a={
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/inline-table/no-close-02" {
  let toml_text =
    #|a={b=1
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/inline-table/no-comma-01" {
  let toml_text =
    #|t = {x = 3 y = 4}
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/inline-table/no-comma-02" {
  let toml_text =
    #|arrr = { comma-missing = true valid-toml = false }
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/inline-table/trailing-comma" {
  let toml_text =
    #|# A terminating comma (also called trailing comma) is not permitted after the
    #|# last key/value pair in an inline table
    #|abc = { abc = 123, }
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/integer/capital-bin" {
  let toml_text =
    #|capital-bin = 0B0
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/integer/capital-hex" {
  let toml_text =
    #|capital-hex = 0X1
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/integer/capital-oct" {
  let toml_text =
    #|capital-oct = 0O0
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/integer/double-sign-nex" {
  let toml_text =
    #|double-sign-nex = --99
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/integer/double-sign-plus" {
  let toml_text =
    #|double-sign-plus = ++99
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/integer/double-us" {
  let toml_text =
    #|double-us = 1__23
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/integer/incomplete-bin" {
  let toml_text =
    #|incomplete-bin = 0b
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/integer/incomplete-hex" {
  let toml_text =
    #|incomplete-hex = 0x
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/integer/incomplete-oct" {
  let toml_text =
    #|incomplete-oct = 0o
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/integer/invalid-bin" {
  let toml_text =
    #|invalid-bin = 0b0012
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/integer/invalid-hex-01" {
  let toml_text =
    #|invalid-hex-01 = 0xaafz
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/integer/invalid-hex-02" {
  let toml_text =
    #|invalid-hex-02 = 0xgabba00f1
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/integer/invalid-hex-03" {
  let toml_text =
    #|a = 0x-1
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/integer/invalid-oct" {
  let toml_text =
    #|invalid-oct = 0o778
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/integer/leading-us-bin" {
  let toml_text =
    #|leading-us-bin = _0b1
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/integer/leading-us-hex" {
  let toml_text =
    #|leading-us-hex = _0x1
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/integer/leading-us-oct" {
  let toml_text =
    #|leading-us-oct = _0o1
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/integer/leading-us" {
  let toml_text =
    #|leading-us = _123
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/integer/leading-zero-01" {
  let toml_text =
    #|leading-zero-01 = 01
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/integer/leading-zero-02" {
  let toml_text =
    #|leading-zero-02 = 00
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/integer/leading-zero-03" {
  let toml_text =
    #|leading-zero-03 = 0_0
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/integer/leading-zero-sign-01" {
  let toml_text =
    #|leading-zero-sign-01 = -01
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/integer/leading-zero-sign-02" {
  let toml_text =
    #|leading-zero-sign-02 = +01
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/integer/leading-zero-sign-03" {
  let toml_text =
    #|leading-zero-sign-03 = +0_1
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/integer/negative-bin" {
  let toml_text =
    #|negative-bin = -0b11010110
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/integer/negative-hex" {
  let toml_text =
    #|negative-hex = -0xff
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/integer/negative-oct" {
  let toml_text =
    #|negative-oct = -0o755
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/integer/positive-bin" {
  let toml_text =
    #|positive-bin = +0b11010110
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/integer/positive-hex" {
  let toml_text =
    #|positive-hex = +0xff
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/integer/positive-oct" {
  let toml_text =
    #|positive-oct = +0o755
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/integer/text-after-integer" {
  let toml_text =
    #|answer = 42 the ultimate answer?
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/integer/trailing-us-bin" {
  let toml_text =
    #|trailing-us-bin = 0b1_
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/integer/trailing-us-hex" {
  let toml_text =
    #|trailing-us-hex = 0x1_
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/integer/trailing-us-oct" {
  let toml_text =
    #|trailing-us-oct = 0o1_
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/integer/trailing-us" {
  let toml_text =
    #|trailing-us = 123_
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/integer/us-after-bin" {
  let toml_text =
    #|us-after-bin = 0b_1
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/integer/us-after-hex" {
  let toml_text =
    #|us-after-hex = 0x_1
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/integer/us-after-oct" {
  let toml_text =
    #|us-after-oct = 0o_1
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/key/bare-invalid-character-01" {
  let toml_text =
    #|! = 123
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/key/bare-invalid-character-02" {
  let toml_text =
    #|bare!key = 123
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/key/empty" {
  let toml_text =
    #| = 1
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/key/hash" {
  let toml_text =
    #|a# = 1
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/key/newline-03" {
  let toml_text =
    #|'quoted
    #|key' = 1
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/key/newline-04" {
  let toml_text =
    #|"""long
    #|key""" = 1
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/key/newline-05" {
  let toml_text =
    #|'''long
    #|key''' = 1
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/key/newline-06" {
  let toml_text =
    #|key =
    #|1
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/key/no-eol-01" {
  let toml_text =
    #|a = 1 b = 2
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/key/no-eol-02" {
  let toml_text =
    #|0=0r=false
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/key/no-eol-03" {
  let toml_text =
    #|0=""o=""m=""r=""00="0"q="""0"""e="""0"""
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/key/no-eol-04" {
  let toml_text =
    #|[[0000l0]]
    #|0="0"[[0000l0]]
    #|0="0"[[0000l0]]
    #|0="0"l="0"
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/key/no-eol-05" {
  let toml_text =
    #|0=[0]00=[0,0,0]t=["0","0","0"]s=[1000-00-00T00:00:00Z,2000-00-00T00:00:00Z]
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/key/no-eol-06" {
  let toml_text =
    #|0=0r0=0r=false
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/key/no-eol-07" {
  let toml_text =
    #|0=0r0=0r=falsefal=false
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/key/only-float" {
  let toml_text =
    #|1.1
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/key/only-int" {
  let toml_text =
    #|1
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/key/only-str" {
  let toml_text =
    #|""
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/key/open-bracket" {
  let toml_text =
    #|[abc = 1
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/key/partial-quoted" {
  let toml_text =
    #|partial"quoted" = 5
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/key/quoted-unclosed-01" {
  let toml_text =
    #|"key = x
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/key/quoted-unclosed-02" {
  let toml_text =
    #|"key
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/key/single-open-bracket" {
  let toml_text =
    #|[
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/key/space" {
  let toml_text =
    #|a b = 1
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/key/special-character" {
  let toml_text =
    #|μ = "greek small letter mu"
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/key/start-bracket" {
  let toml_text =
    #|[a]
    #|[xyz = 5
    #|[b]
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/key/start-dot" {
  let toml_text =
    #|.key = 1
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/key/two-equals-01" {
  let toml_text =
    #|key= = 1
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/key/two-equals-02" {
  let toml_text =
    #|a==1
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/key/two-equals-03" {
  let toml_text =
    #|a=b=1
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/key/without-value-01" {
  let toml_text =
    #|key
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/key/without-value-02" {
  let toml_text =
    #|key = 
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/key/without-value-03" {
  let toml_text =
    #|"key"
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/key/without-value-04" {
  let toml_text =
    #|"key" = 
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/key/without-value-05" {
  let toml_text =
    #|fs.fw
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/key/without-value-06" {
  let toml_text =
    #|fs.fw =
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/key/without-value-07" {
  let toml_text =
    #|fs.
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/local-datetime/minute-over" {
  let toml_text =
    #|# time-minute     = 2DIGIT  ; 00-59
    #|d = 2006-01-01T00:60:00
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/local-datetime/month-over" {
  let toml_text =
    #|# date-month      = 2DIGIT  ; 01-12
    #|d = 2006-13-01T00:00:00
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/local-datetime/month-under" {
  let toml_text =
    #|# date-month      = 2DIGIT  ; 01-12
    #|d = 2007-00-01T00:00:00
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/local-datetime/no-secs" {
  let toml_text =
    #|# No seconds in time.
    #|no-secs = 1987-07-05T17:45
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/local-datetime/no-t" {
  let toml_text =
    #|# No "t" or "T" between the date and time.
    #|no-t = 1987-07-0517:45:00
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/local-datetime/second-over" {
  let toml_text =
    #|# time-second     = 2DIGIT  ; 00-58, 00-59, 00-60 based on leap second
    #|#                           ; rules
    #|d = 2006-01-01T00:00:61
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/local-time/hour-over" {
  let toml_text =
    #|# time-hour       = 2DIGIT  ; 00-23
    #|d = 24:00:00
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/local-time/minute-over" {
  let toml_text =
    #|# time-minute     = 2DIGIT  ; 00-59
    #|d = 00:60:00
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/local-time/no-secs" {
  let toml_text =
    #|# No seconds in time.
    #|no-secs = 17:45
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/local-time/second-over" {
  let toml_text =
    #|# time-second     = 2DIGIT  ; 00-58, 00-59, 00-60 based on leap second
    #|#                           ; rules
    #|d = 00:00:61
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/string/missing-quotes-array" {
  let toml_text =
    #|name = [value]
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/string/missing-quotes-inline-table" {
  let toml_text =
    #|name = { key = value }
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/string/missing-quotes" {
  let toml_text =
    #|name = value
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/string/no-close-01" {
  let toml_text =
    #|no-ending-quote = "One time, at band camp
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/string/no-close-02" {
  let toml_text =
    #|"a-string".must-be = "closed
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/string/no-close-03" {
  let toml_text =
    #|no-ending-quote = 'One time, at band camp
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/string/no-close-04" {
  let toml_text =
    #|'a-string'.must-be = 'closed
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/string/no-close-05" {
  let toml_text =
    #|# No newline at end
    #|no-ending-quote = "One time, at band camp
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/string/no-close-06" {
  let toml_text =
    #|# No newline at end
    #|"a-string".must-be = "closed
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/string/no-close-07" {
  let toml_text =
    #|# No newline at end
    #|no-ending-quote = 'One time, at band camp
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/string/no-close-08" {
  let toml_text =
    #|# No newline at end
    #|'a-string'.must-be = 'closed
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/string/no-close-09" {
  let toml_text =
    #|# Newlines are not allowed in "-strings.
    #|a = "
    #|"
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/string/no-close-10" {
  let toml_text =
    #|# Newlines are not allowed in '-strings.
    #|a = '
    #|'
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/string/no-open-01" {
  let toml_text =
    #|s = a"
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/string/no-open-02" {
  let toml_text =
    #|a = [a"]
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/string/no-open-03" {
  let toml_text =
    #|s = a'
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/string/no-open-04" {
  let toml_text =
    #|a = [a']
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/string/no-open-05" {
  let toml_text =
    #|a = a"""
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/string/no-open-06" {
  let toml_text =
    #|a = [a"""]
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/string/no-open-07" {
  let toml_text =
    #|a = a'''
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/string/no-open-08" {
  let toml_text =
    #|a = [a''']
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/string/text-after-string" {
  let toml_text =
    #|string = "Is there life after strings?" No.
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/string/wrong-close" {
  let toml_text =
    #|bad-ending-quote = "double and single'
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/table/array-empty" {
  let toml_text =
    #|[[]]
    #|name = "Born to Run"
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/table/array-no-close-01" {
  let toml_text =
    #|[[albums]
    #|name = "Born to Run"
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/table/array-no-close-02" {
  let toml_text =
    #|[[closing-bracket.missing]
    #|blaa=2
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/table/array-no-close-03" {
  let toml_text =
    #|[[a
    #|[[b]]
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/table/array-no-close-04" {
  let toml_text =
    #|[[a
    #|b = 2
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/table/bare-invalid-character-01" {
  let toml_text =
    #|[!]
    #|k = 123
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/table/bare-invalid-character-02" {
  let toml_text =
    #|[bare!key]
    #|k = 123
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/table/dot" {
  let toml_text =
    #|[.]
    #|k = 1
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/table/dotdot" {
  let toml_text =
    #|[..]
    #|k = 1
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/table/equals-sign" {
  let toml_text =
    #|[name=bad]
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/table/llbrace" {
  let toml_text =
    #|[ [table]]
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/table/no-close-01" {
  let toml_text =
    #|[where will it end
    #|name = value
    #|
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/table/no-close-02" {
  let toml_text =
    #|[closing-bracket.missingö
    #|blaa=2
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/table/no-close-03" {
  let toml_text =
    #|["where will it end]
    #|name = value
    #|
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/table/no-close-04" {
  let toml_text =
    #|[
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/table/no-close-05" {
  let toml_text =
    #|[fwfw.wafw
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/table/no-close-06" {
  let toml_text =
    #|[a
    #|[b]
    #|[c
    #|[d]
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/table/no-close-07" {
  let toml_text =
    #|[']
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/table/no-close-08" {
  let toml_text =
    #|[''']
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/table/rrbrace" {
  let toml_text =
    #|[[table] ]
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/table/text-after-table" {
  let toml_text =
    #|[error] this shouldn't be here
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/table/trailing-dot" {
  let toml_text =
    #|[a.]
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/table/whitespace" {
  let toml_text =
    #|[invalid key]
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/table/with-pound" {
  let toml_text =
    #|[key#group]
    #|answer = 42
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/array/text-after-array-entries" {
  let toml_text =
    #|array = [
    #|  "Is there life after an array separator?", No
    #|  "Entry"
    #|]
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/array/text-before-array-separator" {
  let toml_text =
    #|array = [
    #|  "Is there life before an array separator?" No,
    #|  "Entry"
    #|]
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/array/text-in-array" {
  let toml_text =
    #|array = [
    #|  "Entry 1",
    #|  I don't belong,
    #|  "Entry 2",
    #|]
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/control/multi-cr" {
  let toml_text = "multi-cr   = \"\"\"null\r\"\"\"\n"
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/control/multi-del" {
  let toml_text = "multi-del  = \"\"\"null\u{7F}\"\"\"\n"
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/control/multi-lf" {
  let toml_text = "multi-lf   = \"\"\"null\u{10}\"\"\"\n"
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/control/multi-null" {
  let toml_text = "multi-null = \"\"\"null\u{00}\"\"\"\n"
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/control/multi-us" {
  let toml_text = "multi-us   = \"\"\"null\u{1F}\"\"\"\n"
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/control/rawmulti-cr" {
  let toml_text = "rawmulti-cr   = '''null\r'''\n"
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/control/rawmulti-del" {
  let toml_text = "rawmulti-del  = '''null\u{7F}'''\n"
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/control/rawmulti-lf" {
  let toml_text = "rawmulti-lf   = '''null\u{10}'''\n"
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/control/rawmulti-null" {
  let toml_text = "rawmulti-null = '''null\u{00}'''\n"
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/control/rawmulti-us" {
  let toml_text = "rawmulti-us   = '''null\u{1F}'''\n"
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/control/rawstring-cr" {
  let toml_text = "rawstring-cr   = 'null\r'\n"
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/control/rawstring-del" {
  let toml_text = "rawstring-del  = 'null\u{7F}'\n"
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/control/rawstring-lf" {
  let toml_text = "rawstring-lf   = 'null\u{10}'\n"
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/control/rawstring-null" {
  let toml_text = "rawstring-null = 'null\u{00}'\n"
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/control/rawstring-us" {
  let toml_text = "rawstring-us   = 'null\u{1F}'\n"
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/datetime/feb-29" {
  let toml_text =
    #|"not a leap year" = 2100-02-29T15:15:15Z
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/datetime/mday-over" {
  let toml_text =
    #|# date-mday       = 2DIGIT  ; 01-28, 01-29, 01-30, 01-31 based on
    #|#                           ; month/year
    #|d = 2006-01-32T00:00:00-00:00
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/datetime/no-date-time-sep" {
  let toml_text =
    #|foo = 1997-09-0909:09:09
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/datetime/no-leads-month" {
  let toml_text =
    #|# Month "7" instead of "07"; the leading zero is required.
    #|no-leads = 1987-7-05T17:45:00Z
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/datetime/no-leads-with-milli" {
  let toml_text =
    #|# Day "5" instead of "05"; the leading zero is required.
    #|with-milli = 1987-07-5T17:45:00.12Z
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/datetime/no-leads" {
  let toml_text =
    #|# Month "7" instead of "07"; the leading zero is required.
    #|no-leads = 1987-7-05T17:45:00Z
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/datetime/no-year-month-sep" {
  let toml_text =
    #|foo = 199709-09
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/datetime/y10k" {
  let toml_text =
    #|# Maximum RFC3399 year is 9999.
    #|d = 10000-01-01 00:00:00z
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/encoding/ideographic-space" {
  let toml_text = "# First on next line is U+3000 IDEOGRAPHIC SPACE\n　foo = \"bar\"\n"
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/encoding/utf16-comment" {
  let toml_text = "\u{00}#\u{00} \u{00}U\u{00}T\u{00}F\u{00}-\u{00}1\u{00}6\u{00} \u{00}w\u{00}i\u{00}t\u{00}h\u{00}o\u{00}u\u{00}t\u{00} \u{00}B\u{00}O\u{00}M\u{00}\n"
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/encoding/utf16-key" {
  let toml_text = "\u{00}k\u{00} \u{00}=\u{00} \u{00}\"\u{00}v\u{00}\"\u{00}\n"
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/float/exp-dot-01" {
  let toml_text =
    #|exp-dot-01 = 1e2.3
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/float/exp-dot-02" {
  let toml_text =
    #|exp-dot-02 = 1.e2
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/float/exp-dot-03" {
  let toml_text =
    #|exp-dot-03 = 3.e+20
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/float/exp-double-e-01" {
  let toml_text =
    #|exp-double-e-01 = 1ee2
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/float/exp-double-e-02" {
  let toml_text =
    #|exp-double-e-02 = 1e2e3
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/float/exp-double-us" {
  let toml_text =
    #|exp-double-us = 1e__23
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/float/exp-leading-us" {
  let toml_text =
    #|exp-leading-us = 1e_23
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/float/exp-trailing-us-01" {
  let toml_text =
    #|exp-trailing-us-01 = 1_e2
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/float/exp-trailing-us-02" {
  let toml_text =
    #|exp-trailing-us-02 = 1.2_e2
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/float/exp-trailing-us" {
  let toml_text =
    #|exp-trailing-us = 1e23_
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/float/inf-capital" {
  let toml_text =
    #|v = Inf
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/float/inf-incomplete-01" {
  let toml_text =
    #|inf-incomplete-01 = in
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/float/inf-incomplete-02" {
  let toml_text =
    #|inf-incomplete-02 = +in
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/float/inf-incomplete-03" {
  let toml_text =
    #|inf-incomplete-03 = -in
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/float/inf_underscore" {
  let toml_text =
    #|inf_underscore = in_f
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/float/nan-capital" {
  let toml_text =
    #|v = NaN
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/float/nan-incomplete-01" {
  let toml_text =
    #|nan-incomplete-01 = na
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/float/nan-incomplete-02" {
  let toml_text =
    #|nan-incomplete-02 = +na
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/float/nan-incomplete-03" {
  let toml_text =
    #|nan-incomplete-03 = -na
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/float/nan_underscore" {
  let toml_text =
    #|nan_underscore = na_n
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/float/trailing-exp-dot" {
  let toml_text =
    #|trailing-exp-dot =  0.e
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/float/trailing-exp-minus" {
  let toml_text =
    #|trailing-exp-minus = 0.0e-
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/float/trailing-exp-plus" {
  let toml_text =
    #|trailing-exp-plus = 0.0e+
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/float/trailing-us-exp-01" {
  let toml_text =
    #|trailing-us-exp-1 = 1_e2
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/float/trailing-us-exp-02" {
  let toml_text =
    #|trailing-us-exp-2 = 1.2_e2
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/inline-table/duplicate-key-01" {
  let toml_text =
    #|# Duplicate keys within an inline table are invalid
    #|a={b=1, b=2}
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/inline-table/duplicate-key-02" {
  let toml_text =
    #|table1 = { table2.dupe = 1, table2.dupe = 2 }
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/inline-table/duplicate-key-03" {
  let toml_text =
    #|tbl = { fruit = { apple.color = "red" }, fruit.apple.texture = { smooth = true } }
    #|
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/inline-table/overwrite-01" {
  let toml_text =
    #|a.b=0
    #|# Since table "a" is already defined, it can't be replaced by an inline table.
    #|a={}
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/inline-table/overwrite-02" {
  let toml_text =
    #|a={}
    #|# Inline tables are immutable and can't be extended
    #|[a.b]
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/inline-table/overwrite-03" {
  let toml_text =
    #|a = { b = 1 }
    #|a.b = 2
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/inline-table/overwrite-04" {
  let toml_text =
    #|inline-t = { nest = {} }
    #|
    #|[[inline-t.nest]]
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/inline-table/overwrite-05" {
  let toml_text =
    #|inline-t = { nest = {} }
    #|
    #|[inline-t.nest]
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/inline-table/overwrite-06" {
  let toml_text =
    #|a = { b = 1, b.c = 2 }
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/inline-table/overwrite-07" {
  let toml_text =
    #|tab = { inner.table = [{}], inner.table.val = "bad" }
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/inline-table/overwrite-08" {
  let toml_text =
    #|tab = { inner = { dog = "best" }, inner.cat = "worst" }
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/inline-table/overwrite-09" {
  let toml_text =
    #|[tab.nested]
    #|inline-t = { nest = {} }
    #|
    #|[tab]
    #|nested.inline-t.nest = 2
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/inline-table/overwrite-10" {
  let toml_text =
    #|# Set implicit "b", overwrite "b" (illegal!) and then set another implicit.
    #|#
    #|# Caused panic: https://github.com/BurntSushi/toml/issues/403
    #|a = {b.a = 1, b = 2, b.c = 3}
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/key/after-array" {
  let toml_text =
    #|[[agencies]] owner = "S Cjelli"
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/key/after-table" {
  let toml_text =
    #|[error] this = "should not be here"
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/key/after-value" {
  let toml_text =
    #|first = "Tom" last = "Preston-Werner" # INVALID
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/key/dot" {
  let toml_text =
    #|. = 1
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/key/dotdot" {
  let toml_text =
    #|.. = 1
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/key/end-in-escape" {
  let toml_text =
    #|"backslash is the last char\
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/key/escape" {
  let toml_text =
    #|\u00c0 = "latin capital letter A with grave"
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/key/multiline-key-01" {
  let toml_text =
    #|"""key""" = 1
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/key/multiline-key-02" {
  let toml_text =
    #|'''key''' = 1
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/key/multiline-key-03" {
  let toml_text =
    #|"""key""" = """v"""
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/key/multiline-key-04" {
  let toml_text =
    #|'''key''' = '''v'''
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/key/newline-01" {
  let toml_text =
    #|barekey
    #|   = 1
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/key/newline-02" {
  let toml_text =
    #|"quoted
    #|key" = 1
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/local-date/day-1digit" {
  let toml_text =
    #|foo = 1997-09-9
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/local-date/feb-29" {
  let toml_text =
    #|"not a leap year" = 2100-02-29
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/local-date/feb-30" {
  let toml_text =
    #|"only 28 or 29 days in february" = 1988-02-30
    #|
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/local-date/mday-over" {
  let toml_text =
    #|# date-mday       = 2DIGIT  ; 01-28, 01-29, 01-30, 01-31 based on
    #|#                           ; month/year
    #|d = 2006-01-32
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/local-date/mday-under" {
  let toml_text =
    #|# date-mday       = 2DIGIT  ; 01-28, 01-29, 01-30, 01-31 based on
    #|#                           ; month/year
    #|d = 2006-01-00
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/local-date/month-over" {
  let toml_text =
    #|# date-month      = 2DIGIT  ; 01-12
    #|d = 2006-13-01
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/local-date/month-under" {
  let toml_text =
    #|# date-month      = 2DIGIT  ; 01-12
    #|d = 2007-00-01
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/local-date/no-leads-with-milli" {
  let toml_text =
    #|# Day "5" instead of "05"; the leading zero is required.
    #|with-milli = 1987-07-5
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/local-date/no-leads" {
  let toml_text =
    #|# Month "7" instead of "07"; the leading zero is required.
    #|no-leads = 1987-7-05
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/local-date/trailing-t" {
  let toml_text =
    #|# Date cannot end with trailing T
    #|d = 2006-01-30T
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/local-date/year-3digits" {
  let toml_text =
    #|foo = 199-09-09
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/local-datetime/no-leads-with-milli" {
  let toml_text =
    #|# Day "5" instead of "05"; the leading zero is required.
    #|with-milli = 1987-07-5T17:45:00.12
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/local-datetime/no-leads" {
  let toml_text =
    #|# Month "7" instead of "07"; the leading zero is required.
    #|no-leads = 1987-7-05T17:45:00
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/local-datetime/time-no-leads" {
  let toml_text =
    #|# Leading 0 is always required.
    #|d = 2023-10-01T1:32:00Z
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/local-time/time-no-leads-01" {
  let toml_text =
    #|# Leading 0 is always required.
    #|d = 1:32:00
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/local-time/time-no-leads-02" {
  let toml_text =
    #|# Leading 0 is always required.
    #|d = 01:32:0
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/local-time/trailing-dot" {
  let toml_text =
    #|t = 12:13:14.
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/local-time/trailing-dotdot" {
  let toml_text =
    #|t = 12:13:14..
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/string/bad-byte-escape" {
  let toml_text =
    #|naughty = "\xAg"
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/string/bad-concat" {
  let toml_text =
    #|no_concat = "first" "second"
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/string/bad-escape-01" {
  let toml_text =
    #|invalid-escape = "This string has a bad \a escape character."
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/string/bad-escape-02" {
  let toml_text =
    #|invalid-escape = "This string has a bad \  escape character."
    #|
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/string/bad-escape-03" {
  let toml_text =
    #|backslash = "\"
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/string/bad-escape-04" {
  let toml_text =
    #|a = "a \\\ b"
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/string/bad-escape-05" {
  let toml_text =
    #|a = "a \\\\\ b"
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/string/bad-hex-esc-01" {
  let toml_text =
    #|bad-hex-esc-01 = "\x0g"
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/string/bad-hex-esc-02" {
  let toml_text =
    #|bad-hex-esc-02 = "\xG0"
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/string/bad-hex-esc-03" {
  let toml_text =
    #|bad-hex-esc-03 = "\x"
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/string/bad-hex-esc-04" {
  let toml_text =
    #|bad-hex-esc-04 = "\x 50"
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/string/bad-hex-esc-05" {
  let toml_text =
    #|bad-hex-esc-5 = "\x 50"
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/string/bad-multiline" {
  let toml_text =
    #|multi = "first line
    #|second line"
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/string/bad-slash-escape" {
  let toml_text =
    #|invalid-escape = "This string has a bad \/ escape character."
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/string/bad-uni-esc-01" {
  let toml_text =
    #|bad-uni-esc-01 = "val\ue"
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/string/bad-uni-esc-02" {
  let toml_text =
    #|bad-uni-esc-02 = "val\Ux"
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/string/bad-uni-esc-03" {
  let toml_text =
    #|bad-uni-esc-03 = "val\U0000000"
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/string/bad-uni-esc-04" {
  let toml_text =
    #|bad-uni-esc-04 = "val\U0000"
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/string/bad-uni-esc-05" {
  let toml_text =
    #|bad-uni-esc-05 = "val\Ugggggggg"
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/string/bad-uni-esc-06" {
  let toml_text =
    #|bad-uni-esc-06 = "This string contains a non scalar unicode codepoint \uD801"
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/string/bad-uni-esc-07" {
  let toml_text =
    #|bad-uni-esc-07 = "\uabag"
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/string/bad-uni-esc-ml-01" {
  let toml_text =
    #|bad-uni-esc-ml-01 = """val\ue"""
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/string/bad-uni-esc-ml-02" {
  let toml_text =
    #|bad-uni-esc-ml-02 = """val\Ux"""
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/string/bad-uni-esc-ml-03" {
  let toml_text =
    #|bad-uni-esc-ml-03 = """val\U0000000"""
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/string/bad-uni-esc-ml-04" {
  let toml_text =
    #|bad-uni-esc-ml-04 = """val\U0000"""
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/string/bad-uni-esc-ml-05" {
  let toml_text =
    #|bad-uni-esc-ml-05 = """val\Ugggggggg"""
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/string/bad-uni-esc-ml-06" {
  let toml_text =
    #|bad-uni-esc-ml-06 = """This string contains a non scalar unicode codepoint \uD801"""
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/string/bad-uni-esc-ml-07" {
  let toml_text =
    #|bad-uni-esc-ml-07 = """\uabag"""
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/string/basic-byte-escapes" {
  let toml_text =
    #|answer = "\x33"
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/string/basic-multiline-out-of-range-unicode-escape-01" {
  let toml_text =
    #|a = """\UFFFFFFFF"""
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/string/basic-multiline-out-of-range-unicode-escape-02" {
  let toml_text =
    #|a = """\U00D80000"""
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/string/basic-multiline-quotes" {
  let toml_text =
    #|str5 = """Here are three quotation marks: """."""
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/string/basic-multiline-unknown-escape" {
  let toml_text =
    #|a = """\@"""
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/string/basic-out-of-range-unicode-escape-01" {
  let toml_text =
    #|a = "\UFFFFFFFF"
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/string/basic-out-of-range-unicode-escape-02" {
  let toml_text =
    #|a = "\U00D80000"
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/string/basic-unknown-escape" {
  let toml_text =
    #|a = "\@"
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/string/multiline-bad-escape-01" {
  let toml_text =
    #|k = """t\a"""
    #|
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/string/multiline-bad-escape-02" {
  let toml_text =
    #|# \<Space> is not a valid escape.
    #|k = """t\ t"""
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/string/multiline-bad-escape-03" {
  let toml_text =
    #|# \<Space> is not a valid escape.
    #|k = """t\ """
    #|
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/string/multiline-bad-escape-04" {
  let toml_text =
    #|backslash = """\"""
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/string/multiline-escape-space-01" {
  let toml_text =
    #|a = """
    #|  foo \ \n
    #|  bar"""
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/string/multiline-escape-space-02" {
  let toml_text =
    #|bee = """
    #|hee \
    #|
    #|gee \   """
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/table/append-with-dotted-keys-01" {
  let toml_text =
    #|# First a.b.c defines a table: a.b.c = {z=9}
    #|#
    #|# Then we define a.b.c.t = "str" to add a str to the above table, making it:
    #|#
    #|#   a.b.c = {z=9, t="..."}
    #|#
    #|# While this makes sense, logically, it was decided this is not valid TOML as
    #|# it's too confusing/convoluted.
    #|# 
    #|# See: https://github.com/toml-lang/toml/issues/846
    #|#      https://github.com/toml-lang/toml/pull/859
    #|
    #|[a.b.c]
    #|  z = 9
    #|
    #|[a]
    #|  b.c.t = "Using dotted keys to add to [a.b.c] after explicitly defining it above is not allowed"
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/table/append-with-dotted-keys-02" {
  let toml_text =
    #|# This is the same issue as in injection-1.toml, except that nests one level
    #|# deeper. See that file for a more complete description.
    #|
    #|[a.b.c.d]
    #|  z = 9
    #|
    #|[a]
    #|  b.c.d.k.t = "Using dotted keys to add to [a.b.c.d] after explicitly defining it above is not allowed"
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/table/append-with-dotted-keys-03" {
  let toml_text =
    #|[[a.b]]
    #|
    #|[a]
    #|b.y = 2
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/table/append-with-dotted-keys-04" {
  let toml_text =
    #|[dependencies.foo]
    #|version = "0.16"
    #|
    #|[dependencies]
    #|libc = "0.2"
    #|
    #|[dependencies]
    #|rand = "0.3.14"
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/table/append-with-dotted-keys-05" {
  let toml_text =
    #|a.b.c = 1
    #|a.b = 2
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/table/append-with-dotted-keys-06" {
  let toml_text =
    #|a = 1
    #|a.b = 2
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/table/append-with-dotted-keys-07" {
  let toml_text =
    #|a = {k1 = 1, k1.name = "joe"}
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/table/array-implicit" {
  let toml_text =
    #|# This test is a bit tricky. It should fail because the first use of
    #|# `[[albums.songs]]` without first declaring `albums` implies that `albums`
    #|# must be a table. The alternative would be quite weird. Namely, it wouldn't
    #|# comply with the TOML spec: "Each double-bracketed sub-table will belong to 
    #|# the most *recently* defined table element *above* it."
    #|#
    #|# This is in contrast to the *valid* test, table-array-implicit where
    #|# `[[albums.songs]]` works by itself, so long as `[[albums]]` isn't declared
    #|# later. (Although, `[albums]` could be.)
    #|[[albums.songs]]
    #|name = "Glory Days"
    #|
    #|[[albums]]
    #|name = "Born in the USA"
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/table/duplicate-key-01" {
  let toml_text =
    #|[a]
    #|b = 1
    #|
    #|[a]
    #|c = 2
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/table/duplicate-key-02" {
  let toml_text =
    #|[fruit]
    #|type = "apple"
    #|
    #|[fruit.type]
    #|apple = "yes"
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/table/duplicate-key-03" {
  let toml_text =
    #|[fruit]
    #|apple.color = "red"
    #|
    #|[[fruit.apple]]
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/table/duplicate-key-04" {
  let toml_text =
    #|[fruit]
    #|apple.color = "red"
    #|
    #|[fruit.apple] # INVALID
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/table/duplicate-key-05" {
  let toml_text =
    #|[fruit]
    #|apple.taste.sweet = true
    #|
    #|[fruit.apple.taste] # INVALID
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/table/duplicate-key-06" {
  let toml_text =
    #|[tbl]
    #|[[tbl]]
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/table/duplicate-key-07" {
  let toml_text =
    #|[[tbl]]
    #|[tbl]
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/table/duplicate-key-08" {
  let toml_text =
    #|[a]
    #|b = { c = 2, d = {} }
    #|[a.b]
    #|c = 2
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/table/duplicate-key-09" {
  let toml_text =
    #|[a]
    #|foo="bar"
    #|[a.b]
    #|foo="bar"
    #|[a]
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/table/duplicate-key-10" {
  let toml_text =
    #|a = []
    #|[[a.b]]
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/table/empty-implicit-table" {
  let toml_text =
    #|[naughty..naughty]
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/table/empty" {
  let toml_text =
    #|[]
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/table/multiline-key-01" {
  let toml_text =
    #|["""tbl"""]
    #|k = 1
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/table/multiline-key-02" {
  let toml_text =
    #|['''tbl''']
    #|k = 1
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/table/nested-brackets-close" {
  let toml_text =
    #|[a]b]
    #|zyx = 42
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/table/nested-brackets-open" {
  let toml_text =
    #|[a[b]
    #|zyx = 42
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/table/newline-01" {
  let toml_text =
    #|[tbl
    #|]
    #|k = 1
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/table/newline-02" {
  let toml_text =
    #|["tbl
    #|"]
    #|k = 1
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/table/newline-03" {
  let toml_text =
    #|["tbl"
    #|]
    #|k = 1
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/table/newline-04" {
  let toml_text =
    #|[tbl.
    #|]
    #|k = 1
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/table/newline-05" {
  let toml_text =
    #|[tbl
    #|.sub]
    #|k = 1
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/table/no-close-09" {
  let toml_text =
    #|["where will it end""]
    #|name = value
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/table/super-twice" {
  let toml_text =
    #|[a.b]
    #|[a]
    #|[a]
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/array/extend-defined-aot" {
  let toml_text =
    #|[[tab.arr]]
    #|[tab]
    #|arr.val1=1
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/array/extending-table" {
  let toml_text =
    #|a = [{ b = 1 }]
    #|
    #|# Cannot extend tables within static arrays
    #|# https://github.com/toml-lang/toml/issues/908
    #|[a.c]
    #|foo = 1
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/array/no-close-table-01" {
  let toml_text =
    #|x = [{ key = 42
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/array/no-close-table-02" {
  let toml_text =
    #|x = [{ key = 42 #
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/array/tables-01" {
  let toml_text =
    #|# INVALID TOML DOC
    #|fruit = []
    #|
    #|[[fruit]] # Not allowed
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/array/tables-02" {
  let toml_text =
    #|# INVALID TOML DOC
    #|[[fruit]]
    #|  name = "apple"
    #|
    #|  [[fruit.variety]]
    #|    name = "red delicious"
    #|
    #|  # This table conflicts with the previous table
    #|  [fruit.variety]
    #|    name = "granny smith"
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/datetime/hour-over" {
  let toml_text =
    #|# time-hour       = 2DIGIT  ; 00-23
    #|d = 2006-01-01T24:00:00-00:00
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/datetime/offset-minus-minute-1digit" {
  let toml_text =
    #|foo = 1997-09-09T09:09:09.09+09:9
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/datetime/offset-minus-no-hour-minute-sep" {
  let toml_text =
    #|foo = 1997-09-09T09:09:09.09+0909
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/datetime/offset-minus-no-hour-minute" {
  let toml_text =
    #|foo = 1997-09-09T09:09:09.09+
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/datetime/offset-minus-no-minute" {
  let toml_text =
    #|foo = 1997-09-09T09:09:09.09+09
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/datetime/offset-overflow-hour" {
  let toml_text =
    #|# RFC 3339 time-numoffset uses time-hour, which is 00-23
    #|d = 1985-06-18 17:04:07+25:00
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/datetime/offset-overflow-minute" {
  let toml_text =
    #|d = 1985-06-18 17:04:07+12:60
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/datetime/offset-plus-minute-1digit" {
  let toml_text =
    #|foo = 1997-09-09T09:09:09.09+09:9
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/datetime/offset-plus-no-hour-minute-sep" {
  let toml_text =
    #|foo = 1997-09-09T09:09:09.09+0909
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/datetime/offset-plus-no-hour-minute" {
  let toml_text =
    #|foo = 1997-09-09T09:09:09.09+
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/inline-table/duplicate-key-04" {
  let toml_text =
    #|tbl = { a.b = "a_b", a.b.c = "a_b_c" }
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/key/dotted-redefine-table-01" {
  let toml_text =
    #|a = false
    #|a.b = true
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/key/dotted-redefine-table-02" {
  let toml_text =
    #|# Defined a.b as int
    #|a.b = 1
    #|# Tries to access it as table: error
    #|a.b.c = 2
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/key/duplicate-keys-01" {
  let toml_text =
    #|name = "Tom"
    #|name = "Pradyun"
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/key/duplicate-keys-02" {
  let toml_text =
    #|dupe = false
    #|dupe = true
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/key/duplicate-keys-03" {
  let toml_text =
    #|spelling   = "favorite"
    #|"spelling" = "favourite"
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/key/duplicate-keys-04" {
  let toml_text =
    #|spelling   = "favorite"
    #|'spelling' = "favourite"
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/key/duplicate-keys-05" {
  let toml_text =
    #|a        = 1
    #|"\u0061" = 1
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/key/duplicate-keys-06" {
  let toml_text =
    #|"a'b"      = 1
    #|"a\u0027b" = 2
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/key/duplicate-keys-07" {
  let toml_text =
    #|"" = 1
    #|"" = 2
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/key/duplicate-keys-08" {
  let toml_text =
    #|arr = [1]
    #|arr = [2]
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/key/duplicate-keys-09" {
  let toml_text =
    #|tbl = {k=1}
    #|tbl = {kk=2}
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/local-date/y10k" {
  let toml_text =
    #|# Maximum RFC3399 year is 9999.
    #|d = 10000-01-01
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/local-datetime/feb-29" {
  let toml_text =
    #|"not a leap year" = 2100-02-29T15:15:15
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/local-datetime/feb-30" {
  let toml_text =
    #|"only 28 or 29 days in february" = 1988-02-30T15:15:15
    #|
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/local-datetime/hour-over" {
  let toml_text =
    #|# time-hour       = 2DIGIT  ; 00-23
    #|d = 2006-01-01T24:00:00
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/local-datetime/mday-over" {
  let toml_text =
    #|# date-mday       = 2DIGIT  ; 01-28, 01-29, 01-30, 01-31 based on
    #|#                           ; month/year
    #|d = 2006-01-32T00:00:00
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/local-datetime/mday-under" {
  let toml_text =
    #|# date-mday       = 2DIGIT  ; 01-28, 01-29, 01-30, 01-31 based on
    #|#                           ; month/year
    #|d = 2006-01-00T00:00:00
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/local-datetime/y10k" {
  let toml_text =
    #|# Maximum RFC3399 year is 9999.
    #|d = 10000-01-01 00:00:00
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/spec-1.0.0/inline-table-2-0" {
  let toml_text =
    #|[product]
    #|type = { name = "Nail" }
    #|type.edible = false  # INVALID
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/spec-1.0.0/inline-table-3-0" {
  let toml_text =
    #|[product]
    #|type.name = "Nail"
    #|type = { edible = false }  # INVALID
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/spec-1.0.0/key-value-pair-1" {
  let toml_text =
    #|key = # INVALID
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/spec-1.0.0/keys-2" {
  let toml_text =
    #|= "no key name"  # INVALID
    #|"" = "blank"     # VALID but discouraged
    #|'' = 'blank'     # VALID but discouraged
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/spec-1.0.0/string-4-0" {
  let toml_text =
    #|str4 = """Here are two quotation marks: "". Simple enough."""
    #|str5 = """Here are three quotation marks: """."""  # INVALID
    #|str5 = """Here are three quotation marks: ""\"."""
    #|str6 = """Here are fifteen quotation marks: ""\"""\"""\"""\"""\"."""
    #|
    #|# "This," she said, "is just a pointless statement."
    #|str7 = """"This," she said, "is just a pointless statement.""""
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/spec-1.0.0/string-7-0" {
  let toml_text =
    #|quot15 = '''Here are fifteen quotation marks: """""""""""""""'''
    #|
    #|apos15 = '''Here are fifteen apostrophes: ''''''''''''''''''  # INVALID
    #|apos15 = "Here are fifteen apostrophes: '''''''''''''''"
    #|
    #|# 'That,' she said, 'is still pointless.'
    #|str = ''''That,' she said, 'is still pointless.''''
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/spec-1.0.0/table-9-0" {
  let toml_text =
    #|[fruit]
    #|apple.color = "red"
    #|apple.taste.sweet = true
    #|
    #|[fruit.apple]  # INVALID
    #|# [fruit.apple.taste]  # INVALID
    #|
    #|[fruit.apple.texture]  # you can add sub-tables
    #|smooth = true
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/spec-1.0.0/table-9-1" {
  let toml_text =
    #|[fruit]
    #|apple.color = "red"
    #|apple.taste.sweet = true
    #|
    #|# [fruit.apple]  # INVALID
    #|[fruit.apple.taste]  # INVALID
    #|
    #|[fruit.apple.texture]  # you can add sub-tables
    #|smooth = true
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/spec-1.1.0/common-16-0" {
  let toml_text =
    #|str4 = """Here are two quotation marks: "". Simple enough."""
    #|str5 = """Here are three quotation marks: """."""  # INVALID
    #|str5 = """Here are three quotation marks: ""\"."""
    #|str6 = """Here are fifteen quotation marks: ""\"""\"""\"""\"""\"."""
    #|
    #|# "This," she said, "is just a pointless statement."
    #|str7 = """"This," she said, "is just a pointless statement.""""
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/spec-1.1.0/common-19-0" {
  let toml_text =
    #|quot15 = '''Here are fifteen quotation marks: """""""""""""""'''
    #|
    #|apos15 = '''Here are fifteen apostrophes: ''''''''''''''''''  # INVALID
    #|apos15 = "Here are fifteen apostrophes: '''''''''''''''"
    #|
    #|# 'That,' she said, 'is still pointless.'
    #|str = ''''That,' she said, 'is still pointless.''''
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/spec-1.1.0/common-2" {
  let toml_text =
    #|key = # INVALID
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/spec-1.1.0/common-46-0" {
  let toml_text =
    #|[fruit]
    #|apple.color = "red"
    #|apple.taste.sweet = true
    #|
    #|[fruit.apple]  # INVALID
    #|# [fruit.apple.taste]  # INVALID
    #|
    #|[fruit.apple.texture]  # you can add sub-tables
    #|smooth = true
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/spec-1.1.0/common-46-1" {
  let toml_text =
    #|[fruit]
    #|apple.color = "red"
    #|apple.taste.sweet = true
    #|
    #|# [fruit.apple]  # INVALID
    #|[fruit.apple.taste]  # INVALID
    #|
    #|[fruit.apple.texture]  # you can add sub-tables
    #|smooth = true
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/spec-1.1.0/common-49-0" {
  let toml_text =
    #|[product]
    #|type = { name = "Nail" }
    #|type.edible = false  # INVALID
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/spec-1.1.0/common-50-0" {
  let toml_text =
    #|[product]
    #|type.name = "Nail"
    #|type = { edible = false }  # INVALID
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/spec-1.1.0/common-5" {
  let toml_text =
    #|= "no key name"           # INVALID
    #|"""key""" = "not allowed" # INVALID
    #|"" = "blank"              # VALID but discouraged
    #|'' = 'blank'              # VALID but discouraged
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/string/literal-multiline-quotes-01" {
  let toml_text =
    #|a = '''6 apostrophes: ''''''
    #|
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/string/literal-multiline-quotes-02" {
  let toml_text =
    #|a = '''15 apostrophes: ''''''''''''''''''
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/string/multiline-lit-no-close-01" {
  let toml_text =
    #|invalid = '''
    #|    this will fail
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/string/multiline-lit-no-close-02" {
  let toml_text =
    #|x='''
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/string/multiline-lit-no-close-03" {
  let toml_text =
    #|not-closed= '''
    #|diibaa
    #|blibae ete
    #|eteta
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/string/multiline-lit-no-close-04" {
  let toml_text =
    #|bee = '''
    #|hee
    #|gee ''
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/string/multiline-no-close-01" {
  let toml_text =
    #|invalid = """
    #|    this will fail
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/string/multiline-no-close-02" {
  let toml_text =
    #|x="""
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/string/multiline-no-close-03" {
  let toml_text =
    #|not-closed= """
    #|diibaa
    #|blibae ete
    #|eteta
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/string/multiline-no-close-04" {
  let toml_text =
    #|bee = """
    #|hee
    #|gee ""
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/string/multiline-no-close-05" {
  let toml_text =
    #|bee = """
    #|hee
    #|gee\	 
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/string/multiline-quotes-01" {
  let toml_text =
    #|a = """6 quotes: """"""
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/table/overwrite-array-in-parent" {
  let toml_text =
    #|[[parent-table.arr]]
    #|[parent-table]
    #|not-arr = 1
    #|arr = 2
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/table/overwrite-bool-with-array" {
  let toml_text =
    #|a=true
    #|[[a]]
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/table/overwrite-with-deep-table" {
  let toml_text =
    #|a=1
    #|[a.b.c.d]
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/table/redefine-01" {
  let toml_text =
    #|# Define b as int, and try to use it as a table: error
    #|[a]
    #|b = 1
    #|
    #|[a.b]
    #|c = 2
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/table/redefine-02" {
  let toml_text =
    #|[t1]
    #|t2.t3.v = 0
    #|[t1.t2]
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/table/redefine-03" {
  let toml_text =
    #|[t1]
    #|t2.t3.v = 0
    #|[t1.t2.t3]
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "valid/integer/integer" {
  let toml_text =
    #|answer = 42
    #|posanswer = +42
    #|neganswer = -42
    #|zero = 0
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "answer": Integer(42),
    "neganswer": Integer(-42),
    "posanswer": Integer(42),
    "zero": Integer(0),
  })
}

///|
test "valid/integer/literals" {
  let toml_text =
    #|bin1 = 0b11010110
    #|bin2 = 0b1_0_1
    #|
    #|oct1 = 0o01234567
    #|oct2 = 0o755
    #|oct3 = 0o7_6_5
    #|
    #|hex1 = 0xDEADBEEF
    #|hex2 = 0xdeadbeef
    #|hex3 = 0xdead_beef
    #|hex4 = 0x00987
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "bin1": Integer(214),
    "bin2": Integer(5),
    "hex1": Integer(3735928559),
    "hex2": Integer(3735928559),
    "hex3": Integer(3735928559),
    "hex4": Integer(2439),
    "oct1": Integer(342391),
    "oct2": Integer(493),
    "oct3": Integer(501),
  })
}

///|
test "valid/integer/long" {
  let toml_text =
    #|# int64 "should" be supported, but is not mandatory. It's fine to skip this
    #|# test.
    #|int64-max     = 9223372036854775807
    #|int64-max-neg = -9223372036854775808
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "int64-max": Integer(9223372036854775807),
    "int64-max-neg": Integer(-9223372036854775808),
  })
}

///|
test "valid/integer/underscore" {
  let toml_text =
    #|kilo = 1_000
    #|x = 1_1_1_1
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, { "kilo": Integer(1000), "x": Integer(1111) })
}

///|
test "valid/integer/zero" {
  let toml_text =
    #|d1 = 0
    #|d2 = +0
    #|d3 = -0
    #|
    #|h1 = 0x0
    #|h2 = 0x00
    #|h3 = 0x00000
    #|
    #|o1 = 0o0
    #|a2 = 0o00
    #|a3 = 0o00000
    #|
    #|b1 = 0b0
    #|b2 = 0b00
    #|b3 = 0b00000
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "a2": Integer(0),
    "a3": Integer(0),
    "b1": Integer(0),
    "b2": Integer(0),
    "b3": Integer(0),
    "d1": Integer(0),
    "d2": Integer(0),
    "d3": Integer(0),
    "h1": Integer(0),
    "h2": Integer(0),
    "h3": Integer(0),
    "o1": Integer(0),
  })
}

///|
test "valid/key/alphanum" {
  let toml_text =
    #|alpha = "a"
    #|123 = "num"
    #|000111 = "leading"
    #|10e3 = "false float"
    #|one1two2 = "mixed"
    #|with-dash = "dashed"
    #|under_score = "___"
    #|34-11 = 23
    #|
    #|[2018_10]
    #|001 = 1
    #|
    #|[a-a-a]
    #|_ = false
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "000111": String("leading"),
    "10e3": String("false float"),
    "123": String("num"),
    "2018_10": Table({ "001": Integer(1) }),
    "34-11": Integer(23),
    "a-a-a": Table({ "_": Bool(false) }),
    "alpha": String("a"),
    "one1two2": String("mixed"),
    "under_score": String("___"),
    "with-dash": String("dashed"),
  })
}

///|
test "valid/key/case-sensitive" {
  let toml_text =
    #|sectioN = "NN"
    #|
    #|[section]
    #|name = "lower"
    #|NAME = "upper"
    #|Name = "capitalized"
    #|
    #|[Section]
    #|name = "different section!!"
    #|"μ" = "greek small letter mu"
    #|"Μ" = "greek capital letter MU"
    #|M = "latin letter M"
    #|
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "Section": Table({
      "M": String("latin letter M"),
      "name": String("different section!!"),
      "Μ": String("greek capital letter MU"),
      "μ": String("greek small letter mu"),
    }),
    "sectioN": String("NN"),
    "section": Table({
      "NAME": String("upper"),
      "Name": String("capitalized"),
      "name": String("lower"),
    }),
  })
}

///|
test "valid/key/empty-01" {
  let toml_text =
    #|"" = "blank"
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, { "": String("blank") })
}

///|
test "valid/key/empty-02" {
  let toml_text =
    #|'' = "blank"
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, { "": String("blank") })
}

///|
test "valid/key/empty-03" {
  let toml_text =
    #|''=0
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, { "": Integer(0) })
}

///|
test "valid/key/equals-nospace" {
  let toml_text =
    #|answer=42
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, { "answer": Integer(42) })
}

///|
test "valid/key/like-date" {
  let toml_text =
    #|# '-' is a valid character in keys: make a key that looks like a date.
    #|2001-02-03   = 1
    #|"2001-02-04" = 2
    #|'2001-02-05' = 3
    #|
    #|# Also include datetime and time for good measure; these need to be quoted as
    #|# ':' isn't a valid bare key.
    #|"2001-02-06T15:16:17+01:00" = 4
    #|"2001-02-07T15:16:17"       = 5
    #|"15:16:17"                  = 6
    #|
    #|# Dotted keys
    #|a.2001-02-08 = 7
    #|a.2001-02-09.2001-02-10 = 8
    #|2001-02-11.a.2001-02-12 = 9
    #|
    #|# Table names
    #|[2002-01-02]
    #|k = 10
    #|
    #|[2002-01-02.2024-01-03]
    #|k = 11
    #|
    #|[[2002-01-04]]
    #|k = 12
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "15:16:17": Integer(6),
    "2001-02-03": Integer(1),
    "2001-02-04": Integer(2),
    "2001-02-05": Integer(3),
    "2001-02-06T15:16:17+01:00": Integer(4),
    "2001-02-07T15:16:17": Integer(5),
    "2001-02-11": Table({ "a": Table({ "2001-02-12": Integer(9) }) }),
    "2002-01-02": Table({
      "2024-01-03": Table({ "k": Integer(11) }),
      "k": Integer(10),
    }),
    "2002-01-04": Array([Table({ "k": Integer(12) })]),
    "a": Table({
      "2001-02-08": Integer(7),
      "2001-02-09": Table({ "2001-02-10": Integer(8) }),
    }),
  })
}

///|
test "valid/key/numeric-01" {
  let toml_text =
    #|1     = true
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, { "1": Bool(true) })
}

///|
test "valid/key/numeric-02" {
  let toml_text =
    #|1.2   = true
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, { "1": Table({ "2": Bool(true) }) })
}

///|
test "valid/key/numeric-03" {
  let toml_text =
    #|0123  = true
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, { "0123": Bool(true) })
}

///|
test "valid/key/numeric-04" {
  let toml_text =
    #|01.23 = true
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, { "01": Table({ "23": Bool(true) }) })
}

///|
test "valid/key/numeric-05" {
  let toml_text =
    #|23.01 = true
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, { "23": Table({ "01": Bool(true) }) })
}

///|
test "valid/key/numeric-06" {
  let toml_text =
    #|-1    = true
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, { "-1": Bool(true) })
}

///|
test "valid/key/numeric-07" {
  let toml_text =
    #|-01   = true
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, { "-01": Bool(true) })
}

///|
test "valid/key/numeric-08" {
  let toml_text =
    #|1  = 'one'
    #|01 = 'zero one'
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, { "01": String("zero one"), "1": String("one") })
}

///|
test "valid/key/space" {
  let toml_text =
    #|# Keep whitespace inside quotes keys at all positions.
    #|"a b"   = 1
    #|" c d " = 2
    #|"  much 		  whitespace  	\n  \r\n  " = 3
    #|
    #|[ " tbl " ]
    #|"\ttab\ttab\t" = "tab"
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "  much \t\t  whitespace  \t\n  \r\n  ": Integer(3),
    " c d ": Integer(2),
    " tbl ": Table({ "\ttab\ttab\t": String("tab") }),
    "a b": Integer(1),
  })
}

///|
test "valid/key/special-chars" {
  let toml_text =
    #|"=~!@$^&*()_+-`1234567890[]|/?><.,;:'=" = 1
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, { "=~!@$^&*()_+-`1234567890[]|/?><.,;:'=": Integer(1) })
}

///|
test "valid/key/special-word" {
  let toml_text =
    #|false = false
    #|true = 1
    #|inf = 100000000
    #|nan = "ceci n'est pas un nombre"
    #|
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "false": Bool(false),
    "inf": Integer(100000000),
    "nan": String("ceci n'est pas un nombre"),
    "true": Integer(1),
  })
}

///|
test "valid/key/start" {
  let toml_text =
    #|# Table and keys can start with any character; there is no requirement for it to
    #|# start with a letter.
    #|
    #|[-key]
    #|-key = 1
    #|
    #|[_key]
    #|_key = 2
    #|
    #|[1key]
    #|1key = 3
    #|
    #|[-]
    #|- = 4
    #|
    #|[_]
    #|_ = 5
    #|
    #|[1] 
    #|1 = 6
    #|
    #|[---] 
    #|--- = 7
    #|
    #|[___]
    #|___ = 8
    #|
    #|[111]
    #|111 = 9
    #|
    #|[inline]
    #|--- = {--- = 10, ___ = 11, 111 = 12}
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "-": Table({ "-": Integer(4) }),
    "---": Table({ "---": Integer(7) }),
    "-key": Table({ "-key": Integer(1) }),
    "1": Table({ "1": Integer(6) }),
    "111": Table({ "111": Integer(9) }),
    "1key": Table({ "1key": Integer(3) }),
    "_": Table({ "_": Integer(5) }),
    "___": Table({ "___": Integer(8) }),
    "_key": Table({ "_key": Integer(2) }),
    "inline": Table({
      "---": Table({
        "---": Integer(10),
        "111": Integer(12),
        "___": Integer(11),
      }),
    }),
  })
}

///|
test "valid/key/zero" {
  let toml_text =
    #|0=0
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, { "0": Integer(0) })
}

///|
test "valid/multibyte" {
  let toml_text =
    #|# Test multibyte throughout
    #|
    #|# Tèƨƭ ƒïℓè ƒôř TÓM£
    #|# Óñℓ¥ ƭλïƨ ôñè ƭřïèƨ ƭô è₥úℓáƭè á TÓM£ ƒïℓè ωřïƭƭèñ β¥ á úƨèř ôƒ ƭλè ƙïñδ ôƒ ƥářƨèř ωřïƭèřƨ ƥřôβáβℓ¥ λáƭè
    #|
    #|['𝐭𝐛𝐥']
    #|string = "𝓼𝓽𝓻𝓲𝓷𝓰 - #"          # " 𝓼𝓽𝓻𝓲𝓷𝓰
    #|	['𝐭𝐛𝐥'.sub]
    #|	'𝕒𝕣𝕣𝕒𝕪' = [ "] ", " # "]      # ] 𝓪𝓻𝓻𝓪𝔂
    #|	'𝕒𝕣𝕣𝕒𝕪𝟚' = [ "Tèƨƭ #11 ]ƥřôƲèδ ƭλáƭ", "Éжƥèřï₥èñƭ #9 ωáƨ á ƨúççèƨƨ" ]
    #|	# Ýôú δïδñ'ƭ ƭλïñƙ ïƭ'δ áƨ èáƨ¥ áƨ çλúçƙïñϱ ôúƭ ƭλè ℓáƨƭ #, δïδ ¥ôú?
    #|	another_test_string = "§á₥è ƭλïñϱ, βúƭ ωïƭλ á ƨƭřïñϱ #"
    #|	escapes = " Âñδ ωλèñ \"'ƨ ářè ïñ ƭλè ƨƭřïñϱ, áℓôñϱ ωïƭλ # \""   # "áñδ çô₥₥èñƭƨ ářè ƭλèřè ƭôô"
    #|	# Tλïñϱƨ ωïℓℓ ϱèƭ λářδèř
    #|		['𝐭𝐛𝐥'.sub."βïƭ#"]
    #|		"ωλáƭ?" = "Ýôú δôñ'ƭ ƭλïñƙ ƨô₥è úƨèř ωôñ'ƭ δô ƭλáƭ?"
    #|		multi_line_array = [
    #|			"]",
    #|			# ] Óλ ¥èƨ Ì δïδ
    #|			]
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "𝐭𝐛𝐥": Table({
      "string": String("𝓼𝓽𝓻𝓲𝓷𝓰 - #"),
      "sub": Table({
        "another_test_string": String(
          "§á₥è ƭλïñϱ, βúƭ ωïƭλ á ƨƭřïñϱ #",
        ),
        "escapes": String(
          " Âñδ ωλèñ \"'ƨ ářè ïñ ƭλè ƨƭřïñϱ, áℓôñϱ ωïƭλ # \"",
        ),
        "βïƭ#": Table({
          "multi_line_array": Array([String("]")]),
          "ωλáƭ?": String(
            "Ýôú δôñ'ƭ ƭλïñƙ ƨô₥è úƨèř ωôñ'ƭ δô ƭλáƭ?",
          ),
        }),
        "𝕒𝕣𝕣𝕒𝕪": Array([String("] "), String(" # ")]),
        "𝕒𝕣𝕣𝕒𝕪𝟚": Array([
          String("Tèƨƭ #11 ]ƥřôƲèδ ƭλáƭ"),
          String("Éжƥèřï₥èñƭ #9 ωáƨ á ƨúççèƨƨ"),
        ]),
      }),
    }),
  })
}

///|
test "valid/newline-crlf" {
  let toml_text = "os = \"DOS\"\r\nnewline = \"crlf\"\r\n"
  let toml = @toml.parse(toml_text)
  assert_eq(toml, { "newline": String("crlf"), "os": String("DOS") })
}

///|
test "valid/newline-lf" {
  let toml_text =
    #|os = "unix"
    #|newline = "lf"
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, { "newline": String("lf"), "os": String("unix") })
}

///|
test "valid/spec-1.0.0/boolean-0" {
  let toml_text =
    #|bool1 = true
    #|bool2 = false
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, { "bool1": Bool(true), "bool2": Bool(false) })
}

///|
test "valid/spec-1.0.0/comment-0" {
  let toml_text =
    #|# This is a full-line comment
    #|key = "value"  # This is a comment at the end of a line
    #|another = "# This is not a comment"
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "another": String("# This is not a comment"),
    "key": String("value"),
  })
}

///|
test "valid/spec-1.0.0/integer-0" {
  let toml_text =
    #|int1 = +99
    #|int2 = 42
    #|int3 = 0
    #|int4 = -17
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "int1": Integer(99),
    "int2": Integer(42),
    "int3": Integer(0),
    "int4": Integer(-17),
  })
}

///|
test "valid/spec-1.0.0/integer-1" {
  let toml_text =
    #|int5 = 1_000
    #|int6 = 5_349_221
    #|int7 = 53_49_221  # Indian number system grouping
    #|int8 = 1_2_3_4_5  # VALID but discouraged
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "int5": Integer(1000),
    "int6": Integer(5349221),
    "int7": Integer(5349221),
    "int8": Integer(12345),
  })
}

///|
test "valid/spec-1.0.0/integer-2" {
  let toml_text =
    #|# hexadecimal with prefix `0x`
    #|hex1 = 0xDEADBEEF
    #|hex2 = 0xdeadbeef
    #|hex3 = 0xdead_beef
    #|
    #|# octal with prefix `0o`
    #|oct1 = 0o01234567
    #|oct2 = 0o755 # useful for Unix file permissions
    #|
    #|# binary with prefix `0b`
    #|bin1 = 0b11010110
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "bin1": Integer(214),
    "hex1": Integer(3735928559),
    "hex2": Integer(3735928559),
    "hex3": Integer(3735928559),
    "oct1": Integer(342391),
    "oct2": Integer(493),
  })
}

///|
test "valid/spec-1.0.0/key-value-pair-0" {
  let toml_text =
    #|key = "value"
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, { "key": String("value") })
}

///|
test "valid/spec-1.0.0/keys-0" {
  let toml_text =
    #|key = "value"
    #|bare_key = "value"
    #|bare-key = "value"
    #|1234 = "value"
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "1234": String("value"),
    "bare-key": String("value"),
    "bare_key": String("value"),
    "key": String("value"),
  })
}

///|
test "valid/spec-1.0.0/keys-1" {
  let toml_text =
    #|"127.0.0.1" = "value"
    #|"character encoding" = "value"
    #|"ʎǝʞ" = "value"
    #|'key2' = "value"
    #|'quoted "value"' = "value"
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "127.0.0.1": String("value"),
    "character encoding": String("value"),
    "key2": String("value"),
    "quoted \"value\"": String("value"),
    "ʎǝʞ": String("value"),
  })
}

///|
test "valid/spec-1.0.0/local-date-0" {
  let toml_text =
    #|ld1 = 1979-05-27
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, { "ld1": LocalDate({ year: 1979, month: 5, day: 27, }) })
}

///|
test "valid/spec-1.0.0/local-date-time-0" {
  let toml_text =
    #|ldt1 = 1979-05-27T07:32:00
    #|ldt2 = 1979-05-27T00:32:00.999
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "ldt1": LocalDatetime({ year: 1979, month: 5, day: 27, }, {
      hour: 7,
      minute: 32,
      second: 0,
      nanosecond: 0,
    }),
    "ldt2": LocalDatetime({ year: 1979, month: 5, day: 27, }, {
      hour: 0,
      minute: 32,
      second: 0,
      nanosecond: 999000000,
    }),
  })
}

///|
test "valid/spec-1.0.0/local-time-0" {
  let toml_text =
    #|lt1 = 07:32:00
    #|lt2 = 00:32:00.999
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "lt1": LocalTime({ hour: 7, minute: 32, second: 0, nanosecond: 0, }),
    "lt2": LocalTime({ hour: 0, minute: 32, second: 0, nanosecond: 999000000, }),
  })
}

///|
test "valid/spec-1.0.0/offset-date-time-0" {
  let toml_text =
    #|odt1 = 1979-05-27T07:32:00Z
    #|odt2 = 1979-05-27T00:32:00-07:00
    #|odt3 = 1979-05-27T00:32:00.999-07:00
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "odt1": Datetime(
      { year: 1979, month: 5, day: 27, },
      { hour: 7, minute: 32, second: 0, nanosecond: 0, },
      offset=0,
    ),
    "odt2": Datetime(
      { year: 1979, month: 5, day: 27, },
      { hour: 0, minute: 32, second: 0, nanosecond: 0, },
      offset=-420,
    ),
    "odt3": Datetime(
      { year: 1979, month: 5, day: 27, },
      { hour: 0, minute: 32, second: 0, nanosecond: 999000000, },
      offset=-420,
    ),
  })
}

///|
test "valid/spec-1.0.0/string-0" {
  let toml_text =
    #|str = "I'm a string. \"You can quote me\". Name\tJos\u00E9\nLocation\tSF."
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "str": String(
      "I'm a string. \"You can quote me\". Name\tJosé\nLocation\tSF.",
    ),
  })
}

///|
test "valid/spec-1.0.0/string-1" {
  let toml_text =
    #|str1 = """
    #|Roses are red
    #|Violets are blue"""
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, { "str1": String("Roses are red\nViolets are blue") })
}

///|
test "valid/spec-1.0.0/string-2" {
  let toml_text =
    #|# On a Unix system, the above multi-line string will most likely be the same as:
    #|str2 = "Roses are red\nViolets are blue"
    #|
    #|# On a Windows system, it will most likely be equivalent to:
    #|str3 = "Roses are red\r\nViolets are blue"
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "str2": String("Roses are red\nViolets are blue"),
    "str3": String("Roses are red\r\nViolets are blue"),
  })
}

///|
test "valid/spec-1.0.0/string-3" {
  let toml_text =
    #|# The following strings are byte-for-byte equivalent:
    #|str1 = "The quick brown fox jumps over the lazy dog."
    #|
    #|str2 = """
    #|The quick brown \
    #|
    #|
    #|  fox jumps over \
    #|    the lazy dog."""
    #|
    #|str3 = """\
    #|       The quick brown \
    #|       fox jumps over \
    #|       the lazy dog.\
    #|       """
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "str1": String("The quick brown fox jumps over the lazy dog."),
    "str2": String("The quick brown fox jumps over the lazy dog."),
    "str3": String("The quick brown fox jumps over the lazy dog."),
  })
}

///|
test "valid/spec-1.0.0/string-4" {
  let toml_text =
    #|str4 = """Here are two quotation marks: "". Simple enough."""
    #|# str5 = """Here are three quotation marks: """."""  # INVALID
    #|str5 = """Here are three quotation marks: ""\"."""
    #|str6 = """Here are fifteen quotation marks: ""\"""\"""\"""\"""\"."""
    #|
    #|# "This," she said, "is just a pointless statement."
    #|str7 = """"This," she said, "is just a pointless statement.""""
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "str4": String("Here are two quotation marks: \"\". Simple enough."),
    "str5": String("Here are three quotation marks: \"\"\"."),
    "str6": String(
      "Here are fifteen quotation marks: \"\"\"\"\"\"\"\"\"\"\"\"\"\"\".",
    ),
    "str7": String("\"This,\" she said, \"is just a pointless statement.\""),
  })
}

///|
test "valid/spec-1.0.0/string-5" {
  let toml_text =
    #|# What you see is what you get.
    #|winpath  = 'C:\Users\nodejs\templates'
    #|winpath2 = '\\ServerX\admin$\system32\'
    #|quoted   = 'Tom "Dubs" Preston-Werner'
    #|regex    = '<\i\c*\s*>'
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "quoted": String("Tom \"Dubs\" Preston-Werner"),
    "regex": String("<\\i\\c*\\s*>"),
    "winpath": String("C:\\Users\\nodejs\\templates"),
    "winpath2": String("\\\\ServerX\\admin$\\system32\\"),
  })
}

///|
test "valid/spec-1.0.0/string-6" {
  let toml_text =
    #|regex2 = '''I [dw]on't need \d{2} apples'''
    #|lines  = '''
    #|The first newline is
    #|trimmed in raw strings.
    #|   All other whitespace
    #|   is preserved.
    #|'''
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "lines": String(
      "The first newline is\ntrimmed in raw strings.\n   All other whitespace\n   is preserved.\n",
    ),
    "regex2": String("I [dw]on't need \\d{2} apples"),
  })
}

///|
test "valid/spec-1.0.0/string-7" {
  let toml_text =
    #|quot15 = '''Here are fifteen quotation marks: """""""""""""""'''
    #|
    #|# apos15 = '''Here are fifteen apostrophes: ''''''''''''''''''  # INVALID
    #|apos15 = "Here are fifteen apostrophes: '''''''''''''''"
    #|
    #|# 'That,' she said, 'is still pointless.'
    #|str = ''''That,' she said, 'is still pointless.''''
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "apos15": String("Here are fifteen apostrophes: '''''''''''''''"),
    "quot15": String(
      "Here are fifteen quotation marks: \"\"\"\"\"\"\"\"\"\"\"\"\"\"\"",
    ),
    "str": String("'That,' she said, 'is still pointless.'"),
  })
}

///|
test "valid/spec-1.1.0/common-27" {
  let toml_text =
    #|odt1 = 1979-05-27T07:32:00Z
    #|odt2 = 1979-05-27T00:32:00-07:00
    #|odt3 = 1979-05-27T00:32:00.5-07:00
    #|odt4 = 1979-05-27T00:32:00.999-07:00
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "odt1": Datetime(
      { year: 1979, month: 5, day: 27, },
      { hour: 7, minute: 32, second: 0, nanosecond: 0, },
      offset=0,
    ),
    "odt2": Datetime(
      { year: 1979, month: 5, day: 27, },
      { hour: 0, minute: 32, second: 0, nanosecond: 0, },
      offset=-420,
    ),
    "odt3": Datetime(
      { year: 1979, month: 5, day: 27, },
      { hour: 0, minute: 32, second: 0, nanosecond: 500000000, },
      offset=-420,
    ),
    "odt4": Datetime(
      { year: 1979, month: 5, day: 27, },
      { hour: 0, minute: 32, second: 0, nanosecond: 999000000, },
      offset=-420,
    ),
  })
}

///|
test "valid/spec-1.1.0/common-28" {
  let toml_text =
    #|odt4 = 1979-05-27 07:32:00Z
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "odt4": Datetime(
      { year: 1979, month: 5, day: 27, },
      { hour: 7, minute: 32, second: 0, nanosecond: 0, },
      offset=0,
    ),
  })
}

///|
test "valid/spec-1.1.0/common-30" {
  let toml_text =
    #|ldt1 = 1979-05-27T07:32:00
    #|ldt2 = 1979-05-27T07:32:00.5
    #|ldt3 = 1979-05-27T00:32:00.999
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "ldt1": LocalDatetime({ year: 1979, month: 5, day: 27, }, {
      hour: 7,
      minute: 32,
      second: 0,
      nanosecond: 0,
    }),
    "ldt2": LocalDatetime({ year: 1979, month: 5, day: 27, }, {
      hour: 7,
      minute: 32,
      second: 0,
      nanosecond: 500000000,
    }),
    "ldt3": LocalDatetime({ year: 1979, month: 5, day: 27, }, {
      hour: 0,
      minute: 32,
      second: 0,
      nanosecond: 999000000,
    }),
  })
}

///|
test "valid/spec-1.1.0/common-32" {
  let toml_text =
    #|ld1 = 1979-05-27
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, { "ld1": LocalDate({ year: 1979, month: 5, day: 27, }) })
}

///|
test "valid/spec-1.1.0/common-33" {
  let toml_text =
    #|lt1 = 07:32:00
    #|lt2 = 00:32:00.5
    #|lt3 = 00:32:00.999
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "lt1": LocalTime({ hour: 7, minute: 32, second: 0, nanosecond: 0, }),
    "lt2": LocalTime({ hour: 0, minute: 32, second: 0, nanosecond: 500000000, }),
    "lt3": LocalTime({ hour: 0, minute: 32, second: 0, nanosecond: 999000000, }),
  })
}

///|
test "valid/spec-1.1.0/common-35" {
  let toml_text =
    #|integers = [ 1, 2, 3 ]
    #|colors = [ "red", "yellow", "green" ]
    #|nested_arrays_of_ints = [ [ 1, 2 ], [3, 4, 5] ]
    #|nested_mixed_array = [ [ 1, 2 ], ["a", "b", "c"] ]
    #|string_array = [ "all", 'strings', """are the same""", '''type''' ]
    #|
    #|# Mixed-type arrays are allowed
    #|numbers = [ 0.1, 0.2, 0.5, 1, 2, 5 ]
    #|contributors = [
    #|  "Foo Bar <foo@example.com>",
    #|  { name = "Baz Qux", email = "bazqux@example.com", url = "https://example.com/bazqux" }
    #|]
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "colors": Array([String("red"), String("yellow"), String("green")]),
    "contributors": Array([
      String("Foo Bar <foo@example.com>"),
      Table({
        "email": String("bazqux@example.com"),
        "name": String("Baz Qux"),
        "url": String("https://example.com/bazqux"),
      }),
    ]),
    "integers": Array([Integer(1), Integer(2), Integer(3)]),
    "nested_arrays_of_ints": Array([
      Array([Integer(1), Integer(2)]),
      Array([Integer(3), Integer(4), Integer(5)]),
    ]),
    "nested_mixed_array": Array([
      Array([Integer(1), Integer(2)]),
      Array([String("a"), String("b"), String("c")]),
    ]),
    "numbers": Array([
      Float(0.1),
      Float(0.2),
      Float(0.5),
      Integer(1),
      Integer(2),
      Integer(5),
    ]),
    "string_array": Array([
      String("all"),
      String("strings"),
      String("are the same"),
      String("type"),
    ]),
  })
}

///|
test "valid/spec-1.1.0/common-36" {
  let toml_text =
    #|integers2 = [
    #|  1, 2, 3
    #|]
    #|
    #|integers3 = [
    #|  1,
    #|  2, # this is ok
    #|]
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "integers2": Array([Integer(1), Integer(2), Integer(3)]),
    "integers3": Array([Integer(1), Integer(2)]),
  })
}

///|
test "valid/spec-1.1.0/common-3" {
  let toml_text =
    #|key = "value"
    #|bare_key = "value"
    #|bare-key = "value"
    #|1234 = "value"
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "1234": String("value"),
    "bare-key": String("value"),
    "bare_key": String("value"),
    "key": String("value"),
  })
}

///|
test "valid/spec-1.1.0/common-4" {
  let toml_text =
    #|"127.0.0.1" = "value"
    #|"character encoding" = "value"
    #|"ʎǝʞ" = "value"
    #|'key2' = "value"
    #|'quoted "value"' = "value"
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "127.0.0.1": String("value"),
    "character encoding": String("value"),
    "key2": String("value"),
    "quoted \"value\"": String("value"),
    "ʎǝʞ": String("value"),
  })
}

///|
test "valid/spec-1.1.0/common-6" {
  let toml_text =
    #|name = "Orange"
    #|physical.color = "orange"
    #|physical.shape = "round"
    #|site."google.com" = true
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "name": String("Orange"),
    "physical": Table({ "color": String("orange"), "shape": String("round") }),
    "site": Table({ "google.com": Bool(true) }),
  })
}

///|
test "valid/spec-1.1.0/common-7" {
  let toml_text =
    #|fruit.name = "banana"       # this is best practice
    #|fruit. color = "yellow"     # same as fruit.color
    #|fruit . flavor = "banana"   # same as fruit.flavor
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "fruit": Table({
      "color": String("yellow"),
      "flavor": String("banana"),
      "name": String("banana"),
    }),
  })
}

///|
test "valid/spec-1.1.0/common-8" {
  let toml_text =
    #|# This makes the key "fruit" into a table.
    #|fruit.apple.smooth = true
    #|
    #|# So then you can add to the table "fruit" like so:
    #|fruit.orange = 2
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "fruit": Table({
      "apple": Table({ "smooth": Bool(true) }),
      "orange": Integer(2),
    }),
  })
}

///|
test "valid/spec-1.1.0/common-9" {
  let toml_text =
    #|# VALID BUT DISCOURAGED
    #|
    #|apple.type = "fruit"
    #|orange.type = "fruit"
    #|
    #|apple.skin = "thin"
    #|orange.skin = "thick"
    #|
    #|apple.color = "red"
    #|orange.color = "orange"
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "apple": Table({
      "color": String("red"),
      "skin": String("thin"),
      "type": String("fruit"),
    }),
    "orange": Table({
      "color": String("orange"),
      "skin": String("thick"),
      "type": String("fruit"),
    }),
  })
}

///|
test "valid/string/empty" {
  let toml_text =
    #|answer = ""
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, { "answer": String("") })
}

///|
test "valid/string/multiline-empty" {
  let toml_text =
    #|empty-1 = """"""
    #|
    #|# A newline immediately following the opening delimiter will be trimmed.
    #|empty-2 = """
    #|"""
    #|
    #|# \ at the end of line trims newlines as well; note that last \ is followed by
    #|# two spaces, which are ignored.
    #|empty-3 = """\
    #|    """
    #|empty-4 = """\
    #|   \
    #|   \  
    #|   """
    #|
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "empty-1": String(""),
    "empty-2": String(""),
    "empty-3": String(""),
    "empty-4": String(""),
  })
}

///|
test "valid/string/multiline" {
  let toml_text =
    #|# NOTE: this file includes some literal tab characters.
    #|
    #|equivalent_one = "The quick brown fox jumps over the lazy dog."
    #|equivalent_two = """
    #|The quick brown \
    #|
    #|
    #|  fox jumps over \
    #|    the lazy dog."""
    #|
    #|equivalent_three = """\
    #|       The quick brown \
    #|       fox jumps over \
    #|       the lazy dog.\
    #|       """
    #|
    #|whitespace-after-bs = """\
    #|       The quick brown \
    #|       fox jumps over \   
    #|       the lazy dog.\	
    #|       """
    #|
    #|no-space = """a\
    #|    b"""
    #|
    #|# Has tab character.
    #|keep-ws-before = """a   	\
    #|   b"""
    #|
    #|escape-bs-1 = """a \\
    #|b"""
    #|
    #|escape-bs-2 = """a \\\
    #|b"""
    #|
    #|escape-bs-3 = """a \\\\
    #|  b"""
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "equivalent_one": String("The quick brown fox jumps over the lazy dog."),
    "equivalent_three": String("The quick brown fox jumps over the lazy dog."),
    "equivalent_two": String("The quick brown fox jumps over the lazy dog."),
    "escape-bs-1": String("a \\\nb"),
    "escape-bs-2": String("a \\b"),
    "escape-bs-3": String("a \\\\\n  b"),
    "keep-ws-before": String("a   \tb"),
    "no-space": String("ab"),
    "whitespace-after-bs": String(
      "The quick brown fox jumps over the lazy dog.",
    ),
  })
}

///|
test "valid/string/nl" {
  let toml_text =
    #|nl_mid = "val\nue"
    #|nl_end = """value\n"""
    #|
    #|lit_nl_end = '''value\n'''
    #|lit_nl_mid = 'val\nue'
    #|lit_nl_uni = 'val\ue'
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "lit_nl_end": String("value\\n"),
    "lit_nl_mid": String("val\\nue"),
    "lit_nl_uni": String("val\\ue"),
    "nl_end": String("value\n"),
    "nl_mid": String("val\nue"),
  })
}

///|
test "valid/string/raw-empty" {
  let toml_text =
    #|empty = ''
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, { "empty": String("") })
}

///|
test "valid/string/raw" {
  let toml_text =
    #|backspace = 'This string has a \b backspace character.'
    #|tab = 'This string has a \t tab character.'
    #|unescaped_tab = 'This string has an 	 unescaped tab character.'
    #|newline = 'This string has a \n new line character.'
    #|formfeed = 'This string has a \f form feed character.'
    #|carriage = 'This string has a \r carriage return character.'
    #|slash = 'This string has a \/ slash character.'
    #|backslash = 'This string has a \\ backslash character.'
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "backslash": String("This string has a \\\\ backslash character."),
    "backspace": String("This string has a \\b backspace character."),
    "carriage": String("This string has a \\r carriage return character."),
    "formfeed": String("This string has a \\f form feed character."),
    "newline": String("This string has a \\n new line character."),
    "slash": String("This string has a \\/ slash character."),
    "tab": String("This string has a \\t tab character."),
    "unescaped_tab": String("This string has an \t unescaped tab character."),
  })
}

///|
test "valid/string/simple" {
  let toml_text =
    #|answer = "You are not drinking enough whisky."
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, { "answer": String("You are not drinking enough whisky.") })
}

///|
test "valid/string/with-pound" {
  let toml_text =
    #|pound = "We see no # comments here."
    #|poundcomment = "But there are # some comments here." # Did I # mess you up?
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "pound": String("We see no # comments here."),
    "poundcomment": String("But there are # some comments here."),
  })
}

///|
test "valid/table/empty-name" {
  let toml_text =
    #|['']
    #|x = 1
    #|
    #|["".a]
    #|x = 2
    #|
    #|[a.'']
    #|x = 3
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "": Table({ "a": Table({ "x": Integer(2) }), "x": Integer(1) }),
    "a": Table({ "": Table({ "x": Integer(3) }) }),
  })
}

///|
test "valid/table/empty" {
  let toml_text =
    #|[a]
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, { "a": Table(Map([])) })
}

///|
test "valid/table/keyword" {
  let toml_text =
    #|[true]
    #|
    #|[false]
    #|
    #|[inf]
    #|
    #|[nan]
    #|
    #|
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "false": Table(Map([])),
    "inf": Table(Map([])),
    "nan": Table(Map([])),
    "true": Table(Map([])),
  })
}

///|
test "valid/table/names" {
  let toml_text =
    #|[a.b.c]
    #|[a."b.c"]
    #|[a.'d.e']
    #|[a.' x ']
    #|[ d.e.f ]
    #|[ g . h . i ]
    #|[ j . "ʞ" . 'l' ]
    #|
    #|[x.1.2]
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "a": Table({
      " x ": Table(Map([])),
      "b": Table({ "c": Table(Map([])) }),
      "b.c": Table(Map([])),
      "d.e": Table(Map([])),
    }),
    "d": Table({ "e": Table({ "f": Table(Map([])) }) }),
    "g": Table({ "h": Table({ "i": Table(Map([])) }) }),
    "j": Table({ "ʞ": Table({ "l": Table(Map([])) }) }),
    "x": Table({ "1": Table({ "2": Table(Map([])) }) }),
  })
}

///|
test "valid/table/no-eol" {
  let toml_text =
    #|[table]
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, { "table": Table(Map([])) })
}

///|
test "valid/table/sub" {
  let toml_text =
    #|[a]
    #|key = 1
    #|
    #|# a.extend is a key inside the "a" table.
    #|[a.extend]
    #|key = 2
    #|
    #|[a.extend.more]
    #|key = 3
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "a": Table({
      "extend": Table({
        "key": Integer(2),
        "more": Table({ "key": Integer(3) }),
      }),
      "key": Integer(1),
    }),
  })
}

///|
test "valid/table/whitespace" {
  let toml_text =
    #|["valid key"]
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, { "valid key": Table(Map([])) })
}

///|
test "valid/table/with-literal-string" {
  let toml_text =
    #|['a']
    #|[a.'"b"']
    #|[a.'"b"'.c]
    #|answer = 42 
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "a": Table({ "\"b\"": Table({ "c": Table({ "answer": Integer(42) }) }) }),
  })
}

///|
test "valid/table/with-pound" {
  let toml_text =
    #|["key#group"]
    #|answer = 42
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, { "key#group": Table({ "answer": Integer(42) }) })
}

///|
test "valid/table/with-single-quotes" {
  let toml_text =
    #|['a']
    #|[a.'b']
    #|[a.'b'.c]
    #|answer = 42 
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "a": Table({ "b": Table({ "c": Table({ "answer": Integer(42) }) }) }),
  })
}

///|
test "valid/array/array-subtables" {
  let toml_text =
    #|[[arr]]
    #|[arr.subtab]
    #|val=1
    #|
    #|[[arr]]
    #|[arr.subtab]
    #|val=2
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "arr": Array([
      Table({ "subtab": Table({ "val": Integer(1) }) }),
      Table({ "subtab": Table({ "val": Integer(2) }) }),
    ]),
  })
}

///|
test "valid/array/array" {
  let toml_text =
    #|ints = [1, 2, 3, ]
    #|floats = [1.1, 2.1, 3.1]
    #|strings = ["a", "b", "c"]
    #|dates = [
    #|	1987-07-05T17:45:00Z,
    #|	1979-05-27T07:32:00,
    #|	2006-06-01,
    #|	11:00:00,
    #|]
    #|comments = [
    #|         1,
    #|         2, #this is ok
    #|]
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "comments": Array([Integer(1), Integer(2)]),
    "dates": Array([
      Datetime(
        { year: 1987, month: 7, day: 5, },
        { hour: 17, minute: 45, second: 0, nanosecond: 0, },
        offset=0,
      ),
      LocalDatetime({ year: 1979, month: 5, day: 27, }, {
        hour: 7,
        minute: 32,
        second: 0,
        nanosecond: 0,
      }),
      LocalDate({ year: 2006, month: 6, day: 1, }),
      LocalTime({ hour: 11, minute: 0, second: 0, nanosecond: 0, }),
    ]),
    "floats": Array([Float(1.1), Float(2.1), Float(3.1)]),
    "ints": Array([Integer(1), Integer(2), Integer(3)]),
    "strings": Array([String("a"), String("b"), String("c")]),
  })
}

///|
test "valid/array/hetergeneous" {
  let toml_text =
    #|mixed = [[1, 2], ["a", "b"], [1.1, 2.1]]
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "mixed": Array([
      Array([Integer(1), Integer(2)]),
      Array([String("a"), String("b")]),
      Array([Float(1.1), Float(2.1)]),
    ]),
  })
}

///|
test "valid/array/mixed-int-array" {
  let toml_text =
    #|arrays-and-ints =  [1, ["Arrays are not integers."]]
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "arrays-and-ints": Array([
      Integer(1),
      Array([String("Arrays are not integers.")]),
    ]),
  })
}

///|
test "valid/array/mixed-int-float" {
  let toml_text =
    #|ints-and-floats = [1, 1.1]
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, { "ints-and-floats": Array([Integer(1), Float(1.1)]) })
}

///|
test "valid/array/mixed-int-string" {
  let toml_text =
    #|strings-and-ints = ["hi", 42]
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, { "strings-and-ints": Array([String("hi"), Integer(42)]) })
}

///|
test "valid/array/mixed-string-table" {
  let toml_text =
    #|contributors = [
    #|  "Foo Bar <foo@example.com>",
    #|  { name = "Baz Qux", email = "bazqux@example.com", url = "https://example.com/bazqux" }
    #|]
    #|
    #|# Start with a table as the first element. This tests a case that some libraries
    #|# might have where they will check if the first entry is a table/map/hash/assoc
    #|# array and then encode it as a table array. This was a reasonable thing to do
    #|# before TOML 1.0 since arrays could only contain one type, but now it's no
    #|# longer.
    #|mixed = [{k="a"}, "b", 1]
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "contributors": Array([
      String("Foo Bar <foo@example.com>"),
      Table({
        "email": String("bazqux@example.com"),
        "name": String("Baz Qux"),
        "url": String("https://example.com/bazqux"),
      }),
    ]),
    "mixed": Array([Table({ "k": String("a") }), String("b"), Integer(1)]),
  })
}

///|
test "valid/array/nested-double" {
  let toml_text =
    #|nest = [
    #|	[
    #|		["a"],
    #|		[1, 2, [3]]
    #|	]
    #|]
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "nest": Array([
      Array([
        Array([String("a")]),
        Array([Integer(1), Integer(2), Array([Integer(3)])]),
      ]),
    ]),
  })
}

///|
test "valid/array/nested-inline-table" {
  let toml_text =
    #|a = [ { b = {} } ]
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, { "a": Array([Table({ "b": Table(Map([])) })]) })
}

///|
test "valid/array/nested" {
  let toml_text =
    #|nest = [["a"], ["b"]]
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "nest": Array([Array([String("a")]), Array([String("b")])]),
  })
}

///|
test "valid/array/open-parent-table" {
  let toml_text =
    #|[[parent-table.arr]]
    #|[[parent-table.arr]]
    #|[parent-table]
    #|not-arr = 1
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "parent-table": Table({
      "arr": Array([Table(Map([])), Table(Map([]))]),
      "not-arr": Integer(1),
    }),
  })
}

///|
test "valid/array/table-array-string-backslash" {
  let toml_text =
    #|foo = [ { bar="\"{{baz}}\""} ]
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, { "foo": Array([Table({ "bar": String("\"{{baz}}\"") })]) })
}

///|
test "valid/array/trailing-comma" {
  let toml_text =
    #|arr-1 = [1,]
    #|
    #|arr-2 = [2,3,]
    #|
    #|arr-3 = [4,
    #|]
    #|
    #|arr-4 = [
    #|	5,
    #|	6,
    #|]
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "arr-1": Array([Integer(1)]),
    "arr-2": Array([Integer(2), Integer(3)]),
    "arr-3": Array([Integer(4)]),
    "arr-4": Array([Integer(5), Integer(6)]),
  })
}

///|
test "valid/datetime/datetime" {
  let toml_text =
    #|space = 1987-07-05 17:45:00Z
    #|
    #|# ABNF is case-insensitive, both "Z" and "z" must be supported.
    #|lower = 1987-07-05t17:45:00z
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "lower": Datetime(
      { year: 1987, month: 7, day: 5, },
      { hour: 17, minute: 45, second: 0, nanosecond: 0, },
      offset=0,
    ),
    "space": Datetime(
      { year: 1987, month: 7, day: 5, },
      { hour: 17, minute: 45, second: 0, nanosecond: 0, },
      offset=0,
    ),
  })
}

///|
test "valid/datetime/local-date" {
  let toml_text =
    #|bestdayever = 1987-07-05
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "bestdayever": LocalDate({ year: 1987, month: 7, day: 5, }),
  })
}

///|
test "valid/datetime/local-time" {
  let toml_text =
    #|besttimeever = 17:45:00
    #|milliseconds = 10:32:00.555
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "besttimeever": LocalTime({
      hour: 17,
      minute: 45,
      second: 0,
      nanosecond: 0,
    }),
    "milliseconds": LocalTime({
      hour: 10,
      minute: 32,
      second: 0,
      nanosecond: 555000000,
    }),
  })
}

///|
test "valid/datetime/local" {
  let toml_text =
    #|local = 1987-07-05T17:45:00
    #|milli = 1977-12-21T10:32:00.555
    #|space = 1987-07-05 17:45:00
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "local": LocalDatetime({ year: 1987, month: 7, day: 5, }, {
      hour: 17,
      minute: 45,
      second: 0,
      nanosecond: 0,
    }),
    "milli": LocalDatetime({ year: 1977, month: 12, day: 21, }, {
      hour: 10,
      minute: 32,
      second: 0,
      nanosecond: 555000000,
    }),
    "space": LocalDatetime({ year: 1987, month: 7, day: 5, }, {
      hour: 17,
      minute: 45,
      second: 0,
      nanosecond: 0,
    }),
  })
}

///|
test "valid/datetime/milliseconds" {
  let toml_text =
    #|utc1  = 1987-07-05T17:45:56.123Z
    #|utc2  = 1987-07-05T17:45:56.6Z
    #|wita1 = 1987-07-05T17:45:56.123+08:00
    #|wita2 = 1987-07-05T17:45:56.6+08:00
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "utc1": Datetime(
      { year: 1987, month: 7, day: 5, },
      { hour: 17, minute: 45, second: 56, nanosecond: 123000000, },
      offset=0,
    ),
    "utc2": Datetime(
      { year: 1987, month: 7, day: 5, },
      { hour: 17, minute: 45, second: 56, nanosecond: 600000000, },
      offset=0,
    ),
    "wita1": Datetime(
      { year: 1987, month: 7, day: 5, },
      { hour: 17, minute: 45, second: 56, nanosecond: 123000000, },
      offset=480,
    ),
    "wita2": Datetime(
      { year: 1987, month: 7, day: 5, },
      { hour: 17, minute: 45, second: 56, nanosecond: 600000000, },
      offset=480,
    ),
  })
}

///|
test "valid/datetime/timezone" {
  let toml_text =
    #|utc  = 1987-07-05T17:45:56Z
    #|pdt  = 1987-07-05T17:45:56-05:00
    #|nzst = 1987-07-05T17:45:56+12:00
    #|nzdt = 1987-07-05T17:45:56+13:00  # DST
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "nzdt": Datetime(
      { year: 1987, month: 7, day: 5, },
      { hour: 17, minute: 45, second: 56, nanosecond: 0, },
      offset=780,
    ),
    "nzst": Datetime(
      { year: 1987, month: 7, day: 5, },
      { hour: 17, minute: 45, second: 56, nanosecond: 0, },
      offset=720,
    ),
    "pdt": Datetime(
      { year: 1987, month: 7, day: 5, },
      { hour: 17, minute: 45, second: 56, nanosecond: 0, },
      offset=-300,
    ),
    "utc": Datetime(
      { year: 1987, month: 7, day: 5, },
      { hour: 17, minute: 45, second: 56, nanosecond: 0, },
      offset=0,
    ),
  })
}

///|
test "valid/float/inf-and-nan" {
  let toml_text =
    #|# We don't encode +nan and -nan back with the signs; many languages don't
    #|# support a sign on NaN (it doesn't really make much sense).
    #|nan = nan
    #|nan_neg = -nan
    #|nan_plus = +nan
    #|infinity = inf
    #|infinity_neg = -inf
    #|infinity_plus = +inf
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "infinity": Float(@double.infinity),
    "infinity_neg": Float(@double.neg_infinity),
    "infinity_plus": Float(@double.infinity),
    "nan": Float(@double.not_a_number),
    "nan_neg": Float(@double.not_a_number),
    "nan_plus": Float(@double.not_a_number),
  })
}

///|
test "valid/float/long" {
  let toml_text =
    #|longpi = 3.141592653589793
    #|neglongpi = -3.141592653589793
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "longpi": Float(3.141592653589793),
    "neglongpi": Float(-3.141592653589793),
  })
}

///|
test "valid/float/max-int" {
  let toml_text =
    #|# Maximum and minimum safe natural numbers.
    #|max_float =  9_007_199_254_740_991.0
    #|min_float = -9_007_199_254_740_991.0
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "max_float": Float(9007199254740991.0),
    "min_float": Float(-9007199254740991.0),
  })
}

///|
test "valid/float/underscore" {
  let toml_text =
    #|before = 3_141.5927
    #|after = 3141.592_7
    #|exponent = 3e1_4
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "after": Float(3141.5927),
    "before": Float(3141.5927),
    "exponent": Float(3.0e14),
  })
}

///|
test "valid/implicit-and-explicit-after" {
  let toml_text =
    #|[a.b.c]
    #|answer = 42
    #|
    #|[a]
    #|better = 43
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "a": Table({
      "b": Table({ "c": Table({ "answer": Integer(42) }) }),
      "better": Integer(43),
    }),
  })
}

///|
test "valid/implicit-and-explicit-before" {
  let toml_text =
    #|[a]
    #|better = 43
    #|
    #|[a.b.c]
    #|answer = 42
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "a": Table({
      "b": Table({ "c": Table({ "answer": Integer(42) }) }),
      "better": Integer(43),
    }),
  })
}

///|
test "valid/implicit-groups" {
  let toml_text =
    #|[a.b.c]
    #|answer = 42
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "a": Table({ "b": Table({ "c": Table({ "answer": Integer(42) }) }) }),
  })
}

///|
test "valid/inline-table/bool" {
  let toml_text =
    #|a = {a = true, b = false}
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, { "a": Table({ "a": Bool(true), "b": Bool(false) }) })
}

///|
test "valid/inline-table/empty" {
  let toml_text =
    #|empty1 = {}
    #|empty2 = { }
    #|empty_in_array = [ { not_empty = 1 }, {} ]
    #|empty_in_array2 = [{},{not_empty=1}]
    #|many_empty = [{},{},{}]
    #|nested_empty = {"empty"={}}
    #|with_cmt ={            }#nothing here
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "empty1": Table(Map([])),
    "empty2": Table(Map([])),
    "empty_in_array": Array([Table({ "not_empty": Integer(1) }), Table(Map([]))]),
    "empty_in_array2": Array([
      Table(Map([])),
      Table({ "not_empty": Integer(1) }),
    ]),
    "many_empty": Array([Table(Map([])), Table(Map([])), Table(Map([]))]),
    "nested_empty": Table({ "empty": Table(Map([])) }),
    "with_cmt": Table(Map([])),
  })
}

///|
test "valid/inline-table/end-in-bool" {
  let toml_text =
    #|black = { python=">3.6", version=">=18.9b0", allow_prereleases=true }
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "black": Table({
      "allow_prereleases": Bool(true),
      "python": String(">3.6"),
      "version": String(">=18.9b0"),
    }),
  })
}

///|
test "valid/inline-table/spaces" {
  let toml_text =
    #|# https://github.com/toml-lang/toml-test/issues/146
    #|clap-1 = { version = "4"  , features = ["derive", "cargo"] }
    #|
    #|# Contains some literal tabs!
    #|clap-2 = { version = "4"	   	,	  	features = [   "derive" 	  ,  	  "cargo"   ]   , nest   =   {  	  "a"   =   'x'  , 	  'b'   = [ 1.5    ,   9.0  ]  }  }
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "clap-1": Table({
      "features": Array([String("derive"), String("cargo")]),
      "version": String("4"),
    }),
    "clap-2": Table({
      "features": Array([String("derive"), String("cargo")]),
      "nest": Table({ "a": String("x"), "b": Array([Float(1.5), Float(9.0)]) }),
      "version": String("4"),
    }),
  })
}

///|
test "valid/key/dotted-01" {
  let toml_text =
    #|name.first = "Arthur"
    #|"name".'last' = "Dent"
    #|
    #|many.dots.dot.dot.dot = 42
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "many": Table({
      "dots": Table({ "dot": Table({ "dot": Table({ "dot": Integer(42) }) }) }),
    }),
    "name": Table({ "first": String("Arthur"), "last": String("Dent") }),
  })
}

///|
test "valid/key/dotted-02" {
  let toml_text =
    #|# Note: this file contains literal tab characters.
    #|
    #|# Space are ignored, and key parts can be quoted.
    #|count.a       = 1
    #|count . b     = 2
    #|"count"."c"   = 3
    #|"count" . "d" = 4
    #|'count'.'e'   = 5
    #|'count' . 'f' = 6
    #|"count".'g'   = 7
    #|"count" . 'h' = 8
    #|count.'i'     = 9
    #|count 	.	 'j'	   = 10
    #|"count".k     = 11
    #|"count" . l   = 12
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "count": Table({
      "a": Integer(1),
      "b": Integer(2),
      "c": Integer(3),
      "d": Integer(4),
      "e": Integer(5),
      "f": Integer(6),
      "g": Integer(7),
      "h": Integer(8),
      "i": Integer(9),
      "j": Integer(10),
      "k": Integer(11),
      "l": Integer(12),
    }),
  })
}

///|
test "valid/key/dotted-03" {
  let toml_text =
    #|top.key = 1
    #|
    #|[tbl]
    #|a.b.c = 42.666
    #|
    #|[a.few.dots]
    #|polka.dot = "again?"
    #|polka.dance-with = "Dot"
    #|
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "a": Table({
      "few": Table({
        "dots": Table({
          "polka": Table({
            "dance-with": String("Dot"),
            "dot": String("again?"),
          }),
        }),
      }),
    }),
    "tbl": Table({ "a": Table({ "b": Table({ "c": Float(42.666) }) }) }),
    "top": Table({ "key": Integer(1) }),
  })
}

///|
test "valid/key/dotted-04" {
  let toml_text =
    #|top.key = 1
    #|
    #|[[arr]]
    #|a.b.c=1
    #|a.b.d=2
    #|
    #|[[arr]]
    #|a.b.c=3
    #|a.b.d=4
    #|
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "arr": Array([
      Table({ "a": Table({ "b": Table({ "c": Integer(1), "d": Integer(2) }) }) }),
      Table({ "a": Table({ "b": Table({ "c": Integer(3), "d": Integer(4) }) }) }),
    ]),
    "top": Table({ "key": Integer(1) }),
  })
}

///|
test "valid/key/dotted-empty" {
  let toml_text =
    #|''.x = "empty.x"
    #|x."" = "x.empty"
    #|[a]
    #|"".'' = "empty.empty"
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "": Table({ "x": String("empty.x") }),
    "a": Table({ "": Table({ "": String("empty.empty") }) }),
    "x": Table({ "": String("x.empty") }),
  })
}

///|
test "valid/key/escapes" {
  let toml_text =
    #|"\n" = "newline"
    #|"\b" = "bell"
    #|"\u00c0" = "latin capital letter A with grave"
    #|"\"" = "just a quote"
    #|
    #|["backsp\b\b"]
    #|
    #|["\"quoted\""]
    #|quote = true
    #|
    #|["a.b"."\u00c0"]
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "\u{08}": String("bell"),
    "\n": String("newline"),
    "\"": String("just a quote"),
    "\"quoted\"": Table({ "quote": Bool(true) }),
    "a.b": Table({ "À": Table(Map([])) }),
    "backsp\u{08}\u{08}": Table(Map([])),
    "À": String("latin capital letter A with grave"),
  })
}

///|
test "valid/key/quoted-dots" {
  let toml_text =
    #|plain = 1
    #|"with.dot" = 2
    #|
    #|[plain_table]
    #|plain = 3
    #|"with.dot" = 4
    #|
    #|[table.withdot]
    #|plain = 5
    #|"key.with.dots" = 6
    #|"escaped\u002edot" = 7
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "plain": Integer(1),
    "plain_table": Table({ "plain": Integer(3), "with.dot": Integer(4) }),
    "table": Table({
      "withdot": Table({
        "escaped.dot": Integer(7),
        "key.with.dots": Integer(6),
        "plain": Integer(5),
      }),
    }),
    "with.dot": Integer(2),
  })
}

///|
test "valid/key/quoted-unicode" {
  let toml_text =
    #|
    #|"\u0000" = "null"
    #|'\u0000' = "different key"
    #|"\u0008 \u000c \U00000041 \u007f \u0080 \u00ff \ud7ff \ue000 \uffff \U00010000 \U0010ffff" = "escaped key"
    #|
    #|"~  ÿ ퟿  ￿ 𐀀 􏿿" = "basic key"
    #|'l ~  ÿ ퟿  ￿ 𐀀 􏿿' = "literal key"
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "\u{00}": String("null"),
    "\u{08} \u{0C} A \u{7F} \u{80} ÿ ퟿  ￿ 𐀀 􏿿": String(
      "escaped key",
    ),
    "\\u0000": String("different key"),
    "l ~ \u{80} ÿ ퟿  ￿ 𐀀 􏿿": String("literal key"),
    "~ \u{80} ÿ ퟿  ￿ 𐀀 􏿿": String("basic key"),
  })
}

///|
test "valid/spec-1.0.0/array-0" {
  let toml_text =
    #|integers = [ 1, 2, 3 ]
    #|colors = [ "red", "yellow", "green" ]
    #|nested_arrays_of_ints = [ [ 1, 2 ], [3, 4, 5] ]
    #|nested_mixed_array = [ [ 1, 2 ], ["a", "b", "c"] ]
    #|string_array = [ "all", 'strings', """are the same""", '''type''' ]
    #|
    #|# Mixed-type arrays are allowed
    #|numbers = [ 0.1, 0.2, 0.5, 1, 2, 5 ]
    #|contributors = [
    #|  "Foo Bar <foo@example.com>",
    #|  { name = "Baz Qux", email = "bazqux@example.com", url = "https://example.com/bazqux" }
    #|]
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "colors": Array([String("red"), String("yellow"), String("green")]),
    "contributors": Array([
      String("Foo Bar <foo@example.com>"),
      Table({
        "email": String("bazqux@example.com"),
        "name": String("Baz Qux"),
        "url": String("https://example.com/bazqux"),
      }),
    ]),
    "integers": Array([Integer(1), Integer(2), Integer(3)]),
    "nested_arrays_of_ints": Array([
      Array([Integer(1), Integer(2)]),
      Array([Integer(3), Integer(4), Integer(5)]),
    ]),
    "nested_mixed_array": Array([
      Array([Integer(1), Integer(2)]),
      Array([String("a"), String("b"), String("c")]),
    ]),
    "numbers": Array([
      Float(0.1),
      Float(0.2),
      Float(0.5),
      Integer(1),
      Integer(2),
      Integer(5),
    ]),
    "string_array": Array([
      String("all"),
      String("strings"),
      String("are the same"),
      String("type"),
    ]),
  })
}

///|
test "valid/spec-1.0.0/array-1" {
  let toml_text =
    #|integers2 = [
    #|  1, 2, 3
    #|]
    #|
    #|integers3 = [
    #|  1,
    #|  2, # this is ok
    #|]
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "integers2": Array([Integer(1), Integer(2), Integer(3)]),
    "integers3": Array([Integer(1), Integer(2)]),
  })
}

///|
test "valid/spec-1.0.0/float-0" {
  let toml_text =
    #|# fractional
    #|flt1 = +1.0
    #|flt2 = 3.1415
    #|flt3 = -0.01
    #|
    #|# exponent
    #|flt4 = 5e+22
    #|flt5 = 1e06
    #|flt6 = -2E-2
    #|
    #|# both
    #|flt7 = 6.626e-34
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "flt1": Float(1.0),
    "flt2": Float(3.1415),
    "flt3": Float(-0.01),
    "flt4": Float(5.0e22),
    "flt5": Float(1.0e6),
    "flt6": Float(-0.02),
    "flt7": Float(6.626e-34),
  })
}

///|
test "valid/spec-1.0.0/float-1" {
  let toml_text =
    #|flt8 = 224_617.445_991_228
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, { "flt8": Float(224617.445991228) })
}

///|
test "valid/spec-1.0.0/float-2" {
  let toml_text =
    #|# infinity
    #|sf1 = inf  # positive infinity
    #|sf2 = +inf # positive infinity
    #|sf3 = -inf # negative infinity
    #|
    #|# not a number
    #|sf4 = nan  # actual sNaN/qNaN encoding is implementation-specific
    #|sf5 = +nan # same as `nan`
    #|sf6 = -nan # valid, actual encoding is implementation-specific
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "sf1": Float(@double.infinity),
    "sf2": Float(@double.infinity),
    "sf3": Float(@double.neg_infinity),
    "sf4": Float(@double.not_a_number),
    "sf5": Float(@double.not_a_number),
    "sf6": Float(@double.not_a_number),
  })
}

///|
test "valid/spec-1.0.0/keys-3" {
  let toml_text =
    #|name = "Orange"
    #|physical.color = "orange"
    #|physical.shape = "round"
    #|site."google.com" = true
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "name": String("Orange"),
    "physical": Table({ "color": String("orange"), "shape": String("round") }),
    "site": Table({ "google.com": Bool(true) }),
  })
}

///|
test "valid/spec-1.0.0/keys-4" {
  let toml_text =
    #|fruit.name = "banana"     # this is best practice
    #|fruit. color = "yellow"    # same as fruit.color
    #|fruit . flavor = "banana"   # same as fruit.flavor
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "fruit": Table({
      "color": String("yellow"),
      "flavor": String("banana"),
      "name": String("banana"),
    }),
  })
}

///|
test "valid/spec-1.0.0/keys-5" {
  let toml_text =
    #|# VALID BUT DISCOURAGED
    #|
    #|apple.type = "fruit"
    #|orange.type = "fruit"
    #|
    #|apple.skin = "thin"
    #|orange.skin = "thick"
    #|
    #|apple.color = "red"
    #|orange.color = "orange"
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "apple": Table({
      "color": String("red"),
      "skin": String("thin"),
      "type": String("fruit"),
    }),
    "orange": Table({
      "color": String("orange"),
      "skin": String("thick"),
      "type": String("fruit"),
    }),
  })
}

///|
test "valid/spec-1.0.0/keys-6" {
  let toml_text =
    #|# RECOMMENDED
    #|
    #|apple.type = "fruit"
    #|apple.skin = "thin"
    #|apple.color = "red"
    #|
    #|orange.type = "fruit"
    #|orange.skin = "thick"
    #|orange.color = "orange"
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "apple": Table({
      "color": String("red"),
      "skin": String("thin"),
      "type": String("fruit"),
    }),
    "orange": Table({
      "color": String("orange"),
      "skin": String("thick"),
      "type": String("fruit"),
    }),
  })
}

///|
test "valid/spec-1.0.0/keys-7" {
  let toml_text =
    #|3.14159 = "pi"
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, { "3": Table({ "14159": String("pi") }) })
}

///|
test "valid/spec-1.0.0/offset-date-time-1" {
  let toml_text =
    #|odt4 = 1979-05-27 07:32:00Z
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "odt4": Datetime(
      { year: 1979, month: 5, day: 27, },
      { hour: 7, minute: 32, second: 0, nanosecond: 0, },
      offset=0,
    ),
  })
}

///|
test "valid/spec-1.0.0/table-0" {
  let toml_text =
    #|[table]
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, { "table": Table(Map([])) })
}

///|
test "valid/spec-1.0.0/table-1" {
  let toml_text =
    #|[table-1]
    #|key1 = "some string"
    #|key2 = 123
    #|
    #|[table-2]
    #|key1 = "another string"
    #|key2 = 456
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "table-1": Table({ "key1": String("some string"), "key2": Integer(123) }),
    "table-2": Table({ "key1": String("another string"), "key2": Integer(456) }),
  })
}

///|
test "valid/spec-1.0.0/table-2" {
  let toml_text =
    #|[dog."tater.man"]
    #|type.name = "pug"
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "dog": Table({
      "tater.man": Table({ "type": Table({ "name": String("pug") }) }),
    }),
  })
}

///|
test "valid/spec-1.0.0/table-3" {
  let toml_text =
    #|[a.b.c]            # this is best practice
    #|[ d.e.f ]          # same as [d.e.f]
    #|[ g .  h  . i ]    # same as [g.h.i]
    #|[ j . "ʞ" . 'l' ]  # same as [j."ʞ".'l']
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "a": Table({ "b": Table({ "c": Table(Map([])) }) }),
    "d": Table({ "e": Table({ "f": Table(Map([])) }) }),
    "g": Table({ "h": Table({ "i": Table(Map([])) }) }),
    "j": Table({ "ʞ": Table({ "l": Table(Map([])) }) }),
  })
}

///|
test "valid/spec-1.0.0/table-4" {
  let toml_text =
    #|# [x] you
    #|# [x.y] don't
    #|# [x.y.z] need these
    #|[x.y.z.w] # for this to work
    #|
    #|[x] # defining a super-table afterward is ok
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "x": Table({ "y": Table({ "z": Table({ "w": Table(Map([])) }) }) }),
  })
}

///|
test "valid/spec-1.0.0/table-5" {
  let toml_text =
    #|# VALID BUT DISCOURAGED
    #|[fruit.apple]
    #|[animal]
    #|[fruit.orange]
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "animal": Table(Map([])),
    "fruit": Table({ "apple": Table(Map([])), "orange": Table(Map([])) }),
  })
}

///|
test "valid/spec-1.0.0/table-6" {
  let toml_text =
    #|# RECOMMENDED
    #|[fruit.apple]
    #|[fruit.orange]
    #|[animal]
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "animal": Table(Map([])),
    "fruit": Table({ "apple": Table(Map([])), "orange": Table(Map([])) }),
  })
}

///|
test "valid/spec-1.0.0/table-7" {
  let toml_text =
    #|# Top-level table begins.
    #|name = "Fido"
    #|breed = "pug"
    #|
    #|# Top-level table ends.
    #|[owner]
    #|name = "Regina Dogman"
    #|member_since = 1999-08-04
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "breed": String("pug"),
    "name": String("Fido"),
    "owner": Table({
      "member_since": LocalDate({ year: 1999, month: 8, day: 4, }),
      "name": String("Regina Dogman"),
    }),
  })
}

///|
test "valid/spec-1.0.0/table-8" {
  let toml_text =
    #|fruit.apple.color = "red"
    #|# Defines a table named fruit
    #|# Defines a table named fruit.apple
    #|
    #|fruit.apple.taste.sweet = true
    #|# Defines a table named fruit.apple.taste
    #|# fruit and fruit.apple were already created
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "fruit": Table({
      "apple": Table({
        "color": String("red"),
        "taste": Table({ "sweet": Bool(true) }),
      }),
    }),
  })
}

///|
test "valid/spec-1.0.0/table-9" {
  let toml_text =
    #|[fruit]
    #|apple.color = "red"
    #|apple.taste.sweet = true
    #|
    #|# [fruit.apple]  # INVALID
    #|# [fruit.apple.taste]  # INVALID
    #|
    #|[fruit.apple.texture]  # you can add sub-tables
    #|smooth = true
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "fruit": Table({
      "apple": Table({
        "color": String("red"),
        "taste": Table({ "sweet": Bool(true) }),
        "texture": Table({ "smooth": Bool(true) }),
      }),
    }),
  })
}

///|
test "valid/spec-1.1.0/common-37" {
  let toml_text =
    #|[table]
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, { "table": Table(Map([])) })
}

///|
test "valid/spec-1.1.0/common-38" {
  let toml_text =
    #|[table-1]
    #|key1 = "some string"
    #|key2 = 123
    #|
    #|[table-2]
    #|key1 = "another string"
    #|key2 = 456
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "table-1": Table({ "key1": String("some string"), "key2": Integer(123) }),
    "table-2": Table({ "key1": String("another string"), "key2": Integer(456) }),
  })
}

///|
test "valid/spec-1.1.0/common-39" {
  let toml_text =
    #|[dog."tater.man"]
    #|type.name = "pug"
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "dog": Table({
      "tater.man": Table({ "type": Table({ "name": String("pug") }) }),
    }),
  })
}

///|
test "valid/spec-1.1.0/common-40" {
  let toml_text =
    #|[a.b.c]            # this is best practice
    #|[ d.e.f ]          # same as [d.e.f]
    #|[ g .  h  . i ]    # same as [g.h.i]
    #|[ j . "ʞ" . 'l' ]  # same as [j."ʞ".'l']
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "a": Table({ "b": Table({ "c": Table(Map([])) }) }),
    "d": Table({ "e": Table({ "f": Table(Map([])) }) }),
    "g": Table({ "h": Table({ "i": Table(Map([])) }) }),
    "j": Table({ "ʞ": Table({ "l": Table(Map([])) }) }),
  })
}

///|
test "valid/spec-1.1.0/common-41" {
  let toml_text =
    #|# [x] you
    #|# [x.y] don't
    #|# [x.y.z] need these
    #|[x.y.z.w] # for this to work
    #|
    #|[x] # defining a super-table afterward is ok
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "x": Table({ "y": Table({ "z": Table({ "w": Table(Map([])) }) }) }),
  })
}

///|
test "valid/spec-1.1.0/common-42" {
  let toml_text =
    #|# VALID BUT DISCOURAGED
    #|[fruit.apple]
    #|[animal]
    #|[fruit.orange]
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "animal": Table(Map([])),
    "fruit": Table({ "apple": Table(Map([])), "orange": Table(Map([])) }),
  })
}

///|
test "valid/spec-1.1.0/common-43" {
  let toml_text =
    #|# RECOMMENDED
    #|[fruit.apple]
    #|[fruit.orange]
    #|[animal]
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "animal": Table(Map([])),
    "fruit": Table({ "apple": Table(Map([])), "orange": Table(Map([])) }),
  })
}

///|
test "valid/spec-1.1.0/common-44" {
  let toml_text =
    #|# Top-level table begins.
    #|name = "Fido"
    #|breed = "pug"
    #|
    #|# Top-level table ends.
    #|[owner]
    #|name = "Regina Dogman"
    #|member_since = 1999-08-04
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "breed": String("pug"),
    "name": String("Fido"),
    "owner": Table({
      "member_since": LocalDate({ year: 1999, month: 8, day: 4, }),
      "name": String("Regina Dogman"),
    }),
  })
}

///|
test "valid/spec-1.1.0/common-45" {
  let toml_text =
    #|fruit.apple.color = "red"
    #|# Defines a table named fruit
    #|# Defines a table named fruit.apple
    #|
    #|fruit.apple.taste.sweet = true
    #|# Defines a table named fruit.apple.taste
    #|# fruit and fruit.apple were already created
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "fruit": Table({
      "apple": Table({
        "color": String("red"),
        "taste": Table({ "sweet": Bool(true) }),
      }),
    }),
  })
}

///|
test "valid/spec-1.1.0/common-46" {
  let toml_text =
    #|[fruit]
    #|apple.color = "red"
    #|apple.taste.sweet = true
    #|
    #|# [fruit.apple]  # INVALID
    #|# [fruit.apple.taste]  # INVALID
    #|
    #|[fruit.apple.texture]  # you can add sub-tables
    #|smooth = true
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "fruit": Table({
      "apple": Table({
        "color": String("red"),
        "taste": Table({ "sweet": Bool(true) }),
        "texture": Table({ "smooth": Bool(true) }),
      }),
    }),
  })
}

///|
test "valid/spec-1.1.0/common-48" {
  let toml_text =
    #|[name]
    #|first = "Tom"
    #|last = "Preston-Werner"
    #|
    #|[point]
    #|x = 1
    #|y = 2
    #|
    #|[animal]
    #|type.name = "pug"
    #|
    #|[contact.personal]
    #|name = "Donald Duck"
    #|email = "donald@duckburg.com"
    #|
    #|[contact.work]
    #|name = "Coin cleaner"
    #|email = "donald@ScroogeCorp.com"
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "animal": Table({ "type": Table({ "name": String("pug") }) }),
    "contact": Table({
      "personal": Table({
        "email": String("donald@duckburg.com"),
        "name": String("Donald Duck"),
      }),
      "work": Table({
        "email": String("donald@ScroogeCorp.com"),
        "name": String("Coin cleaner"),
      }),
    }),
    "name": Table({ "first": String("Tom"), "last": String("Preston-Werner") }),
    "point": Table({ "x": Integer(1), "y": Integer(2) }),
  })
}

///|
test "valid/spec-1.1.0/common-49" {
  let toml_text =
    #|[product]
    #|type = { name = "Nail" }
    #|# type.edible = false  # INVALID
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "product": Table({ "type": Table({ "name": String("Nail") }) }),
  })
}

///|
test "valid/spec-1.1.0/common-50" {
  let toml_text =
    #|[product]
    #|type.name = "Nail"
    #|# type = { edible = false }  # INVALID
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "product": Table({ "type": Table({ "name": String("Nail") }) }),
  })
}

///|
test "valid/spec-1.1.0/common-51" {
  let toml_text =
    #|[[product]]
    #|name = "Hammer"
    #|sku = 738594937
    #|
    #|[[product]]  # empty table within the array
    #|
    #|[[product]]
    #|name = "Nail"
    #|sku = 284758393
    #|
    #|color = "gray"
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "product": Array([
      Table({ "name": String("Hammer"), "sku": Integer(738594937) }),
      Table(Map([])),
      Table({
        "color": String("gray"),
        "name": String("Nail"),
        "sku": Integer(284758393),
      }),
    ]),
  })
}

///|
test "valid/spec-1.1.0/common-52" {
  let toml_text =
    #|[[fruits]]
    #|name = "apple"
    #|
    #|[fruits.physical]  # subtable
    #|color = "red"
    #|shape = "round"
    #|
    #|[[fruits.varieties]]  # nested array of tables
    #|name = "red delicious"
    #|
    #|[[fruits.varieties]]
    #|name = "granny smith"
    #|
    #|
    #|[[fruits]]
    #|name = "banana"
    #|
    #|[[fruits.varieties]]
    #|name = "plantain"
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "fruits": Array([
      Table({
        "name": String("apple"),
        "physical": Table({ "color": String("red"), "shape": String("round") }),
        "varieties": Array([
          Table({ "name": String("red delicious") }),
          Table({ "name": String("granny smith") }),
        ]),
      }),
      Table({
        "name": String("banana"),
        "varieties": Array([Table({ "name": String("plantain") })]),
      }),
    ]),
  })
}

///|
test "valid/spec-1.1.0/common-53" {
  let toml_text =
    #|points = [ { x = 1, y = 2, z = 3 },
    #|           { x = 7, y = 8, z = 9 },
    #|           { x = 2, y = 4, z = 8 } ]
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "points": Array([
      Table({ "x": Integer(1), "y": Integer(2), "z": Integer(3) }),
      Table({ "x": Integer(7), "y": Integer(8), "z": Integer(9) }),
      Table({ "x": Integer(2), "y": Integer(4), "z": Integer(8) }),
    ]),
  })
}

///|
test "valid/spec-example-1-compact" {
  let toml_text =
    #|#Useless spaces eliminated.
    #|title="TOML Example"
    #|[owner]
    #|name="Lance Uppercut"
    #|dob=1979-05-27T07:32:00-08:00#First class dates
    #|[database]
    #|server="192.168.1.1"
    #|ports=[8001,8001,8002]
    #|connection_max=5000
    #|enabled=true
    #|[servers]
    #|[servers.alpha]
    #|ip="10.0.0.1"
    #|dc="eqdc10"
    #|[servers.beta]
    #|ip="10.0.0.2"
    #|dc="eqdc10"
    #|[clients]
    #|data=[["gamma","delta"],[1,2]]
    #|hosts=[
    #|"alpha",
    #|"omega"
    #|]
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "clients": Table({
      "data": Array([
        Array([String("gamma"), String("delta")]),
        Array([Integer(1), Integer(2)]),
      ]),
      "hosts": Array([String("alpha"), String("omega")]),
    }),
    "database": Table({
      "connection_max": Integer(5000),
      "enabled": Bool(true),
      "ports": Array([Integer(8001), Integer(8001), Integer(8002)]),
      "server": String("192.168.1.1"),
    }),
    "owner": Table({
      "dob": Datetime(
        { year: 1979, month: 5, day: 27, },
        { hour: 7, minute: 32, second: 0, nanosecond: 0, },
        offset=-480,
      ),
      "name": String("Lance Uppercut"),
    }),
    "servers": Table({
      "alpha": Table({ "dc": String("eqdc10"), "ip": String("10.0.0.1") }),
      "beta": Table({ "dc": String("eqdc10"), "ip": String("10.0.0.2") }),
    }),
    "title": String("TOML Example"),
  })
}

///|
test "valid/spec-example-1" {
  let toml_text =
    #|# This is a TOML document. Boom.
    #|
    #|title = "TOML Example"
    #|
    #|[owner]
    #|name = "Lance Uppercut"
    #|dob = 1979-05-27T07:32:00-08:00 # First class dates? Why not?
    #|
    #|[database]
    #|server = "192.168.1.1"
    #|ports = [ 8001, 8001, 8002 ]
    #|connection_max = 5000
    #|enabled = true
    #|
    #|[servers]
    #|
    #|  # You can indent as you please. Tabs or spaces. TOML don't care.
    #|  [servers.alpha]
    #|  ip = "10.0.0.1"
    #|  dc = "eqdc10"
    #|
    #|  [servers.beta]
    #|  ip = "10.0.0.2"
    #|  dc = "eqdc10"
    #|
    #|[clients]
    #|data = [ ["gamma", "delta"], [1, 2] ]
    #|
    #|# Line breaks are OK when inside arrays
    #|hosts = [
    #|  "alpha",
    #|  "omega"
    #|]
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "clients": Table({
      "data": Array([
        Array([String("gamma"), String("delta")]),
        Array([Integer(1), Integer(2)]),
      ]),
      "hosts": Array([String("alpha"), String("omega")]),
    }),
    "database": Table({
      "connection_max": Integer(5000),
      "enabled": Bool(true),
      "ports": Array([Integer(8001), Integer(8001), Integer(8002)]),
      "server": String("192.168.1.1"),
    }),
    "owner": Table({
      "dob": Datetime(
        { year: 1979, month: 5, day: 27, },
        { hour: 7, minute: 32, second: 0, nanosecond: 0, },
        offset=-480,
      ),
      "name": String("Lance Uppercut"),
    }),
    "servers": Table({
      "alpha": Table({ "dc": String("eqdc10"), "ip": String("10.0.0.1") }),
      "beta": Table({ "dc": String("eqdc10"), "ip": String("10.0.0.2") }),
    }),
    "title": String("TOML Example"),
  })
}

///|
test "valid/string/basic-escape-01" {
  let toml_text =
    #|# Escape "
    #|test = "\"one\""
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, { "test": String("\"one\"") })
}

///|
test "valid/string/basic-escape-02" {
  let toml_text =
    #|# Escape \ and then "
    #|test = "\\\"one"
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, { "test": String("\\\"one") })
}

///|
test "valid/string/basic-escape-03" {
  let toml_text =
    #|# Escape \ four times and then "
    #|test = "\\\\\\\\\"one"
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, { "test": String("\\\\\\\\\"one") })
}

///|
test "valid/string/ends-in-whitespace-escape" {
  let toml_text =
    #|beee = """
    #|heeee
    #|geeee\  
    #|
    #|
    #|      """
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, { "beee": String("heeee\ngeeee") })
}

///|
test "invalid/string/escape-esc" {
  let toml_text =
    #|esc = "\e There is no escape! \e"
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "valid/string/escaped-escape" {
  let toml_text =
    #|answer = "\\x64"
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, { "answer": String("\\x64") })
}

///|
test "valid/string/escapes" {
  let toml_text =
    #|backspace     = "|\b."
    #|tab           = "|\t."
    #|newline       = "|\n."
    #|formfeed      = "|\f."
    #|carriage      = "|\r."
    #|quote         = "|\"."
    #|backslash     = "|\\."
    #|delete        = "|\u007F."
    #|unitseparator = "|\u001F."
    #|
    #|# \u is escaped, so should NOT be interperted as a \u escape.
    #|notunicode1   = "|\\u."
    #|notunicode2   = "|\u005Cu."
    #|notunicode3   = "|\\u0075."
    #|notunicode4   = "|\\\u0075."
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "backslash": String("|\\."),
    "backspace": String("|\u{08}."),
    "carriage": String("|\r."),
    "delete": String("|\u{7F}."),
    "formfeed": String("|\u{0C}."),
    "newline": String("|\n."),
    "notunicode1": String("|\\u."),
    "notunicode2": String("|\\u."),
    "notunicode3": String("|\\u0075."),
    "notunicode4": String("|\\u."),
    "quote": String("|\"."),
    "tab": String("|\t."),
    "unitseparator": String("|\u{1F}."),
  })
}

///|
test "valid/string/multibyte-escape" {
  let toml_text =
    #|# Test each multibyte length: 2, 3, and 4 bytes:
    #|# ɑ € 𐫱
    #|
    #|basic-1    = "\u0251 \u20ac \U00010AF1 \u0251\u20ac\U00010AF1"
    #|ml-basic-1 = """\u0251 \u20ac \U00010AF1 \u0251\u20ac\U00010AF1"""
    #|
    #|# Again, but only using \U
    #|basic-2    = "\U00000251 \U000020ac \U00010AF1 \U00000251\U000020ac\U00010AF1"
    #|ml-basic-2 = """\U00000251 \U000020ac \U00010AF1 \U00000251\U000020ac\U00010AF1"""
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "basic-1": String("ɑ € 𐫱 ɑ€𐫱"),
    "basic-2": String("ɑ € 𐫱 ɑ€𐫱"),
    "ml-basic-1": String("ɑ € 𐫱 ɑ€𐫱"),
    "ml-basic-2": String("ɑ € 𐫱 ɑ€𐫱"),
  })
}

///|
test "valid/string/multibyte" {
  let toml_text =
    #|# Test each multibyte length: 2, 3, and 4 bytes:
    #|# ɑ € 𐫱
    #|
    #|basic    = "ɑ € 𐫱 ɑ€𐫱"
    #|raw      = 'ɑ € 𐫱 ɑ€𐫱'
    #|ml-basic = """ɑ € 𐫱 ɑ€𐫱"""
    #|ml-raw   = '''ɑ € 𐫱 ɑ€𐫱'''
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "basic": String("ɑ € 𐫱 ɑ€𐫱"),
    "ml-basic": String("ɑ € 𐫱 ɑ€𐫱"),
    "ml-raw": String("ɑ € 𐫱 ɑ€𐫱"),
    "raw": String("ɑ € 𐫱 ɑ€𐫱"),
  })
}

///|
test "valid/string/multiline-escaped-crlf" {
  let toml_text = "# The following line should be an unescaped backslash followed by a Windows\r\n# newline sequence (\"\\r\\n\")\r\n0=\"\"\"\\\r\n\"\"\"\r\n"
  let toml = @toml.parse(toml_text)
  assert_eq(toml, { "0": String("") })
}

///|
test "valid/string/multiline-quotes" {
  let toml_text =
    #|# Make sure that quotes inside multiline strings are allowed, including right
    #|# after the opening '''/""" and before the closing '''/"""
    #|
    #|lit_one = ''''one quote''''
    #|lit_two = '''''two quotes'''''
    #|lit_one_space = ''' 'one quote' '''
    #|lit_two_space = ''' ''two quotes'' '''
    #|
    #|one = """"one quote""""
    #|two = """""two quotes"""""
    #|one_space = """ "one quote" """
    #|two_space = """ ""two quotes"" """
    #|
    #|mismatch1 = """aaa'''bbb"""
    #|mismatch2 = '''aaa"""bbb'''
    #|
    #|# Three opening """, then one escaped ", then two "" (allowed), and then three
    #|# closing """
    #|escaped = """lol\""""""
    #|
    #|five-quotes = """
    #|Closing with five quotes
    #|"""""
    #|four-quotes = """
    #|Closing with four quotes
    #|""""
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "escaped": String("lol\"\"\""),
    "five-quotes": String("Closing with five quotes\n\"\""),
    "four-quotes": String("Closing with four quotes\n\""),
    "lit_one": String("'one quote'"),
    "lit_one_space": String(" 'one quote' "),
    "lit_two": String("''two quotes''"),
    "lit_two_space": String(" ''two quotes'' "),
    "mismatch1": String("aaa'''bbb"),
    "mismatch2": String("aaa\"\"\"bbb"),
    "one": String("\"one quote\""),
    "one_space": String(" \"one quote\" "),
    "two": String("\"\"two quotes\"\""),
    "two_space": String(" \"\"two quotes\"\" "),
  })
}

///|
test "valid/string/quoted-unicode" {
  let toml_text =
    #|
    #|escaped_string = "\u0000 \u0008 \u000c \U00000041 \u007f \u0080 \u00ff \ud7ff \ue000 \uffff \U00010000 \U0010ffff"
    #|not_escaped_string = '\u0000 \u0008 \u000c \U00000041 \u007f \u0080 \u00ff \ud7ff \ue000 \uffff \U00010000 \U0010ffff'
    #|
    #|basic_string = "~  ÿ ퟿  ￿ 𐀀 􏿿"
    #|literal_string = '~  ÿ ퟿  ￿ 𐀀 􏿿'
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "basic_string": String("~ \u{80} ÿ ퟿  ￿ 𐀀 􏿿"),
    "escaped_string": String(
      "\u{00} \u{08} \u{0C} A \u{7F} \u{80} ÿ ퟿  ￿ 𐀀 􏿿",
    ),
    "literal_string": String("~ \u{80} ÿ ퟿  ￿ 𐀀 􏿿"),
    "not_escaped_string": String(
      "\\u0000 \\u0008 \\u000c \\U00000041 \\u007f \\u0080 \\u00ff \\ud7ff \\ue000 \\uffff \\U00010000 \\U0010ffff",
    ),
  })
}

///|
test "valid/string/raw-multiline" {
  let toml_text =
    #|# Single ' should be allowed.
    #|oneline = '''This string has a ' quote character.'''
    #|
    #|# A newline immediately following the opening delimiter will be trimmed.
    #|firstnl = '''
    #|This string has a ' quote character.'''
    #|
    #|# All other whitespace and newline characters remain intact.
    #|multiline = '''
    #|This string
    #|has ' a quote character
    #|and more than
    #|one newline
    #|in it.'''
    #|
    #|# Tab character in literal string does not need to be escaped
    #|multiline_with_tab = '''First line
    #|	 Followed by a tab'''
    #|
    #|this-str-has-apostrophes='''' there's one already
    #|'' two more
    #|'''''
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "firstnl": String("This string has a ' quote character."),
    "multiline": String(
      "This string\nhas ' a quote character\nand more than\none newline\nin it.",
    ),
    "multiline_with_tab": String("First line\n\t Followed by a tab"),
    "oneline": String("This string has a ' quote character."),
    "this-str-has-apostrophes": String("' there's one already\n'' two more\n''"),
  })
}

///|
test "valid/string/start-mb" {
  let toml_text =
    #|# Start first line with a multibyte character.
    #|#
    #|# https://github.com/marzer/tomlplusplus/issues/190
    #|s1 = "§"
    #|s2 = '§'
    #|s3 = """\
    #|§"""
    #|s4 = """
    #|§"""
    #|s5 = """§"""
    #|s6 = '''
    #|§'''
    #|s7 = '''§'''
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "s1": String("§"),
    "s2": String("§"),
    "s3": String("§"),
    "s4": String("§"),
    "s5": String("§"),
    "s6": String("§"),
    "s7": String("§"),
  })
}

///|
test "valid/string/unicode-escape" {
  let toml_text =
    #|delta-1 = "\u03B4"
    #|delta-2 = "\U000003B4"
    #|a       = "\u0061"
    #|b       = "\u0062"
    #|c       = "\U00000063"
    #|null-1  = "\u0000"
    #|null-2  = "\U00000000"
    #|
    #|ml-delta-1 = """\u03B4"""
    #|ml-delta-2 = """\U000003B4"""
    #|ml-a       = """\u0061"""
    #|ml-b       = """\u0062"""
    #|ml-c       = """\U00000063"""
    #|ml-null-1  = """\u0000"""
    #|ml-null-2  = """\U00000000"""
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "a": String("a"),
    "b": String("b"),
    "c": String("c"),
    "delta-1": String("δ"),
    "delta-2": String("δ"),
    "ml-a": String("a"),
    "ml-b": String("b"),
    "ml-c": String("c"),
    "ml-delta-1": String("δ"),
    "ml-delta-2": String("δ"),
    "ml-null-1": String("\u{00}"),
    "ml-null-2": String("\u{00}"),
    "null-1": String("\u{00}"),
    "null-2": String("\u{00}"),
  })
}

///|
test "valid/table/array-empty-name" {
  let toml_text =
    #|# Silly thing to do, but valid.
    #|
    #|[['']]
    #|a = 1
    #|[['']]
    #|a = 2
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "": Array([Table({ "a": Integer(1) }), Table({ "a": Integer(2) })]),
  })
}

///|
test "valid/table/array-empty" {
  let toml_text =
    #|[[a]]
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, { "a": Array([Table(Map([]))]) })
}

///|
test "valid/table/array-implicit" {
  let toml_text =
    #|[[albums.songs]]
    #|name = "Glory Days"
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "albums": Table({
      "songs": Array([Table({ "name": String("Glory Days") })]),
    }),
  })
}

///|
test "valid/table/array-one" {
  let toml_text =
    #|[[people]]
    #|first_name = "Bruce"
    #|last_name = "Springsteen"
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "people": Array([
      Table({
        "first_name": String("Bruce"),
        "last_name": String("Springsteen"),
      }),
    ]),
  })
}

///|
test "valid/table/keyword-with-values" {
  let toml_text =
    #|[true]
    #|k = 1
    #|
    #|[false]
    #|k = 2
    #|
    #|[inf]
    #|k = 3
    #|
    #|[nan]
    #|k = 4
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "false": Table({ "k": Integer(2) }),
    "inf": Table({ "k": Integer(3) }),
    "nan": Table({ "k": Integer(4) }),
    "true": Table({ "k": Integer(1) }),
  })
}

///|
test "valid/table/names-with-values" {
  let toml_text =
    #|[a.b.c]
    #|key = 1
    #|
    #|[a."b.c"]
    #|key = 2
    #|
    #|[a.'d.e']
    #|key = 3
    #|
    #|[a.' x ']
    #|key = 4
    #|
    #|[ d.e.f ]
    #|key = 5
    #|
    #|[ g . h . i ]
    #|key = 6
    #|
    #|[ j . "ʞ" . 'l' ]
    #|key = 7
    #|
    #|[x.1.2]
    #|key = 8
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "a": Table({
      " x ": Table({ "key": Integer(4) }),
      "b": Table({ "c": Table({ "key": Integer(1) }) }),
      "b.c": Table({ "key": Integer(2) }),
      "d.e": Table({ "key": Integer(3) }),
    }),
    "d": Table({ "e": Table({ "f": Table({ "key": Integer(5) }) }) }),
    "g": Table({ "h": Table({ "i": Table({ "key": Integer(6) }) }) }),
    "j": Table({ "ʞ": Table({ "l": Table({ "key": Integer(7) }) }) }),
    "x": Table({ "1": Table({ "2": Table({ "key": Integer(8) }) }) }),
  })
}

///|
test "valid/table/sub-empty" {
  let toml_text =
    #|[a]
    #|[a.b]
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, { "a": Table({ "b": Table(Map([])) }) })
}

///|
test "valid/table/without-super-with-values" {
  let toml_text =
    #|# [x] you
    #|# [x.y] don't
    #|# [x.y.z] need these
    #|[x.y.z.w] # for this to work
    #|a = 1
    #|b = 2
    #|[x] # defining a super-table afterwards is ok
    #|c = 3
    #|d = 4
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "x": Table({
      "c": Integer(3),
      "d": Integer(4),
      "y": Table({
        "z": Table({ "w": Table({ "a": Integer(1), "b": Integer(2) }) }),
      }),
    }),
  })
}

///|
test "valid/table/without-super" {
  let toml_text =
    #|# [x] you
    #|# [x.y] don't
    #|# [x.y.z] need these
    #|[x.y.z.w] # for this to work
    #|[x] # defining a super-table afterwards is ok
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "x": Table({ "y": Table({ "z": Table({ "w": Table(Map([])) }) }) }),
  })
}

///|
test "valid/datetime/edge" {
  let toml_text =
    #|first-offset = 0001-01-01 00:00:00Z
    #|first-local  = 0001-01-01 00:00:00
    #|first-date   = 0001-01-01
    #|
    #|last-offset = 9999-12-31 23:59:59Z
    #|last-local  = 9999-12-31 23:59:59
    #|last-date   = 9999-12-31
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "first-date": LocalDate({ year: 1, month: 1, day: 1, }),
    "first-local": LocalDatetime({ year: 1, month: 1, day: 1, }, {
      hour: 0,
      minute: 0,
      second: 0,
      nanosecond: 0,
    }),
    "first-offset": Datetime(
      { year: 1, month: 1, day: 1, },
      { hour: 0, minute: 0, second: 0, nanosecond: 0, },
      offset=0,
    ),
    "last-date": LocalDate({ year: 9999, month: 12, day: 31, }),
    "last-local": LocalDatetime({ year: 9999, month: 12, day: 31, }, {
      hour: 23,
      minute: 59,
      second: 59,
      nanosecond: 0,
    }),
    "last-offset": Datetime(
      { year: 9999, month: 12, day: 31, },
      { hour: 23, minute: 59, second: 59, nanosecond: 0, },
      offset=0,
    ),
  })
}

///|
test "valid/datetime/invalid-date-in-string" {
  let toml_text =
    #|s = '2020-01-01x'
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, { "s": String("2020-01-01x") })
}

///|
test "valid/datetime/leap-year" {
  let toml_text =
    #|2000-datetime       = 2000-02-29 15:15:15Z
    #|2000-datetime-local = 2000-02-29 15:15:15
    #|2000-date           = 2000-02-29
    #|
    #|2024-datetime       = 2024-02-29 15:15:15Z
    #|2024-datetime-local = 2024-02-29 15:15:15
    #|2024-date           = 2024-02-29
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "2000-date": LocalDate({ year: 2000, month: 2, day: 29, }),
    "2000-datetime": Datetime(
      { year: 2000, month: 2, day: 29, },
      { hour: 15, minute: 15, second: 15, nanosecond: 0, },
      offset=0,
    ),
    "2000-datetime-local": LocalDatetime({ year: 2000, month: 2, day: 29, }, {
      hour: 15,
      minute: 15,
      second: 15,
      nanosecond: 0,
    }),
    "2024-date": LocalDate({ year: 2024, month: 2, day: 29, }),
    "2024-datetime": Datetime(
      { year: 2024, month: 2, day: 29, },
      { hour: 15, minute: 15, second: 15, nanosecond: 0, },
      offset=0,
    ),
    "2024-datetime-local": LocalDatetime({ year: 2024, month: 2, day: 29, }, {
      hour: 15,
      minute: 15,
      second: 15,
      nanosecond: 0,
    }),
  })
}

///|
test "valid/inline-table/array-01" {
  let toml_text =
    #|arr = [ {'a'= 1}, {'a'= 2} ]
    #|
    #|people = [{first_name = "Bruce", last_name = "Springsteen"},
    #|          {first_name = "Eric", last_name = "Clapton"},
    #|          {first_name = "Bob", last_name = "Seger"}]
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "arr": Array([Table({ "a": Integer(1) }), Table({ "a": Integer(2) })]),
    "people": Array([
      Table({
        "first_name": String("Bruce"),
        "last_name": String("Springsteen"),
      }),
      Table({ "first_name": String("Eric"), "last_name": String("Clapton") }),
      Table({ "first_name": String("Bob"), "last_name": String("Seger") }),
    ]),
  })
}

///|
test "valid/inline-table/array-02" {
  let toml_text =
    #|# "No newlines are allowed between the curly braces unless they are valid within
    #|# a value"
    #|
    #|a = { a = [
    #|]}
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, { "a": Table({ "a": Array([]) }) })
}

///|
test "valid/inline-table/array-03" {
  let toml_text =
    #|b = { a = [
    #|		1,
    #|		2,
    #|	], b = [
    #|		3,
    #|		4,
    #|	]}
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "b": Table({
      "a": Array([Integer(1), Integer(2)]),
      "b": Array([Integer(3), Integer(4)]),
    }),
  })
}

///|
test "valid/inline-table/inline-table" {
  let toml_text =
    #|name        = { first = "Tom", last = "Preston-Werner" }
    #|point       = { x = 1, y = 2 }
    #|simple      = { a = 1 }
    #|str-key     = { "a" = 1 }
    #|table-array = [{ "a" = 1 }, { "b" = 2 }]
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "name": Table({ "first": String("Tom"), "last": String("Preston-Werner") }),
    "point": Table({ "x": Integer(1), "y": Integer(2) }),
    "simple": Table({ "a": Integer(1) }),
    "str-key": Table({ "a": Integer(1) }),
    "table-array": Array([
      Table({ "a": Integer(1) }),
      Table({ "b": Integer(2) }),
    ]),
  })
}

///|
test "valid/inline-table/key-dotted-01" {
  let toml_text =
    #|a = {   a.b  =  1   }
    #|b = {   "a"."b"  =  1   }
    #|c = {   a   .   b  =  1   }
    #|d = {   'a'   .   "b"  =  1   }
    #|e = {a.b=1}
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "a": Table({ "a": Table({ "b": Integer(1) }) }),
    "b": Table({ "a": Table({ "b": Integer(1) }) }),
    "c": Table({ "a": Table({ "b": Integer(1) }) }),
    "d": Table({ "a": Table({ "b": Integer(1) }) }),
    "e": Table({ "a": Table({ "b": Integer(1) }) }),
  })
}

///|
test "valid/inline-table/key-dotted-02" {
  let toml_text =
    #|many.dots.here.dot.dot.dot = {a.b.c = 1, a.b.d = 2}
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "many": Table({
      "dots": Table({
        "here": Table({
          "dot": Table({
            "dot": Table({
              "dot": Table({
                "a": Table({ "b": Table({ "c": Integer(1), "d": Integer(2) }) }),
              }),
            }),
          }),
        }),
      }),
    }),
  })
}

///|
test "valid/inline-table/key-dotted-03" {
  let toml_text =
    #|[tbl]
    #|a.b.c = {d.e=1}
    #|
    #|[tbl.x]
    #|a.b.c = {d.e=1}
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "tbl": Table({
      "a": Table({
        "b": Table({ "c": Table({ "d": Table({ "e": Integer(1) }) }) }),
      }),
      "x": Table({
        "a": Table({
          "b": Table({ "c": Table({ "d": Table({ "e": Integer(1) }) }) }),
        }),
      }),
    }),
  })
}

///|
test "valid/inline-table/key-dotted-04" {
  let toml_text =
    #|[[arr]]
    #|t = {a.b=1}
    #|T = {a.b=1}
    #|
    #|[[arr]]
    #|t = {a.b=2}
    #|T = {a.b=2}
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "arr": Array([
      Table({
        "T": Table({ "a": Table({ "b": Integer(1) }) }),
        "t": Table({ "a": Table({ "b": Integer(1) }) }),
      }),
      Table({
        "T": Table({ "a": Table({ "b": Integer(2) }) }),
        "t": Table({ "a": Table({ "b": Integer(2) }) }),
      }),
    ]),
  })
}

///|
test "valid/inline-table/key-dotted-05" {
  let toml_text =
    #|arr-1 = [{a.b = 1}]
    #|arr-2 = ["str", {a.b = 1}]
    #|
    #|arr-3 = [{a.b = 1}, {a.b = 2}]
    #|arr-4 = ["str", {a.b = 1}, {a.b = 2}]
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "arr-1": Array([Table({ "a": Table({ "b": Integer(1) }) })]),
    "arr-2": Array([String("str"), Table({ "a": Table({ "b": Integer(1) }) })]),
    "arr-3": Array([
      Table({ "a": Table({ "b": Integer(1) }) }),
      Table({ "a": Table({ "b": Integer(2) }) }),
    ]),
    "arr-4": Array([
      String("str"),
      Table({ "a": Table({ "b": Integer(1) }) }),
      Table({ "a": Table({ "b": Integer(2) }) }),
    ]),
  })
}

///|
test "valid/inline-table/key-dotted-06" {
  let toml_text =
    #|top.dot.dot = [
    #|	{dot.dot.dot = 1},
    #|	{dot.dot.dot = 2},
    #|]
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "top": Table({
      "dot": Table({
        "dot": Array([
          Table({ "dot": Table({ "dot": Table({ "dot": Integer(1) }) }) }),
          Table({ "dot": Table({ "dot": Table({ "dot": Integer(2) }) }) }),
        ]),
      }),
    }),
  })
}

///|
test "valid/inline-table/key-dotted-07" {
  let toml_text =
    #|arr = [
    #|	{a.b = [{c.d = 1}]}
    #|]
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "arr": Array([
      Table({
        "a": Table({ "b": Array([Table({ "c": Table({ "d": Integer(1) }) })]) }),
      }),
    ]),
  })
}

///|
test "valid/inline-table/multiline" {
  let toml_text =
    #|tbl_multiline = { a = 1, b = """
    #|multiline
    #|""", c = """and yet
    #|another line""", d = 4 }
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "tbl_multiline": Table({
      "a": Integer(1),
      "b": String("multiline\n"),
      "c": String("and yet\nanother line"),
      "d": Integer(4),
    }),
  })
}

///|
test "valid/inline-table/nest" {
  let toml_text =
    #|tbl_tbl_empty = { tbl_0 = {} }
    #|tbl_tbl_val   = { tbl_1 = { one = 1 } }
    #|tbl_arr_tbl   = { arr_tbl = [ { one = 1 } ] }
    #|arr_tbl_tbl   = [ { tbl = { one = 1 } } ]
    #|
    #|# Array-of-array-of-table is interesting because it can only
    #|# be represented in inline form.
    #|arr_arr_tbl_empty = [ [ {} ] ]
    #|arr_arr_tbl_val = [ [ { one = 1 } ] ]
    #|arr_arr_tbls  = [ [ { one = 1 }, { two = 2 } ] ]
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "arr_arr_tbl_empty": Array([Array([Table(Map([]))])]),
    "arr_arr_tbl_val": Array([Array([Table({ "one": Integer(1) })])]),
    "arr_arr_tbls": Array([
      Array([Table({ "one": Integer(1) }), Table({ "two": Integer(2) })]),
    ]),
    "arr_tbl_tbl": Array([Table({ "tbl": Table({ "one": Integer(1) }) })]),
    "tbl_arr_tbl": Table({ "arr_tbl": Array([Table({ "one": Integer(1) })]) }),
    "tbl_tbl_empty": Table({ "tbl_0": Table(Map([])) }),
    "tbl_tbl_val": Table({ "tbl_1": Table({ "one": Integer(1) }) }),
  })
}

///|
test "valid/spec-1.0.0/array-of-tables-0" {
  let toml_text =
    #|[[products]]
    #|name = "Hammer"
    #|sku = 738594937
    #|
    #|[[products]]  # empty table within the array
    #|
    #|[[products]]
    #|name = "Nail"
    #|sku = 284758393
    #|
    #|color = "gray"
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "products": Array([
      Table({ "name": String("Hammer"), "sku": Integer(738594937) }),
      Table(Map([])),
      Table({
        "color": String("gray"),
        "name": String("Nail"),
        "sku": Integer(284758393),
      }),
    ]),
  })
}

///|
test "valid/spec-1.0.0/array-of-tables-1" {
  let toml_text =
    #|[[fruits]]
    #|name = "apple"
    #|
    #|[fruits.physical]  # subtable
    #|color = "red"
    #|shape = "round"
    #|
    #|[[fruits.varieties]]  # nested array of tables
    #|name = "red delicious"
    #|
    #|[[fruits.varieties]]
    #|name = "granny smith"
    #|
    #|
    #|[[fruits]]
    #|name = "banana"
    #|
    #|[[fruits.varieties]]
    #|name = "plantain"
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "fruits": Array([
      Table({
        "name": String("apple"),
        "physical": Table({ "color": String("red"), "shape": String("round") }),
        "varieties": Array([
          Table({ "name": String("red delicious") }),
          Table({ "name": String("granny smith") }),
        ]),
      }),
      Table({
        "name": String("banana"),
        "varieties": Array([Table({ "name": String("plantain") })]),
      }),
    ]),
  })
}

///|
test "valid/spec-1.0.0/array-of-tables-2" {
  let toml_text =
    #|points = [ { x = 1, y = 2, z = 3 },
    #|           { x = 7, y = 8, z = 9 },
    #|           { x = 2, y = 4, z = 8 } ]
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "points": Array([
      Table({ "x": Integer(1), "y": Integer(2), "z": Integer(3) }),
      Table({ "x": Integer(7), "y": Integer(8), "z": Integer(9) }),
      Table({ "x": Integer(2), "y": Integer(4), "z": Integer(8) }),
    ]),
  })
}

///|
test "valid/spec-1.0.0/inline-table-0" {
  let toml_text =
    #|name = { first = "Tom", last = "Preston-Werner" }
    #|point = { x = 1, y = 2 }
    #|animal = { type.name = "pug" }
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "animal": Table({ "type": Table({ "name": String("pug") }) }),
    "name": Table({ "first": String("Tom"), "last": String("Preston-Werner") }),
    "point": Table({ "x": Integer(1), "y": Integer(2) }),
  })
}

///|
test "valid/spec-1.0.0/inline-table-1" {
  let toml_text =
    #|[name]
    #|first = "Tom"
    #|last = "Preston-Werner"
    #|
    #|[point]
    #|x = 1
    #|y = 2
    #|
    #|[animal]
    #|type.name = "pug"
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "animal": Table({ "type": Table({ "name": String("pug") }) }),
    "name": Table({ "first": String("Tom"), "last": String("Preston-Werner") }),
    "point": Table({ "x": Integer(1), "y": Integer(2) }),
  })
}

///|
test "valid/spec-1.0.0/inline-table-2" {
  let toml_text =
    #|[product]
    #|type = { name = "Nail" }
    #|# type.edible = false  # INVALID
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "product": Table({ "type": Table({ "name": String("Nail") }) }),
  })
}

///|
test "valid/spec-1.0.0/inline-table-3" {
  let toml_text =
    #|[product]
    #|type.name = "Nail"
    #|# type = { edible = false }  # INVALID
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "product": Table({ "type": Table({ "name": String("Nail") }) }),
  })
}

///|
test "valid/spec-1.1.0/common-0" {
  let toml_text =
    #|# This is a full-line comment
    #|key = "value"  # This is a comment at the end of a line
    #|another = "# This is not a comment"
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "another": String("# This is not a comment"),
    "key": String("value"),
  })
}

///|
test "valid/spec-1.1.0/common-10" {
  let toml_text =
    #|# RECOMMENDED
    #|
    #|apple.type = "fruit"
    #|apple.skin = "thin"
    #|apple.color = "red"
    #|
    #|orange.type = "fruit"
    #|orange.skin = "thick"
    #|orange.color = "orange"
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "apple": Table({
      "color": String("red"),
      "skin": String("thin"),
      "type": String("fruit"),
    }),
    "orange": Table({
      "color": String("orange"),
      "skin": String("thick"),
      "type": String("fruit"),
    }),
  })
}

///|
test "valid/spec-1.1.0/common-11" {
  let toml_text =
    #|3.14159 = "pi"
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, { "3": Table({ "14159": String("pi") }) })
}

///|
test "valid/spec-1.1.0/common-13" {
  let toml_text =
    #|str1 = """
    #|Roses are red
    #|Violets are blue"""
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, { "str1": String("Roses are red\nViolets are blue") })
}

///|
test "valid/spec-1.1.0/common-14" {
  let toml_text =
    #|# On a Unix system, the above multi-line string will most likely be the same as:
    #|str2 = "Roses are red\nViolets are blue"
    #|
    #|# On a Windows system, it will most likely be equivalent to:
    #|str3 = "Roses are red\r\nViolets are blue"
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "str2": String("Roses are red\nViolets are blue"),
    "str3": String("Roses are red\r\nViolets are blue"),
  })
}

///|
test "valid/spec-1.1.0/common-15" {
  let toml_text =
    #|# The following strings are byte-for-byte equivalent:
    #|str1 = "The quick brown fox jumps over the lazy dog."
    #|
    #|str2 = """
    #|The quick brown \
    #|
    #|
    #|  fox jumps over \
    #|    the lazy dog."""
    #|
    #|str3 = """\
    #|       The quick brown \
    #|       fox jumps over \
    #|       the lazy dog.\
    #|       """
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "str1": String("The quick brown fox jumps over the lazy dog."),
    "str2": String("The quick brown fox jumps over the lazy dog."),
    "str3": String("The quick brown fox jumps over the lazy dog."),
  })
}

///|
test "valid/spec-1.1.0/common-16" {
  let toml_text =
    #|str4 = """Here are two quotation marks: "". Simple enough."""
    #|# str5 = """Here are three quotation marks: """."""  # INVALID
    #|str5 = """Here are three quotation marks: ""\"."""
    #|str6 = """Here are fifteen quotation marks: ""\"""\"""\"""\"""\"."""
    #|
    #|# "This," she said, "is just a pointless statement."
    #|str7 = """"This," she said, "is just a pointless statement.""""
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "str4": String("Here are two quotation marks: \"\". Simple enough."),
    "str5": String("Here are three quotation marks: \"\"\"."),
    "str6": String(
      "Here are fifteen quotation marks: \"\"\"\"\"\"\"\"\"\"\"\"\"\"\".",
    ),
    "str7": String("\"This,\" she said, \"is just a pointless statement.\""),
  })
}

///|
test "valid/spec-1.1.0/common-17" {
  let toml_text =
    #|# What you see is what you get.
    #|winpath  = 'C:\Users\nodejs\templates'
    #|winpath2 = '\\ServerX\admin$\system32\'
    #|quoted   = 'Tom "Dubs" Preston-Werner'
    #|regex    = '<\i\c*\s*>'
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "quoted": String("Tom \"Dubs\" Preston-Werner"),
    "regex": String("<\\i\\c*\\s*>"),
    "winpath": String("C:\\Users\\nodejs\\templates"),
    "winpath2": String("\\\\ServerX\\admin$\\system32\\"),
  })
}

///|
test "valid/spec-1.1.0/common-18" {
  let toml_text =
    #|regex2 = '''I [dw]on't need \d{2} apples'''
    #|lines  = '''
    #|The first newline is
    #|trimmed in literal strings.
    #|   All other whitespace
    #|   is preserved.
    #|'''
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "lines": String(
      "The first newline is\ntrimmed in literal strings.\n   All other whitespace\n   is preserved.\n",
    ),
    "regex2": String("I [dw]on't need \\d{2} apples"),
  })
}

///|
test "valid/spec-1.1.0/common-19" {
  let toml_text =
    #|quot15 = '''Here are fifteen quotation marks: """""""""""""""'''
    #|
    #|# apos15 = '''Here are fifteen apostrophes: ''''''''''''''''''  # INVALID
    #|apos15 = "Here are fifteen apostrophes: '''''''''''''''"
    #|
    #|# 'That,' she said, 'is still pointless.'
    #|str = ''''That,' she said, 'is still pointless.''''
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "apos15": String("Here are fifteen apostrophes: '''''''''''''''"),
    "quot15": String(
      "Here are fifteen quotation marks: \"\"\"\"\"\"\"\"\"\"\"\"\"\"\"",
    ),
    "str": String("'That,' she said, 'is still pointless.'"),
  })
}

///|
test "valid/spec-1.1.0/common-1" {
  let toml_text =
    #|key = "value"
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, { "key": String("value") })
}

///|
test "valid/spec-1.1.0/common-20" {
  let toml_text =
    #|int1 = +99
    #|int2 = 42
    #|int3 = 0
    #|int4 = -17
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "int1": Integer(99),
    "int2": Integer(42),
    "int3": Integer(0),
    "int4": Integer(-17),
  })
}

///|
test "valid/spec-1.1.0/common-21" {
  let toml_text =
    #|int5 = 1_000
    #|int6 = 5_349_221
    #|int7 = 53_49_221  # Indian number system grouping
    #|int8 = 1_2_3_4_5  # VALID but discouraged
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "int5": Integer(1000),
    "int6": Integer(5349221),
    "int7": Integer(5349221),
    "int8": Integer(12345),
  })
}

///|
test "valid/spec-1.1.0/common-22" {
  let toml_text =
    #|# hexadecimal with prefix `0x`
    #|hex1 = 0xDEADBEEF
    #|hex2 = 0xdeadbeef
    #|hex3 = 0xdead_beef
    #|
    #|# octal with prefix `0o`
    #|oct1 = 0o01234567
    #|oct2 = 0o755 # useful for Unix file permissions
    #|
    #|# binary with prefix `0b`
    #|bin1 = 0b11010110
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "bin1": Integer(214),
    "hex1": Integer(3735928559),
    "hex2": Integer(3735928559),
    "hex3": Integer(3735928559),
    "oct1": Integer(342391),
    "oct2": Integer(493),
  })
}

///|
test "valid/spec-1.1.0/common-23" {
  let toml_text =
    #|# fractional
    #|flt1 = +1.0
    #|flt2 = 3.1415
    #|flt3 = -0.01
    #|
    #|# exponent
    #|flt4 = 5e+22
    #|flt5 = 1e06
    #|flt6 = -2E-2
    #|
    #|# both
    #|flt7 = 6.626e-34
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "flt1": Float(1.0),
    "flt2": Float(3.1415),
    "flt3": Float(-0.01),
    "flt4": Float(5.0e22),
    "flt5": Float(1.0e6),
    "flt6": Float(-0.02),
    "flt7": Float(6.626e-34),
  })
}

///|
test "valid/spec-1.1.0/common-24" {
  let toml_text =
    #|flt8 = 224_617.445_991_228
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, { "flt8": Float(224617.445991228) })
}

///|
test "valid/spec-1.1.0/common-25" {
  let toml_text =
    #|# infinity
    #|sf1 = inf  # positive infinity
    #|sf2 = +inf # positive infinity
    #|sf3 = -inf # negative infinity
    #|
    #|# not a number
    #|sf4 = nan  # actual sNaN/qNaN encoding is implementation-specific
    #|sf5 = +nan # same as `nan`
    #|sf6 = -nan # valid, actual encoding is implementation-specific
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "sf1": Float(@double.infinity),
    "sf2": Float(@double.infinity),
    "sf3": Float(@double.neg_infinity),
    "sf4": Float(@double.not_a_number),
    "sf5": Float(@double.not_a_number),
    "sf6": Float(@double.not_a_number),
  })
}

///|
test "valid/spec-1.1.0/common-26" {
  let toml_text =
    #|bool1 = true
    #|bool2 = false
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, { "bool1": Bool(true), "bool2": Bool(false) })
}

///|
test "valid/string/escape-tricky" {
  let toml_text =
    #|end_esc = "String does not end here\" but ends here\\"
    #|lit_end_esc = 'String ends here\'
    #|
    #|multiline_unicode = """
    #|\u00a0"""
    #|
    #|multiline_not_unicode = """
    #|\\u0041"""
    #|
    #|multiline_end_esc = """When will it end? \"""...""\" should be here\""""
    #|
    #|lit_multiline_not_unicode = '''
    #|\u007f'''
    #|
    #|lit_multiline_end = '''There is no escape\'''
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "end_esc": String("String does not end here\" but ends here\\"),
    "lit_end_esc": String("String ends here\\"),
    "lit_multiline_end": String("There is no escape\\"),
    "lit_multiline_not_unicode": String("\\u007f"),
    "multiline_end_esc": String(
      "When will it end? \"\"\"...\"\"\" should be here\"",
    ),
    "multiline_not_unicode": String("\\u0041"),
    "multiline_unicode": String(" "),
  })
}

///|
test "valid/table/array-implicit-and-explicit-after" {
  let toml_text =
    #|[[a.b]]
    #|x = 1
    #|
    #|[a]
    #|y = 2
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "a": Table({ "b": Array([Table({ "x": Integer(1) })]), "y": Integer(2) }),
  })
}

///|
test "valid/table/array-many" {
  let toml_text =
    #|[[people]]
    #|first_name = "Bruce"
    #|last_name = "Springsteen"
    #|
    #|[[people]]
    #|first_name = "Eric"
    #|last_name = "Clapton"
    #|
    #|[[people]]
    #|first_name = "Bob"
    #|last_name = "Seger"
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "people": Array([
      Table({
        "first_name": String("Bruce"),
        "last_name": String("Springsteen"),
      }),
      Table({ "first_name": String("Eric"), "last_name": String("Clapton") }),
      Table({ "first_name": String("Bob"), "last_name": String("Seger") }),
    ]),
  })
}

///|
test "valid/table/array-nest" {
  let toml_text =
    #|[[albums]]
    #|name = "Born to Run"
    #|
    #|  [[albums.songs]]
    #|  name = "Jungleland"
    #|
    #|  [[albums.songs]]
    #|  name = "Meeting Across the River"
    #|
    #|[[albums]]
    #|name = "Born in the USA"
    #|  
    #|  [[albums.songs]]
    #|  name = "Glory Days"
    #|
    #|  [[albums.songs]]
    #|  name = "Dancing in the Dark"
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "albums": Array([
      Table({
        "name": String("Born to Run"),
        "songs": Array([
          Table({ "name": String("Jungleland") }),
          Table({ "name": String("Meeting Across the River") }),
        ]),
      }),
      Table({
        "name": String("Born in the USA"),
        "songs": Array([
          Table({ "name": String("Glory Days") }),
          Table({ "name": String("Dancing in the Dark") }),
        ]),
      }),
    ]),
  })
}

///|
test "valid/table/array-table-array" {
  let toml_text =
    #|[[a]]
    #|    [[a.b]]
    #|        [a.b.c]
    #|            d = "val0"
    #|    [[a.b]]
    #|        [a.b.c]
    #|            d = "val1"
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "a": Array([
      Table({
        "b": Array([
          Table({ "c": Table({ "d": String("val0") }) }),
          Table({ "c": Table({ "d": String("val1") }) }),
        ]),
      }),
    ]),
  })
}

///|
test "valid/table/array-within-dotted" {
  let toml_text =
    #|[fruit]
    #|apple.color = "red"
    #|
    #|[[fruit.apple.seeds]]
    #|size = 2
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "fruit": Table({
      "apple": Table({
        "color": String("red"),
        "seeds": Array([Table({ "size": Integer(2) })]),
      }),
    }),
  })
}

///|
test "invalid/integer/int64-overflow-02" {
  let toml_text =
    #|# one below the signed 64-bit minimum
    #|v = -9223372036854775809
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/integer/int64-overflow-hex" {
  let toml_text =
    #|# 2^64 in hexadecimal
    #|v = 0x10000000000000000
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "valid/datetime/fraction-truncated" {
  let toml_text =
    #|# Digits beyond nanosecond precision are truncated, not rounded:
    #|# rounding .1234567899 would give 123456790.
    #|trunc = 1979-05-27T07:32:00.1234567899Z
    #|trunc-max = 07:32:00.9999999999
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "trunc": Datetime(
      { year: 1979, month: 5, day: 27, },
      { hour: 7, minute: 32, second: 0, nanosecond: 123456789, },
      offset=0,
    ),
    "trunc-max": LocalTime({
      hour: 7,
      minute: 32,
      second: 0,
      nanosecond: 999999999,
    }),
  })
}

///|
test "invalid/datetime/offset-hour-24-negative" {
  let toml_text =
    #|# same boundary on the western side
    #|d = 1985-06-18 17:04:07-24:00
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "valid/datetime/offset-max" {
  let toml_text =
    #|# The largest offsets RFC 3339 allows, in both directions.
    #|east = 1985-06-18T17:04:07+23:59
    #|west = 1985-06-18T17:04:07-23:59
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "east": Datetime(
      { year: 1985, month: 6, day: 18, },
      { hour: 17, minute: 4, second: 7, nanosecond: 0, },
      offset=1439,
    ),
    "west": Datetime(
      { year: 1985, month: 6, day: 18, },
      { hour: 17, minute: 4, second: 7, nanosecond: 0, },
      offset=-1439,
    ),
  })
}

///|
test "invalid/integer/int64-overflow-oct-signed" {
  let toml_text =
    #|# the same boundary in octal
    #|v = 0o1000000000000000000000
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/integer/int64-overflow-bin-signed" {
  let toml_text =
    #|# the same boundary in binary
    #|v = 0b1000000000000000000000000000000000000000000000000000000000000000
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "invalid/integer/int64-overflow-hex-uint-max" {
  let toml_text =
    #|# 2^64 - 1: the largest value a UInt64 accumulator holds without
    #|# overflowing, so it is the far end of the range wrapping admits.
    #|v = 0xffffffffffffffff
    #|
  @test.assert_raise(() => @toml.parse(toml_text))
}

///|
test "valid/integer/radix-signed-max" {
  let toml_text =
    #|# 2^63 - 1 in every radix: the largest integer TOML must accept.
    #|h = 0x7fffffffffffffff
    #|o = 0o777777777777777777777
    #|b = 0b111111111111111111111111111111111111111111111111111111111111111
    #|
  let toml = @toml.parse(toml_text)
  assert_eq(toml, {
    "h": Integer(9223372036854775807),
    "o": Integer(9223372036854775807),
    "b": Integer(9223372036854775807),
  })
}

///|
test "print/escape-roundtrip" {
  // TOML v1.0.0 basic strings must escape `"`, `\\`, and the control
  // characters U+0000-U+0008, U+000A-U+001F and U+007F. Tab (U+0009) is the
  // one control character allowed to stand for itself. Every member of the
  // ranges is checked, so a printer must derive its escapes from the ranges
  // themselves.
  let specials = ['"', '\\']
  for n in 0x00..<=0x08 {
    specials.push(Int::unsafe_to_char(n))
  }
  for n in 0x0A..<=0x1F {
    specials.push(Int::unsafe_to_char(n))
  }
  specials.push('\u{7F}')
  for c in specials {
    let s = String::from_array(['a', c, 'b'])
    // the same character in key position and in value position
    let doc : Map[String, @toml.Toml] = Map([(s, String(s))])
    assert_eq(@toml.parse(@toml.print(doc)), doc)
  }
}

///|
test "parse/stringview-window" {
  // `parse` takes a StringView: the document is the view's window. The
  // backing string carries text that is not TOML on both sides, so a parse
  // that widens to `StringView::data()` sees a syntax error.
  let backing = "@@@ not toml @@@\na = 1\n@@@ also not toml @@@"
  let start = backing.find("a = 1").unwrap()
  let view = backing[start:start + 6]
  assert_eq(@toml.parse(view), { "a": Integer(1) })
}

///|
test "print/escape-roundtrip-bare" {
  // A lone control character, with no ordinary characters around it, and the
  // empty key -- which must print as `""` rather than bare.
  let doc : Map[String, @toml.Toml] = Map([
    ("", String("\u{7F}")),
    ("\u{7F}", String("")),
    ("\r\n", String("\r\n")),
  ])
  assert_eq(@toml.parse(@toml.print(doc)), doc)
}
