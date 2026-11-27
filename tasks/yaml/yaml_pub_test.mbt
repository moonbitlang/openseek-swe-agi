///|
test "229Q" {
  let in_yaml =
    #|-
    #|  name: Mark McGwire
    #|  hr:   65
    #|  avg:  0.278
    #|-
    #|  name: Sammy Sosa
    #|  hr:   63
    #|  avg:  0.288
    #|
  let expected : Array[@yaml.Yaml] = [
    Sequence([
      Mapping(
        Map([
          (String("name"), String("Mark McGwire")),
          (String("hr"), Integer(65)),
          (String("avg"), Float(0.278)),
        ]),
      ),
      Mapping(
        Map([
          (String("name"), String("Sammy Sosa")),
          (String("hr"), Integer(63)),
          (String("avg"), Float(0.288)),
        ]),
      ),
    ]),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "236B" {
  let in_yaml =
    #|foo:
    #|  bar
    #|invalid
    #|
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "26DV" {
  let in_yaml =
    #|"top1" : 
    #|  "key1" : &alias1 scalar1
    #|'top2' : 
    #|  'key2' : &alias2 scalar2
    #|top3: &node3 
    #|  *alias1 : scalar3
    #|top4: 
    #|  *alias2 : scalar4
    #|top5   :    
    #|  scalar5
    #|top6: 
    #|  &anchor6 'key6' : scalar6
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(
      Map([
        (String("top1"), Mapping(Map([(String("key1"), String("scalar1"))]))),
        (String("top2"), Mapping(Map([(String("key2"), String("scalar2"))]))),
        (String("top3"), Mapping(Map([(String("scalar1"), String("scalar3"))]))),
        (String("top4"), Mapping(Map([(String("scalar2"), String("scalar4"))]))),
        (String("top5"), String("scalar5")),
        (String("top6"), Mapping(Map([(String("key6"), String("scalar6"))]))),
      ]),
    ),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "27NA" {
  let in_yaml =
    #|%YAML 1.2
    #|--- text
    #|
  let expected : Array[@yaml.Yaml] = [String("text")]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "2AUY" {
  let in_yaml =
    #| - !!str a
    #| - b
    #| - !!int 42
    #| - d
    #|
  let expected : Array[@yaml.Yaml] = [
    Sequence([String("a"), String("b"), Integer(42), String("d")]),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "2CMS" {
  let in_yaml =
    #|this
    #| is
    #|  invalid: x
    #|
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "2EBW" {
  let in_yaml =
    #|a!"#$%&'()*+,-./09:;<=>?@AZ[\]^_`az{|}~: safe
    #|?foo: safe question mark
    #|:foo: safe colon
    #|-foo: safe dash
    #|this is#not: a comment
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(
      Map([
        (String("a!\"#$%&'()*+,-./09:;<=>?@AZ[\\]^_`az{|}~"), String("safe")),
        (String("?foo"), String("safe question mark")),
        (String(":foo"), String("safe colon")),
        (String("-foo"), String("safe dash")),
        (String("this is#not"), String("a comment")),
      ]),
    ),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "2LFX" {
  let in_yaml =
    #|%FOO  bar baz # Should be ignored
    #|              # with a warning.
    #|---
    #|"foo"
    #|
  let expected : Array[@yaml.Yaml] = [String("foo")]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "2SXE" {
  let in_yaml =
    #|&a: key: &a value
    #|foo:
    #|  *a:
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(
      Map([(String("key"), String("value")), (String("foo"), String("key"))]),
    ),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "2XXW" {
  let in_yaml =
    #|# Sets are represented as a
    #|# Mapping where each key is
    #|# associated with a null value
    #|--- !!set
    #|? Mark McGwire
    #|? Sammy Sosa
    #|? Ken Griff
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(
      Map([
        (String("Mark McGwire"), Null),
        (String("Sammy Sosa"), Null),
        (String("Ken Griff"), Null),
      ]),
    ),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "33X3" {
  let in_yaml =
    #|---
    #|- !!int 1
    #|- !!int -2
    #|- !!int 33
    #|
  let expected : Array[@yaml.Yaml] = [
    Sequence([Integer(1), Integer(-2), Integer(33)]),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "35KP" {
  let in_yaml =
    #|--- !!map
    #|? a
    #|: b
    #|--- !!seq
    #|- !!str c
    #|--- !!str
    #|d
    #|e
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(Map([(String("a"), String("b"))])),
    Sequence([String("c")]),
    String("d e"),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "36F6" {
  let in_yaml =
    #|---
    #|plain: a
    #| b
    #|
    #| c
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(Map([(String("plain"), String("a b\nc"))])),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "3ALJ" {
  let in_yaml =
    #|- - s1_i1
    #|  - s1_i2
    #|- s2
    #|
  let expected : Array[@yaml.Yaml] = [
    Sequence([Sequence([String("s1_i1"), String("s1_i2")]), String("s2")]),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "3GZX" {
  let in_yaml =
    #|First occurrence: &anchor Foo
    #|Second occurrence: *anchor
    #|Override anchor: &anchor Bar
    #|Reuse anchor: *anchor
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(
      Map([
        (String("First occurrence"), String("Foo")),
        (String("Second occurrence"), String("Foo")),
        (String("Override anchor"), String("Bar")),
        (String("Reuse anchor"), String("Bar")),
      ]),
    ),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "3HFZ" {
  let in_yaml =
    #|---
    #|key: value
    #|... invalid
    #|
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "3MYT" {
  let in_yaml =
    #|---
    #|k:#foo
    #| &a !t s
    #|
  let expected : Array[@yaml.Yaml] = [String("k:#foo &a !t s")]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "3R3P" {
  let in_yaml =
    #|&sequence
    #|- a
    #|
  let expected : Array[@yaml.Yaml] = [Sequence([String("a")])]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "3UYS" {
  let in_yaml =
    #|escaped slash: "a\/b"
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(Map([(String("escaped slash"), String("a/b"))])),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "4CQQ" {
  let in_yaml =
    #|plain:
    #|  This unquoted scalar
    #|  spans many lines.
    #|
    #|quoted: "So does this
    #|  quoted scalar.\n"
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(
      Map([
        (String("plain"), String("This unquoted scalar spans many lines.")),
        (String("quoted"), String("So does this quoted scalar.\n")),
      ]),
    ),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "4EJS" {
  let in_yaml =
    #|---
    #|a:
    #|	b:
    #|		c: value
    #|
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "4GC6" {
  let in_yaml =
    #|'here''s to "quotes"'
    #|
  let expected : Array[@yaml.Yaml] = [String("here's to \"quotes\"")]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "4H7K" {
  let in_yaml =
    #|---
    #|[ a, b, c ] ]
    #|
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "4HVU" {
  let in_yaml =
    #|key:
    #|   - ok
    #|   - also ok
    #|  - wrong
    #|
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "4JVG" {
  let in_yaml =
    #|top1: &node1
    #|  &k1 key1: val1
    #|top2: &node2
    #|  &v2 val2
    #|
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "4Q9F" {
  let in_yaml =
    #|--- >
    #| ab
    #| cd
    #| 
    #| ef
    #|
    #|
    #| gh
    #|
  let expected : Array[@yaml.Yaml] = [String("ab cd\nef\n\ngh\n")]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "4QFQ" {
  let in_yaml =
    #|- |
    #| detected
    #|- >
    #| 
    #|  
    #|  # detected
    #|- |1
    #|  explicit
    #|- >
    #| detected
    #|
  let expected : Array[@yaml.Yaml] = [
    Sequence([
      String("detected\n"),
      String("\n\n# detected\n"),
      String(" explicit\n"),
      String("detected\n"),
    ]),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "4RWC" {
  let in_yaml =
    #|  [1, 2, 3]  
    #|  
    #|
  let expected : Array[@yaml.Yaml] = [
    Sequence([Integer(1), Integer(2), Integer(3)]),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "4UYU" {
  let in_yaml =
    #|"foo: bar\": baz"
    #|
  let expected : Array[@yaml.Yaml] = [String("foo: bar\": baz")]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "4V8U" {
  let in_yaml =
    #|---
    #|plain\value\with\backslashes
    #|
  let expected : Array[@yaml.Yaml] = [String("plain\\value\\with\\backslashes")]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "invalid yaml returns error" {
  let in_yaml =
    #|a: [1, 2
    #|
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "invalid flow map trailing tokens" {
  let in_yaml =
    #|---
    #|x: { y: z }in: valid
    #|
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "impl01 mapping duplicates should error" {
  let in_yaml =
    #|a: foo
    #|a: bar
    #|
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "impl01 invalid trailing content after double quoted string" {
  let in_yaml =
    #|"foo" l"
    #|
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "detect invalid indentation" {
  let in_yaml =
    #|a:
    #|  b: 1
    #| c: 2
    #|
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "parse scalar" {
  let in_yaml =
    #|hello
    #|
  let expected : Array[@yaml.Yaml] = [String("hello")]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "parse mapping" {
  let in_yaml =
    #|a: 1
    #|b: two
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(Map([(String("a"), Integer(1)), (String("b"), String("two"))])),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "parse ignores comments" {
  let in_yaml =
    #|a: 1 # comment
    #|b: two
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(Map([(String("a"), Integer(1)), (String("b"), String("two"))])),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "parse null scalar" {
  let in_yaml =
    #|~
    #|
  let expected : Array[@yaml.Yaml] = [Null]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "spec/stream/empty" {
  let in_yaml = ""
  let expected : Array[@yaml.Yaml] = []
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "spec/schema/integer-beyond-64-bits" {
  let in_yaml =
    #|- 18446744073709551616
    #|- -170141183460469231731687303715884105728
    #|- 0x10000000000000000
    #|- 0o2000000000000000000000
  let expected : Array[@yaml.Yaml] = [
    Sequence([
      Integer(18446744073709551616N),
      Integer(-170141183460469231731687303715884105728N),
      Integer(18446744073709551616N),
      Integer(18446744073709551616N),
    ]),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "spec/keys/typed-scalar-keys-are-distinct" {
  let in_yaml =
    #|1: int
    #|"1": string
    #|1.0: float
    #|true: bool
    #|~: "null"
  let expected : Array[@yaml.Yaml] = [
    Mapping(
      Map([
        (Integer(1), String("int")),
        (String("1"), String("string")),
        (Float(1.0), String("float")),
        (Bool(true), String("bool")),
        (Null, String("null")),
      ]),
    ),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "spec/tags/bool-invalid-content" {
  let in_yaml =
    #|!!bool yes
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "spec/tags/unknown-tags-load-by-kind" {
  let in_yaml =
    #|- !foo 12
    #|- !foo [1]
    #|- !foo {a: 1}
    #|- !<tag:example.com,2000:x> true
    #|- !!timestamp 2001-12-14
    #|- !!binary aGk=
    #|- !!omap [a: 1]
    #|- !!set {b}
    #|- !!merge x
    #|- !!value y
  let expected : Array[@yaml.Yaml] = [
    Sequence([
      String("12"),
      Sequence([Integer(1)]),
      Mapping(Map([(String("a"), Integer(1))])),
      String("true"),
      String("2001-12-14"),
      String("aGk="),
      Sequence([Mapping(Map([(String("a"), Integer(1))]))]),
      Mapping(Map([(String("b"), Null)])),
      String("x"),
      String("y"),
    ]),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "spec/aliases/cycle-in-mapping" {
  let in_yaml =
    #|a: &m
    #|  b: *m
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "spec/encoding/control-character-rejected" {
  let in_yaml = "\"a\u{1}b\"\n"
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "print/roundtrip-escapes" {
  let docs : Array[@yaml.Yaml] = [
    Mapping(
      Map([
        (String(""), String("empty key")),
        (String("a\"b\\c"), String("quote\"back\\slash")),
        (
          String("nl\nt\tcr\rnul\u{0}del\u{7F}c1\u{85}bom\u{FEFF}ls\u{2028}"),
          String("\u{1}\u{1F}\u{9F}\u{2029}"),
        ),
        (String("null"), String("~")),
        (String("12"), String("0x1F")),
        (String(".inf"), String("- item")),
        (String("--- doc"), String("a: b")),
        (String("# comment"), String("? x")),
        (String("*alias"), String("&anchor")),
        (String("!tag"), String("%YAML")),
        (String(" lead"), String("trail ")),
        (String("|"), String(">")),
        (String("你好😀"), String("é")),
      ]),
    ),
  ]
  assert_eq(@yaml.parse(@yaml.print(docs)), docs)
}

///|
test "quickcheck: roundtrips" {
  @quickcheck.check(
    (docs : Array[@yaml.Yaml]) => @yaml.parse(@yaml.print(docs)) == docs,
    count=300,
  )
}

///|
test "quickcheck: parse should never panic" {
  @quickcheck.check((s : String) => {
    try @yaml.parse(s) catch {
      _ => true
    } noraise {
      _ => true
    }
  })
}
