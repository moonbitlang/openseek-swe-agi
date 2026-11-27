///|
test "4WA9" {
  let in_yaml =
    #|- aaa: |2
    #|    xxx
    #|  bbb: |
    #|    xxx
    #|
  let expected : Array[@yaml.Yaml] = [
    Sequence([
      Mapping(
        Map([(String("aaa"), String("xxx\n")), (String("bbb"), String("xxx\n"))]),
      ),
    ]),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "4ZYM" {
  let in_yaml =
    #|plain: text
    #|  lines
    #|quoted: "text
    #|  	lines"
    #|block: |
    #|  text
    #|   	lines
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(
      Map([
        (String("plain"), String("text lines")),
        (String("quoted"), String("text lines")),
        (String("block"), String("text\n \tlines\n")),
      ]),
    ),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "52DL" {
  let in_yaml =
    #|---
    #|! a
    #|
  let expected : Array[@yaml.Yaml] = [String("a")]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "54T7" {
  let in_yaml =
    #|{foo: you, bar: far}
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(
      Map([(String("foo"), String("you")), (String("bar"), String("far"))]),
    ),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "55WF" {
  let in_yaml =
    #|---
    #|"\."
    #|
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "565N" {
  let in_yaml =
    #|canonical: !!binary "\
    #| R0lGODlhDAAMAIQAAP//9/X17unp5WZmZgAAAOfn515eXvPz7Y6OjuDg4J+fn5\
    #| OTk6enp56enmlpaWNjY6Ojo4SEhP/++f/++f/++f/++f/++f/++f/++f/++f/+\
    #| +f/++f/++f/++f/++f/++SH+Dk1hZGUgd2l0aCBHSU1QACwAAAAADAAMAAAFLC\
    #| AgjoEwnuNAFOhpEMTRiggcz4BNJHrv/zCFcLiwMWYNG84BwwEeECcgggoBADs="
    #|generic: !!binary |
    #| R0lGODlhDAAMAIQAAP//9/X17unp5WZmZgAAAOfn515eXvPz7Y6OjuDg4J+fn5
    #| OTk6enp56enmlpaWNjY6Ojo4SEhP/++f/++f/++f/++f/++f/++f/++f/++f/+
    #| +f/++f/++f/++f/++f/++SH+Dk1hZGUgd2l0aCBHSU1QACwAAAAADAAMAAAFLC
    #| AgjoEwnuNAFOhpEMTRiggcz4BNJHrv/zCFcLiwMWYNG84BwwEeECcgggoBADs=
    #|description:
    #| The binary value above is a tiny arrow encoded as a gif image.
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(
      Map([
        (
          String("canonical"),
          String(
            "R0lGODlhDAAMAIQAAP//9/X17unp5WZmZgAAAOfn515eXvPz7Y6OjuDg4J+fn5OTk6enp56enmlpaWNjY6Ojo4SEhP/++f/++f/++f/++f/++f/++f/++f/++f/++f/++f/++f/++f/++f/++SH+Dk1hZGUgd2l0aCBHSU1QACwAAAAADAAMAAAFLCAgjoEwnuNAFOhpEMTRiggcz4BNJHrv/zCFcLiwMWYNG84BwwEeECcgggoBADs=",
          ),
        ),
        (
          String("generic"),
          String(
            "R0lGODlhDAAMAIQAAP//9/X17unp5WZmZgAAAOfn515eXvPz7Y6OjuDg4J+fn5\nOTk6enp56enmlpaWNjY6Ojo4SEhP/++f/++f/++f/++f/++f/++f/++f/++f/+\n+f/++f/++f/++f/++f/++SH+Dk1hZGUgd2l0aCBHSU1QACwAAAAADAAMAAAFLC\nAgjoEwnuNAFOhpEMTRiggcz4BNJHrv/zCFcLiwMWYNG84BwwEeECcgggoBADs=\n",
          ),
        ),
        (
          String("description"),
          String(
            "The binary value above is a tiny arrow encoded as a gif image.",
          ),
        ),
      ]),
    ),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "57H4" {
  let in_yaml =
    #|sequence: !!seq
    #|- entry
    #|- !!seq
    #| - nested
    #|mapping: !!map
    #| foo: bar
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(
      Map([
        (
          String("sequence"),
          Sequence([String("entry"), Sequence([String("nested")])]),
        ),
        (String("mapping"), Mapping(Map([(String("foo"), String("bar"))]))),
      ]),
    ),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "58MP" {
  let in_yaml =
    #|{x: :x}
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(Map([(String("x"), String(":x"))])),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "5BVJ" {
  let in_yaml =
    #|literal: |
    #|  some
    #|  text
    #|folded: >
    #|  some
    #|  text
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(
      Map([
        (String("literal"), String("some\ntext\n")),
        (String("folded"), String("some text\n")),
      ]),
    ),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "5C5M" {
  let in_yaml =
    #|- { one : two , three: four , }
    #|- {five: six,seven : eight}
    #|
  let expected : Array[@yaml.Yaml] = [
    Sequence([
      Mapping(
        Map([(String("one"), String("two")), (String("three"), String("four"))]),
      ),
      Mapping(
        Map([
          (String("five"), String("six")),
          (String("seven"), String("eight")),
        ]),
      ),
    ]),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "5GBF" {
  let in_yaml =
    #|Folding:
    #|  "Empty line
    #|   	
    #|  as a line feed"
    #|Chomping: |
    #|  Clipped empty lines
    #| 
    #|
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(
      Map([
        (String("Folding"), String("Empty line\nas a line feed")),
        (String("Chomping"), String("Clipped empty lines\n")),
      ]),
    ),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "5KJE" {
  let in_yaml =
    #|- [ one, two, ]
    #|- [three ,four]
    #|
  let expected : Array[@yaml.Yaml] = [
    Sequence([
      Sequence([String("one"), String("two")]),
      Sequence([String("three"), String("four")]),
    ]),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "5LLU" {
  let in_yaml =
    #|block scalar: >
    #| 
    #|  
    #|   
    #| invalid
    #|
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "5MUD" {
  let in_yaml =
    #|---
    #|{ "foo"
    #|  :bar }
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(Map([(String("foo"), String("bar"))])),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "5NYZ" {
  let in_yaml =
    #|key:    # Comment
    #|  value
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(Map([(String("key"), String("value"))])),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "5T43" {
  let in_yaml =
    #|- { "key":value }
    #|- { "key"::value }
    #|
  let expected : Array[@yaml.Yaml] = [
    Sequence([
      Mapping(Map([(String("key"), String("value"))])),
      Mapping(Map([(String("key"), String(":value"))])),
    ]),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "5TRB" {
  let in_yaml =
    #|---
    #|"
    #|---
    #|"
    #|
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "5TYM" {
  let in_yaml =
    #|%TAG !m! !my-
    #|--- # Bulb here
    #|!m!light fluorescent
    #|...
    #|%TAG !m! !my-
    #|--- # Color here
    #|!m!light green
    #|
  let expected : Array[@yaml.Yaml] = [String("fluorescent"), String("green")]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "5U3A" {
  let in_yaml =
    #|key: - a
    #|     - b
    #|
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "5WE3" {
  let in_yaml =
    #|? explicit key # Empty value
    #|? |
    #|  block key
    #|: - one # Explicit compact
    #|  - two # block value
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(
      Map([
        (String("explicit key"), Null),
        (String("block key\n"), Sequence([String("one"), String("two")])),
      ]),
    ),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "62EZ" {
  let in_yaml =
    #|---
    #|x: { y: z }in: valid
    #|
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "652Z" {
  let in_yaml =
    #|{ ?foo: bar,
    #|bar: 42
    #|}
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(
      Map([(String("?foo"), String("bar")), (String("bar"), Integer(42))]),
    ),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "65WH" {
  let in_yaml =
    #|- foo
    #|
  let expected : Array[@yaml.Yaml] = [Sequence([String("foo")])]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "6BCT" {
  let in_yaml =
    #|- foo:	 bar
    #|- - baz
    #|  -	baz
    #|
  let expected : Array[@yaml.Yaml] = [
    Sequence([
      Mapping(Map([(String("foo"), String("bar"))])),
      Sequence([String("baz"), String("baz")]),
    ]),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "6CA3" {
  let in_yaml =
    #|	[
    #|	]
    #|
  let expected : Array[@yaml.Yaml] = [Sequence([])]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "6CK3" {
  let in_yaml =
    #|%TAG !e! tag:example.com,2000:app/
    #|---
    #|- !local foo
    #|- !!str bar
    #|- !e!tag%21 baz
    #|
  let expected : Array[@yaml.Yaml] = [
    Sequence([String("foo"), String("bar"), String("baz")]),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "6FWR" {
  let in_yaml =
    #|--- |+
    #| ab
    #| 
    #|  
    #|...
    #|
  let expected : Array[@yaml.Yaml] = [String("ab\n\n \n")]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "6H3V" {
  let in_yaml =
    #|'foo: bar\': baz'
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(Map([(String("foo: bar\\"), String("baz'"))])),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "6HB6" {
  let in_yaml =
    #|  # Leading comment line spaces are
    #|   # neither content nor indentation.
    #|    
    #|Not indented:
    #| By one space: |
    #|    By four
    #|      spaces
    #| Flow style: [    # Leading spaces
    #|   By two,        # in flow style
    #|  Also by two,    # are neither
    #|  	Still by two   # content nor
    #|    ]             # indentation.
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(
      Map([
        (
          String("Not indented"),
          Mapping(
            Map([
              (String("By one space"), String("By four\n  spaces\n")),
              (
                String("Flow style"),
                Sequence([
                  String("By two"),
                  String("Also by two"),
                  String("Still by two"),
                ]),
              ),
            ]),
          ),
        ),
      ]),
    ),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "6JQW" {
  let in_yaml =
    #|# ASCII Art
    #|--- |
    #|  \//||\/||
    #|  // ||  ||__
    #|
  let expected : Array[@yaml.Yaml] = [String("\\//||\\/||\n// ||  ||__\n")]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "6JTT" {
  let in_yaml =
    #|---
    #|[ [ a, b, c ]
    #|
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "6JWB" {
  let in_yaml =
    #|foo: !!seq
    #|  - !!str a
    #|  - !!map
    #|    key: !!str value
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(
      Map([
        (
          String("foo"),
          Sequence([
            String("a"),
            Mapping(Map([(String("key"), String("value"))])),
          ]),
        ),
      ]),
    ),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "6KGN" {
  let in_yaml =
    #|---
    #|a: &anchor
    #|b: *anchor
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(Map([(String("a"), Null), (String("b"), Null)])),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "6LVF" {
  let in_yaml =
    #|%FOO  bar baz # Should be ignored
    #|              # with a warning.
    #|--- "foo"
    #|
  let expected : Array[@yaml.Yaml] = [String("foo")]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "6S55" {
  let in_yaml =
    #|key:
    #| - bar
    #| - baz
    #| invalid
    #|
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "6SLA" {
  let in_yaml =
    #|"foo\nbar:baz\tx \\$%^&*()x": 23
    #|'x\ny:z\tx $%^&*()x': 24
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(
      Map([
        (String("foo\nbar:baz\tx \\$%^&*()x"), Integer(23)),
        (String("x\\ny:z\\tx $%^&*()x"), Integer(24)),
      ]),
    ),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "6VJK" {
  let in_yaml =
    #|>
    #| Sammy Sosa completed another
    #| fine season with great stats.
    #|
    #|   63 Home Runs
    #|   0.288 Batting Average
    #|
    #| What a year!
    #|
  let expected : Array[@yaml.Yaml] = [
    String(
      "Sammy Sosa completed another fine season with great stats.\n\n  63 Home Runs\n  0.288 Batting Average\n\nWhat a year!\n",
    ),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "6WLZ" {
  let in_yaml =
    #|# Private
    #|---
    #|!foo "bar"
    #|...
    #|# Global
    #|%TAG ! tag:example.com,2000:app/
    #|---
    #|!foo "bar"
    #|
  let expected : Array[@yaml.Yaml] = [String("bar"), String("bar")]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "6WPF" {
  let in_yaml =
    #|---
    #|"
    #|  foo 
    #| 
    #|    bar
    #|
    #|  baz
    #|"
    #|
  let expected : Array[@yaml.Yaml] = [String(" foo\nbar\nbaz ")]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "6XDY" {
  let in_yaml =
    #|---
    #|---
    #|
  let expected : Array[@yaml.Yaml] = [Null, Null]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "6ZKB" {
  let in_yaml =
    #|Document
    #|---
    #|# Empty
    #|...
    #|%YAML 1.2
    #|---
    #|matches %: 20
    #|
  let expected : Array[@yaml.Yaml] = [
    String("Document"),
    Null,
    Mapping(Map([(String("matches %"), Integer(20))])),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "735Y" {
  let in_yaml =
    #|-
    #|  "flow in block"
    #|- >
    #| Block scalar
    #|- !!map # Block collection
    #|  foo : bar
    #|
  let expected : Array[@yaml.Yaml] = [
    Sequence([
      String("flow in block"),
      String("Block scalar\n"),
      Mapping(Map([(String("foo"), String("bar"))])),
    ]),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "74H7" {
  let in_yaml =
    #|!!str a: b
    #|c: !!int 42
    #|e: !!str f
    #|g: h
    #|!!str 23: !!bool false
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(
      Map([
        (String("a"), String("b")),
        (String("c"), Integer(42)),
        (String("e"), String("f")),
        (String("g"), String("h")),
        (String("23"), Bool(false)),
      ]),
    ),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "753E" {
  let in_yaml =
    #|--- |-
    #| ab
    #| 
    #| 
    #|...
    #|
  let expected : Array[@yaml.Yaml] = [String("ab")]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "7A4E" {
  let in_yaml =
    #|" 1st non-empty
    #|
    #| 2nd non-empty 
    #|	3rd non-empty "
    #|
  let expected : Array[@yaml.Yaml] = [
    String(" 1st non-empty\n2nd non-empty 3rd non-empty "),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "7BMT" {
  let in_yaml =
    #|---
    #|top1: &node1
    #|  &k1 key1: one
    #|top2: &node2 # comment
    #|  key2: two
    #|top3:
    #|  &k3 key3: three
    #|top4: &node4
    #|  &k4 key4: four
    #|top5: &node5
    #|  key5: five
    #|top6: &val6
    #|  six
    #|top7:
    #|  &val7 seven
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(
      Map([
        (String("top1"), Mapping(Map([(String("key1"), String("one"))]))),
        (String("top2"), Mapping(Map([(String("key2"), String("two"))]))),
        (String("top3"), Mapping(Map([(String("key3"), String("three"))]))),
        (String("top4"), Mapping(Map([(String("key4"), String("four"))]))),
        (String("top5"), Mapping(Map([(String("key5"), String("five"))]))),
        (String("top6"), String("six")),
        (String("top7"), String("seven")),
      ]),
    ),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "7BUB" {
  let in_yaml =
    #|---
    #|hr:
    #|  - Mark McGwire
    #|  # Following node labeled SS
    #|  - &SS Sammy Sosa
    #|rbi:
    #|  - *SS # Subsequent occurrence
    #|  - Ken Griffey
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(
      Map([
        (String("hr"), Sequence([String("Mark McGwire"), String("Sammy Sosa")])),
        (String("rbi"), Sequence([String("Sammy Sosa"), String("Ken Griffey")])),
      ]),
    ),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "7FWL" {
  let in_yaml =
    #|!<tag:yaml.org,2002:str> foo :
    #|  !<!bar> baz
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(Map([(String("foo"), String("baz"))])),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "7LBH" {
  let in_yaml =
    #|"a\nb": 1
    #|"c
    #| d": 1
    #|
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "7MNF" {
  let in_yaml =
    #|top1:
    #|  key1: val1
    #|top2
    #|
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "7T8X" {
  let in_yaml =
    #|>
    #|
    #| folded
    #| line
    #|
    #| next
    #| line
    #|   * bullet
    #|
    #|   * list
    #|   * lines
    #|
    #| last
    #| line
    #|
    #|# Comment
    #|
  let expected : Array[@yaml.Yaml] = [
    String(
      "\nfolded line\nnext line\n  * bullet\n\n  * list\n  * lines\n\nlast line\n",
    ),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "7TMG" {
  let in_yaml =
    #|---
    #|[ word1
    #|# comment
    #|, word2]
    #|
  let expected : Array[@yaml.Yaml] = [
    Sequence([String("word1"), String("word2")]),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "7W2P" {
  let in_yaml =
    #|? a
    #|? b
    #|c:
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(
      Map([(String("a"), Null), (String("b"), Null), (String("c"), Null)]),
    ),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "7Z25" {
  let in_yaml =
    #|---
    #|scalar1
    #|...
    #|key: value
    #|
  let expected : Array[@yaml.Yaml] = [
    String("scalar1"),
    Mapping(Map([(String("key"), String("value"))])),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "7ZZ5" {
  let in_yaml =
    #|---
    #|nested sequences:
    #|- - - []
    #|- - - {}
    #|key1: []
    #|key2: {}
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(
      Map([
        (
          String("nested sequences"),
          Sequence([
            Sequence([Sequence([Sequence([])])]),
            Sequence([Sequence([Mapping(Map([]))])]),
          ]),
        ),
        (String("key1"), Sequence([])),
        (String("key2"), Mapping(Map([]))),
      ]),
    ),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "82AN" {
  let in_yaml =
    #|---word1
    #|word2
    #|
  let expected : Array[@yaml.Yaml] = [String("---word1 word2")]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "87E4" {
  let in_yaml =
    #|'implicit block key' : [
    #|  'implicit flow key' : value,
    #| ]
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(
      Map([
        (
          String("implicit block key"),
          Sequence([
            Mapping(Map([(String("implicit flow key"), String("value"))])),
          ]),
        ),
      ]),
    ),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "8CWC" {
  let in_yaml =
    #|---
    #|key ends with two colons::: value
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(Map([(String("key ends with two colons::"), String("value"))])),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "8KB6" {
  let in_yaml =
    #|---
    #|- { single line, a: b}
    #|- { multi
    #|  line, a: b}
    #|
  let expected : Array[@yaml.Yaml] = [
    Sequence([
      Mapping(Map([(String("single line"), Null), (String("a"), String("b"))])),
      Mapping(Map([(String("multi line"), Null), (String("a"), String("b"))])),
    ]),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "8MK2" {
  let in_yaml =
    #|! a
    #|
  let expected : Array[@yaml.Yaml] = [String("a")]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "8QBE" {
  let in_yaml =
    #|key:
    #| - item1
    #| - item2
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(
      Map([(String("key"), Sequence([String("item1"), String("item2")]))]),
    ),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "8UDB" {
  let in_yaml =
    #|[
    #|"double
    #| quoted", 'single
    #|           quoted',
    #|plain
    #| text, [ nested ],
    #|single: pair,
    #|]
    #|
  let expected : Array[@yaml.Yaml] = [
    Sequence([
      String("double quoted"),
      String("single quoted"),
      String("plain text"),
      Sequence([String("nested")]),
      Mapping(Map([(String("single"), String("pair"))])),
    ]),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "8XDJ" {
  let in_yaml =
    #|key: word1
    #|#  xxx
    #|  word2
    #|
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "8XYN" {
  let in_yaml =
    #|---
    #|- &😁 unicode anchor
    #|
  let expected : Array[@yaml.Yaml] = [Sequence([String("unicode anchor")])]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "93JH" {
  let in_yaml =
    #| - key: value
    #|   key2: value2
    #| -
    #|   key3: value3
    #|
  let expected : Array[@yaml.Yaml] = [
    Sequence([
      Mapping(
        Map([
          (String("key"), String("value")),
          (String("key2"), String("value2")),
        ]),
      ),
      Mapping(Map([(String("key3"), String("value3"))])),
    ]),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "93WF" {
  let in_yaml =
    #|--- >-
    #|  trimmed
    #|  
    #| 
    #|
    #|  as
    #|  space
    #|
  let expected : Array[@yaml.Yaml] = [String("trimmed\n\n\nas space")]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "96L6" {
  let in_yaml =
    #|--- >
    #|  Mark McGwire's
    #|  year was crippled
    #|  by a knee injury.
    #|
  let expected : Array[@yaml.Yaml] = [
    String("Mark McGwire's year was crippled by a knee injury.\n"),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "9BXH" {
  let in_yaml =
    #|---
    #|- { "single line", a: b}
    #|- { "multi
    #|  line", a: b}
    #|
  let expected : Array[@yaml.Yaml] = [
    Sequence([
      Mapping(Map([(String("single line"), Null), (String("a"), String("b"))])),
      Mapping(Map([(String("multi line"), Null), (String("a"), String("b"))])),
    ]),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "9C9N" {
  let in_yaml =
    #|---
    #|flow: [a,
    #|b,
    #|c]
    #|
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "9CWY" {
  let in_yaml =
    #|key:
    #| - item1
    #| - item2
    #|invalid
    #|
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "9DXL" {
  let in_yaml =
    #|Mapping: Document
    #|---
    #|# Empty
    #|...
    #|%YAML 1.2
    #|---
    #|matches %: 20
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(Map([(String("Mapping"), String("Document"))])),
    Null,
    Mapping(Map([(String("matches %"), Integer(20))])),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "9FMG" {
  let in_yaml =
    #|a:
    #|  b:
    #|    c: d
    #|  e:
    #|    f: g
    #|h: i
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(
      Map([
        (
          String("a"),
          Mapping(
            Map([
              (String("b"), Mapping(Map([(String("c"), String("d"))]))),
              (String("e"), Mapping(Map([(String("f"), String("g"))]))),
            ]),
          ),
        ),
        (String("h"), String("i")),
      ]),
    ),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "9HCY" {
  let in_yaml =
    #|!foo "bar"
    #|%TAG ! tag:example.com,2000:app/
    #|---
    #|!foo "bar"
    #|
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "9J7A" {
  let in_yaml =
    #|foo:
    #|  bar: baz
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(
      Map([(String("foo"), Mapping(Map([(String("bar"), String("baz"))])))]),
    ),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "9JBA" {
  let in_yaml =
    #|---
    #|[ a, b, c, ]#invalid
    #|
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "9KAX" {
  let in_yaml =
    #|---
    #|&a1
    #|!!str
    #|scalar1
    #|---
    #|!!str
    #|&a2
    #|scalar2
    #|---
    #|&a3
    #|!!str scalar3
    #|---
    #|&a4 !!map
    #|&a5 !!str key5: value4
    #|---
    #|a6: 1
    #|&anchor6 b6: 2
    #|---
    #|!!map
    #|&a8 !!str key8: value7
    #|---
    #|!!map
    #|!!str &a10 key10: value9
    #|---
    #|!!str &a11
    #|value11
    #|
  let expected : Array[@yaml.Yaml] = [
    String("scalar1"),
    String("scalar2"),
    String("scalar3"),
    Mapping(Map([(String("key5"), String("value4"))])),
    Mapping(Map([(String("a6"), Integer(1)), (String("b6"), Integer(2))])),
    Mapping(Map([(String("key8"), String("value7"))])),
    Mapping(Map([(String("key10"), String("value9"))])),
    String("value11"),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "9KBC" {
  let in_yaml =
    #|--- key1: value1
    #|    key2: value2
    #|
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "9MAG" {
  let in_yaml =
    #|---
    #|[ , a, b, c ]
    #|
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "9MMA" {
  let in_yaml =
    #|%YAML 1.2
    #|
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "9SA2" {
  let in_yaml =
    #|---
    #|- { "single line": value}
    #|- { "multi
    #|  line": value}
    #|
  let expected : Array[@yaml.Yaml] = [
    Sequence([
      Mapping(Map([(String("single line"), String("value"))])),
      Mapping(Map([(String("multi line"), String("value"))])),
    ]),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "9SHH" {
  let in_yaml =
    #|single: 'text'
    #|double: "text"
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(
      Map([
        (String("single"), String("text")),
        (String("double"), String("text")),
      ]),
    ),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "9TFX" {
  let in_yaml =
    #|---
    #|" 1st non-empty
    #|
    #| 2nd non-empty 
    #| 3rd non-empty "
    #|
  let expected : Array[@yaml.Yaml] = [
    String(" 1st non-empty\n2nd non-empty 3rd non-empty "),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "9U5K" {
  let in_yaml =
    #|---
    #|# Products purchased
    #|- item    : Super Hoop
    #|  quantity: 1
    #|- item    : Basketball
    #|  quantity: 4
    #|- item    : Big Shoes
    #|  quantity: 1
    #|
  let expected : Array[@yaml.Yaml] = [
    Sequence([
      Mapping(
        Map([
          (String("item"), String("Super Hoop")),
          (String("quantity"), Integer(1)),
        ]),
      ),
      Mapping(
        Map([
          (String("item"), String("Basketball")),
          (String("quantity"), Integer(4)),
        ]),
      ),
      Mapping(
        Map([
          (String("item"), String("Big Shoes")),
          (String("quantity"), Integer(1)),
        ]),
      ),
    ]),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "9WXW" {
  let in_yaml =
    #|# Private
    #|!foo "bar"
    #|...
    #|# Global
    #|%TAG ! tag:example.com,2000:app/
    #|---
    #|!foo "bar"
    #|
  let expected : Array[@yaml.Yaml] = [String("bar"), String("bar")]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "9YRD" {
  let in_yaml =
    #|a
    #|b  
    #|  c
    #|d
    #|
    #|e
    #|
  let expected : Array[@yaml.Yaml] = [String("a b c d\ne")]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "A2M4" {
  let in_yaml =
    #|? a
    #|: -	b
    #|  -  -	c
    #|     - d
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(
      Map([
        (
          String("a"),
          Sequence([String("b"), Sequence([String("c"), String("d")])]),
        ),
      ]),
    ),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "A6F9" {
  let in_yaml =
    #|strip: |-
    #|  text
    #|clip: |
    #|  text
    #|keep: |+
    #|  text
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(
      Map([
        (String("strip"), String("text")),
        (String("clip"), String("text\n")),
        (String("keep"), String("text\n")),
      ]),
    ),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "A984" {
  let in_yaml =
    #|a: b
    #| c
    #|d:
    #| e
    #|  f
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(Map([(String("a"), String("b c")), (String("d"), String("e f"))])),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "AB8U" {
  let in_yaml =
    #|- single multiline
    #| - sequence entry
    #|
  let expected : Array[@yaml.Yaml] = [
    Sequence([String("single multiline - sequence entry")]),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "AZ63" {
  let in_yaml =
    #|one:
    #|- 2
    #|- 3
    #|four: 5
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(
      Map([
        (String("one"), Sequence([Integer(2), Integer(3)])),
        (String("four"), Integer(5)),
      ]),
    ),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "AZW3" {
  let in_yaml =
    #|- bla"keks: foo
    #|- bla]keks: foo
    #|
  let expected : Array[@yaml.Yaml] = [
    Sequence([
      Mapping(Map([(String("bla\"keks"), String("foo"))])),
      Mapping(Map([(String("bla]keks"), String("foo"))])),
    ]),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "B3HG" {
  let in_yaml =
    #|--- >
    #| folded
    #| text
    #|
    #|
    #|
  let expected : Array[@yaml.Yaml] = [String("folded text\n")]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "B63P" {
  let in_yaml =
    #|%YAML 1.2
    #|...
    #|
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "BD7L" {
  let in_yaml =
    #|- item1
    #|- item2
    #|invalid: x
    #|
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "BEC7" {
  let in_yaml =
    #|%YAML 1.3 # Attempt parsing
    #|          # with a warning
    #|---
    #|"foo"
    #|
  let expected : Array[@yaml.Yaml] = [String("foo")]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "BF9H" {
  let in_yaml =
    #|---
    #|plain: a
    #|       b # end of scalar
    #|       c
    #|
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "BS4K" {
  let in_yaml =
    #|word1  # comment
    #|word2
    #|
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "BU8L" {
  let in_yaml =
    #|key: &anchor
    #| !!map
    #|  a: b
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(Map([(String("key"), Mapping(Map([(String("a"), String("b"))])))])),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "C2DT" {
  let in_yaml =
    #|{
    #|"adjacent":value,
    #|"readable": value,
    #|"empty":
    #|}
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(
      Map([
        (String("adjacent"), String("value")),
        (String("readable"), String("value")),
        (String("empty"), Null),
      ]),
    ),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "C2SP" {
  let in_yaml =
    #|[23
    #|]: 42
    #|
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "C4HZ" {
  let in_yaml =
    #|%TAG ! tag:clarkevans.com,2002:
    #|--- !shape
    #|  # Use the ! handle for presenting
    #|  # tag:clarkevans.com,2002:circle
    #|- !circle
    #|  center: &ORIGIN {x: 73, y: 129}
    #|  radius: 7
    #|- !line
    #|  start: *ORIGIN
    #|  finish: { x: 89, y: 102 }
    #|- !label
    #|  start: *ORIGIN
    #|  color: 0xFFEEBB
    #|  text: Pretty vector drawing.
    #|
  let expected : Array[@yaml.Yaml] = [
    Sequence([
      Mapping(
        Map([
          (
            String("center"),
            Mapping(
              Map([(String("x"), Integer(73)), (String("y"), Integer(129))]),
            ),
          ),
          (String("radius"), Integer(7)),
        ]),
      ),
      Mapping(
        Map([
          (
            String("start"),
            Mapping(
              Map([(String("x"), Integer(73)), (String("y"), Integer(129))]),
            ),
          ),
          (
            String("finish"),
            Mapping(
              Map([(String("x"), Integer(89)), (String("y"), Integer(102))]),
            ),
          ),
        ]),
      ),
      Mapping(
        Map([
          (
            String("start"),
            Mapping(
              Map([(String("x"), Integer(73)), (String("y"), Integer(129))]),
            ),
          ),
          (String("color"), Integer(16772795)),
          (String("text"), String("Pretty vector drawing.")),
        ]),
      ),
    ]),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "CC74" {
  let in_yaml =
    #|%TAG !e! tag:example.com,2000:app/
    #|---
    #|!e!foo "bar"
    #|
  let expected : Array[@yaml.Yaml] = [String("bar")]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "CML9" {
  let in_yaml =
    #|key: [ word1
    #|#  xxx
    #|  word2 ]
    #|
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "CN3R" {
  let in_yaml =
    #|&flowseq [
    #| a: b,
    #| &c c: d,
    #| { &e e: f },
    #| &g { g: h }
    #|]
    #|
  let expected : Array[@yaml.Yaml] = [
    Sequence([
      Mapping(Map([(String("a"), String("b"))])),
      Mapping(Map([(String("c"), String("d"))])),
      Mapping(Map([(String("e"), String("f"))])),
      Mapping(Map([(String("g"), String("h"))])),
    ]),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "CPZ3" {
  let in_yaml =
    #|---
    #|tab: "\tstring"
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(Map([(String("tab"), String("\tstring"))])),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "CQ3W" {
  let in_yaml =
    #|---
    #|key: "missing closing quote
    #|
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "CT4Q" {
  let in_yaml =
    #|[
    #|? foo
    #| bar : baz
    #|]
    #|
  let expected : Array[@yaml.Yaml] = [
    Sequence([Mapping(Map([(String("foo bar"), String("baz"))]))]),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "CTN5" {
  let in_yaml =
    #|---
    #|[ a, b, c, , ]
    #|
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "CUP7" {
  let in_yaml =
    #|anchored: !local &anchor value
    #|alias: *anchor
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(
      Map([
        (String("anchored"), String("value")),
        (String("alias"), String("value")),
      ]),
    ),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "CVW2" {
  let in_yaml =
    #|---
    #|[ a, b, c,#invalid
    #|]
    #|
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "CXX2" {
  let in_yaml =
    #|--- &anchor a: b
    #|
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "D49Q" {
  let in_yaml =
    #|'a\nb': 1
    #|'c
    #| d': 1
    #|
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "D83L" {
  let in_yaml =
    #|- |2-
    #|  explicit indent and chomp
    #|- |-2
    #|  chomp and explicit indent
    #|
  let expected : Array[@yaml.Yaml] = [
    Sequence([
      String("explicit indent and chomp"),
      String("chomp and explicit indent"),
    ]),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "D88J" {
  let in_yaml =
    #|a: [b, c]
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(Map([(String("a"), Sequence([String("b"), String("c")]))])),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "D9TU" {
  let in_yaml =
    #|foo: bar
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(Map([(String("foo"), String("bar"))])),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "DBG4" {
  let in_yaml =
    #|# Outside flow collection:
    #|- ::vector
    #|- ": - ()"
    #|- Up, up, and away!
    #|- -123
    #|- http://example.com/foo#bar
    #|# Inside flow collection:
    #|- [ ::vector,
    #|  ": - ()",
    #|  "Up, up and away!",
    #|  -123,
    #|  http://example.com/foo#bar ]
    #|
  let expected : Array[@yaml.Yaml] = [
    Sequence([
      String("::vector"),
      String(": - ()"),
      String("Up, up, and away!"),
      Integer(-123),
      String("http://example.com/foo#bar"),
      Sequence([
        String("::vector"),
        String(": - ()"),
        String("Up, up and away!"),
        Integer(-123),
        String("http://example.com/foo#bar"),
      ]),
    ]),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "DC7X" {
  let in_yaml =
    #|a: b	
    #|seq:	
    #| - a	
    #|c: d	#X
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(
      Map([
        (String("a"), String("b")),
        (String("seq"), Sequence([String("a")])),
        (String("c"), String("d")),
      ]),
    ),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "DHP8" {
  let in_yaml =
    #|[foo, bar, 42]
    #|
  let expected : Array[@yaml.Yaml] = [
    Sequence([String("foo"), String("bar"), Integer(42)]),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "DK3J" {
  let in_yaml =
    #|--- >
    #|line1
    #|# no comment
    #|line3
    #|
  let expected : Array[@yaml.Yaml] = [String("line1 # no comment line3\n")]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "DK4H" {
  let in_yaml =
    #|---
    #|[ key
    #|  : value ]
    #|
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "DMG6" {
  let in_yaml =
    #|key:
    #|  ok: 1
    #| wrong: 2
    #|
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "DWX9" {
  let in_yaml =
    #||
    #| 
    #|  
    #|  literal
    #|   
    #|  
    #|  text
    #|
    #| # Comment
    #|
  let expected : Array[@yaml.Yaml] = [String("\n\nliteral\n \n\ntext\n")]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "E76Z" {
  let in_yaml =
    #|&a a: &b b
    #|*b : *a
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(Map([(String("a"), String("b")), (String("b"), String("a"))])),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "EB22" {
  let in_yaml =
    #|---
    #|scalar1 # comment
    #|%YAML 1.2
    #|---
    #|scalar2
    #|
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "EHF6" {
  let in_yaml =
    #|!!map {
    #|  k: !!seq
    #|  [ a, !!str b]
    #|}
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(Map([(String("k"), Sequence([String("a"), String("b")]))])),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "EW3V" {
  let in_yaml =
    #|k1: v1
    #| k2: v2
    #|
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "EX5H" {
  let in_yaml =
    #|---
    #|a
    #|b  
    #|  c
    #|d
    #|
    #|e
    #|
  let expected : Array[@yaml.Yaml] = [String("a b c d\ne")]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "EXG3" {
  let in_yaml =
    #|---
    #|---word1
    #|word2
    #|
  let expected : Array[@yaml.Yaml] = [String("---word1 word2")]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "F2C7" {
  let in_yaml =
    #| - &a !!str a
    #| - !!int 2
    #| - !!int &c 4
    #| - &d d
    #|
  let expected : Array[@yaml.Yaml] = [
    Sequence([String("a"), Integer(2), Integer(4), String("d")]),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "F3CP" {
  let in_yaml =
    #|---
    #|{ a: [b, c, { d: [e, f] } ] }
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(
      Map([
        (
          String("a"),
          Sequence([
            String("b"),
            String("c"),
            Mapping(Map([(String("d"), Sequence([String("e"), String("f")]))])),
          ]),
        ),
      ]),
    ),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "F6MC" {
  let in_yaml =
    #|---
    #|a: >2
    #|   more indented
    #|  regular
    #|b: >2
    #|
    #|
    #|   more indented
    #|  regular
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(
      Map([
        (String("a"), String(" more indented\nregular\n")),
        (String("b"), String("\n\n more indented\nregular\n")),
      ]),
    ),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "F8F9" {
  let in_yaml =
    #| # Strip
    #|  # Comments:
    #|strip: |-
    #|  # text
    #|  
    #| # Clip
    #|  # comments:
    #|
    #|clip: |
    #|  # text
    #| 
    #| # Keep
    #|  # comments:
    #|
    #|keep: |+
    #|  # text
    #|
    #| # Trail
    #|  # comments.
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(
      Map([
        (String("strip"), String("# text")),
        (String("clip"), String("# text\n")),
        (String("keep"), String("# text\n\n")),
      ]),
    ),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "FBC9" {
  let in_yaml =
    #|safe: a!"#$%&'()*+,-./09:;<=>?@AZ[\]^_`az{|}~
    #|     !"#$%&'()*+,-./09:;<=>?@AZ[\]^_`az{|}~
    #|safe question mark: ?foo
    #|safe colon: :foo
    #|safe dash: -foo
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(
      Map([
        (
          String("safe"),
          String(
            "a!\"#$%&'()*+,-./09:;<=>?@AZ[\\]^_`az{|}~ !\"#$%&'()*+,-./09:;<=>?@AZ[\\]^_`az{|}~",
          ),
        ),
        (String("safe question mark"), String("?foo")),
        (String("safe colon"), String(":foo")),
        (String("safe dash"), String("-foo")),
      ]),
    ),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "FP8R" {
  let in_yaml =
    #|--- >
    #|line1
    #|line2
    #|line3
    #|
  let expected : Array[@yaml.Yaml] = [String("line1 line2 line3\n")]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "FQ7F" {
  let in_yaml =
    #|- Mark McGwire
    #|- Sammy Sosa
    #|- Ken Griffey
    #|
  let expected : Array[@yaml.Yaml] = [
    Sequence([
      String("Mark McGwire"),
      String("Sammy Sosa"),
      String("Ken Griffey"),
    ]),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "FTA2" {
  let in_yaml =
    #|--- &sequence
    #|- a
    #|
  let expected : Array[@yaml.Yaml] = [Sequence([String("a")])]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "FUP4" {
  let in_yaml =
    #|[a, [b, c]]
    #|
  let expected : Array[@yaml.Yaml] = [
    Sequence([String("a"), Sequence([String("b"), String("c")])]),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "G4RS" {
  let in_yaml =
    #|unicode: "Sosa did fine.\u263A"
    #|control: "\b1998\t1999\t2000\n"
    #|hex esc: "\x0d\x0a is \r\n"
    #|
    #|single: '"Howdy!" he cried.'
    #|quoted: ' # Not a ''comment''.'
    #|tie-fighter: '|\-*-/|'
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(
      Map([
        (String("unicode"), String("Sosa did fine.☺")),
        (String("control"), String("\u{8}1998\t1999\t2000\n")),
        (String("hex esc"), String("\r\n is \r\n")),
        (String("single"), String("\"Howdy!\" he cried.")),
        (String("quoted"), String(" # Not a 'comment'.")),
        (String("tie-fighter"), String("|\\-*-/|")),
      ]),
    ),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "G5U8" {
  let in_yaml =
    #|---
    #|- [-, -]
    #|
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "G7JE" {
  let in_yaml =
    #|a\nb: 1
    #|c
    #| d: 1
    #|
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "G992" {
  let in_yaml =
    #|>
    #| folded
    #| text
    #|
    #|
    #|
  let expected : Array[@yaml.Yaml] = [String("folded text\n")]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "G9HC" {
  let in_yaml =
    #|---
    #|seq:
    #|&anchor
    #|- a
    #|- b
    #|
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "GDY7" {
  let in_yaml =
    #|key: value
    #|this is #not a: key
    #|
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "GH63" {
  let in_yaml =
    #|? a
    #|: 1.3
    #|fifteen: d
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(Map([(String("a"), Float(1.3)), (String("fifteen"), String("d"))])),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "GT5M" {
  let in_yaml =
    #|- item1
    #|&node
    #|- item2
    #|
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "H2RW" {
  let in_yaml =
    #|foo: 1
    #|
    #|bar: 2
    #|    
    #|text: |
    #|  a
    #|    
    #|  b
    #|
    #|  c
    #| 
    #|  d
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(
      Map([
        (String("foo"), Integer(1)),
        (String("bar"), Integer(2)),
        (String("text"), String("a\n  \nb\n\nc\n\nd\n")),
      ]),
    ),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "H3Z8" {
  let in_yaml =
    #|---
    #|wanted: love ♥ and peace ☮
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(Map([(String("wanted"), String("love ♥ and peace ☮"))])),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "H7J7" {
  let in_yaml =
    #|key: &x
    #|!!map
    #|  a: b
    #|
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "H7TQ" {
  let in_yaml =
    #|%YAML 1.2 foo
    #|---
    #|
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "HMK4" {
  let in_yaml =
    #|name: Mark McGwire
    #|accomplishment: >
    #|  Mark set a major league
    #|  home run record in 1998.
    #|stats: |
    #|  65 Home Runs
    #|  0.278 Batting Average
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(
      Map([
        (String("name"), String("Mark McGwire")),
        (
          String("accomplishment"),
          String("Mark set a major league home run record in 1998.\n"),
        ),
        (String("stats"), String("65 Home Runs\n0.278 Batting Average\n")),
      ]),
    ),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "HMQ5" {
  let in_yaml =
    #|!!str &a1 "foo":
    #|  !!str bar
    #|&a2 baz : *a1
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(
      Map([(String("foo"), String("bar")), (String("baz"), String("foo"))]),
    ),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "HRE5" {
  let in_yaml =
    #|---
    #|double: "quoted \' scalar"
    #|
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "HS5T" {
  let in_yaml =
    #|1st non-empty
    #|
    #| 2nd non-empty 
    #|	3rd non-empty
    #|
  let expected : Array[@yaml.Yaml] = [
    String("1st non-empty\n2nd non-empty 3rd non-empty"),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "HU3P" {
  let in_yaml =
    #|key:
    #|  word1 word2
    #|  no: key
    #|
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "J3BT" {
  let in_yaml =
    #|# Tabs and spaces
    #|quoted: "Quoted 	"
    #|block:	|
    #|  void main() {
    #|  	printf("Hello, world!\n");
    #|  }
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(
      Map([
        (String("quoted"), String("Quoted \t")),
        (
          String("block"),
          String("void main() {\n\tprintf(\"Hello, world!\\n\");\n}\n"),
        ),
      ]),
    ),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "J5UC" {
  let in_yaml =
    #|foo: blue
    #|bar: arrr
    #|baz: jazz
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(
      Map([
        (String("foo"), String("blue")),
        (String("bar"), String("arrr")),
        (String("baz"), String("jazz")),
      ]),
    ),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "J7PZ" {
  let in_yaml =
    #|# The !!omap tag is one of the optional types
    #|# introduced for YAML 1.1. In 1.2, it is not
    #|# part of the standard tags and should not be
    #|# enabled by default.
    #|# Ordered maps are represented as
    #|# A sequence of mappings, with
    #|# each mapping having one key
    #|--- !!omap
    #|- Mark McGwire: 65
    #|- Sammy Sosa: 63
    #|- Ken Griffy: 58
    #|
  let expected : Array[@yaml.Yaml] = [
    Sequence([
      Mapping(Map([(String("Mark McGwire"), Integer(65))])),
      Mapping(Map([(String("Sammy Sosa"), Integer(63))])),
      Mapping(Map([(String("Ken Griffy"), Integer(58))])),
    ]),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "J7VC" {
  let in_yaml =
    #|one: 2
    #|
    #|
    #|three: 4
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(Map([(String("one"), Integer(2)), (String("three"), Integer(4))])),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "J9HZ" {
  let in_yaml =
    #|---
    #|hr: # 1998 hr ranking
    #|  - Mark McGwire
    #|  - Sammy Sosa
    #|rbi:
    #|  # 1998 rbi ranking
    #|  - Sammy Sosa
    #|  - Ken Griffey
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(
      Map([
        (String("hr"), Sequence([String("Mark McGwire"), String("Sammy Sosa")])),
        (String("rbi"), Sequence([String("Sammy Sosa"), String("Ken Griffey")])),
      ]),
    ),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "JHB9" {
  let in_yaml =
    #|# Ranking of 1998 home runs
    #|---
    #|- Mark McGwire
    #|- Sammy Sosa
    #|- Ken Griffey
    #|
    #|# Team ranking
    #|---
    #|- Chicago Cubs
    #|- St Louis Cardinals
    #|
  let expected : Array[@yaml.Yaml] = [
    Sequence([
      String("Mark McGwire"),
      String("Sammy Sosa"),
      String("Ken Griffey"),
    ]),
    Sequence([String("Chicago Cubs"), String("St Louis Cardinals")]),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "JKF3" {
  let in_yaml =
    #|- - "bar
    #|bar": x
    #|
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "JQ4R" {
  let in_yaml =
    #|block sequence:
    #|  - one
    #|  - two : three
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(
      Map([
        (
          String("block sequence"),
          Sequence([
            String("one"),
            Mapping(Map([(String("two"), String("three"))])),
          ]),
        ),
      ]),
    ),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "JR7V" {
  let in_yaml =
    #|- a?string
    #|- another ? string
    #|- key: value?
    #|- [a?string]
    #|- [another ? string]
    #|- {key: value? }
    #|- {key: value?}
    #|- {key?: value }
    #|
  let expected : Array[@yaml.Yaml] = [
    Sequence([
      String("a?string"),
      String("another ? string"),
      Mapping(Map([(String("key"), String("value?"))])),
      Sequence([String("a?string")]),
      Sequence([String("another ? string")]),
      Mapping(Map([(String("key"), String("value?"))])),
      Mapping(Map([(String("key"), String("value?"))])),
      Mapping(Map([(String("key?"), String("value"))])),
    ]),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "JS2J" {
  let in_yaml =
    #|First occurrence: &anchor Value
    #|Second occurrence: *anchor
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(
      Map([
        (String("First occurrence"), String("Value")),
        (String("Second occurrence"), String("Value")),
      ]),
    ),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "JTV5" {
  let in_yaml =
    #|? a
    #|  true
    #|: null
    #|  d
    #|? e
    #|  42
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(Map([(String("a true"), String("null d")), (String("e 42"), Null)])),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "JY7Z" {
  let in_yaml =
    #|key1: "quoted1"
    #|key2: "quoted2" no key: nor value
    #|key3: "quoted3"
    #|
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "K3WX" {
  let in_yaml =
    #|---
    #|{ "foo" # comment
    #|  :bar }
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(Map([(String("foo"), String("bar"))])),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "K4SU" {
  let in_yaml =
    #|- foo
    #|- bar
    #|- 42
    #|
  let expected : Array[@yaml.Yaml] = [
    Sequence([String("foo"), String("bar"), Integer(42)]),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "K527" {
  let in_yaml =
    #|>-
    #|  trimmed
    #|  
    #| 
    #|
    #|  as
    #|  space
    #|
  let expected : Array[@yaml.Yaml] = [String("trimmed\n\n\nas space")]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "K54U" {
  let in_yaml =
    #|---	scalar
    #|
  let expected : Array[@yaml.Yaml] = [String("scalar")]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "K858" {
  let in_yaml =
    #|strip: >-
    #|
    #|clip: >
    #|
    #|keep: |+
    #|
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(
      Map([
        (String("strip"), String("")),
        (String("clip"), String("")),
        (String("keep"), String("\n")),
      ]),
    ),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "KMK3" {
  let in_yaml =
    #|foo:
    #|  bar: 1
    #|baz: 2
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(
      Map([
        (String("foo"), Mapping(Map([(String("bar"), Integer(1))]))),
        (String("baz"), Integer(2)),
      ]),
    ),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "KS4U" {
  let in_yaml =
    #|---
    #|[
    #|sequence item
    #|]
    #|invalid item
    #|
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "KSS4" {
  let in_yaml =
    #|--- "quoted
    #|string"
    #|--- &node foo
    #|
  let expected : Array[@yaml.Yaml] = [String("quoted string"), String("foo")]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "L383" {
  let in_yaml =
    #|--- foo  # comment
    #|--- foo  # comment
    #|
  let expected : Array[@yaml.Yaml] = [String("foo"), String("foo")]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "L94M" {
  let in_yaml =
    #|? !!str a
    #|: !!int 47
    #|? c
    #|: !!str d
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(Map([(String("a"), Integer(47)), (String("c"), String("d"))])),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "L9U5" {
  let in_yaml =
    #|implicit block key : [
    #|  implicit flow key : value,
    #| ]
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(
      Map([
        (
          String("implicit block key"),
          Sequence([
            Mapping(Map([(String("implicit flow key"), String("value"))])),
          ]),
        ),
      ]),
    ),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "LE5A" {
  let in_yaml =
    #|- !!str "a"
    #|- 'b'
    #|- &anchor "c"
    #|- *anchor
    #|- !!str
    #|
  let expected : Array[@yaml.Yaml] = [
    Sequence([String("a"), String("b"), String("c"), String("c"), String("")]),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "LHL4" {
  let in_yaml =
    #|---
    #|!invalid{}tag scalar
    #|
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "LP6E" {
  let in_yaml =
    #|- [a, b , c ]
    #|- { "a"  : b
    #|   , c : 'd' ,
    #|   e   : "f"
    #|  }
    #|- [      ]
    #|
  let expected : Array[@yaml.Yaml] = [
    Sequence([
      Sequence([String("a"), String("b"), String("c")]),
      Mapping(
        Map([
          (String("a"), String("b")),
          (String("c"), String("d")),
          (String("e"), String("f")),
        ]),
      ),
      Sequence([]),
    ]),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "LQZ7" {
  let in_yaml =
    #|"implicit block key" : [
    #|  "implicit flow key" : value,
    #| ]
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(
      Map([
        (
          String("implicit block key"),
          Sequence([
            Mapping(Map([(String("implicit flow key"), String("value"))])),
          ]),
        ),
      ]),
    ),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "M29M" {
  let in_yaml =
    #|a: |
    #| ab
    #| 
    #| cd
    #| ef
    #| 
    #|
    #|...
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(Map([(String("a"), String("ab\n\ncd\nef\n"))])),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "M5C3" {
  let in_yaml =
    #|literal: |2
    #|  value
    #|folded:
    #|   !foo
    #|  >1
    #| value
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(
      Map([
        (String("literal"), String("value\n")),
        (String("folded"), String("value\n")),
      ]),
    ),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "M6YH" {
  let in_yaml =
    #|- |
    #| x
    #|-
    #| foo: bar
    #|-
    #| - 42
    #|
  let expected : Array[@yaml.Yaml] = [
    Sequence([
      String("x\n"),
      Mapping(Map([(String("foo"), String("bar"))])),
      Sequence([Integer(42)]),
    ]),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "M7A3" {
  let in_yaml =
    #|Bare
    #|document
    #|...
    #|# No document
    #|...
    #||
    #|%!PS-Adobe-2.0 # Not the first line
    #|
  let expected : Array[@yaml.Yaml] = [
    String("Bare document"),
    String("%!PS-Adobe-2.0 # Not the first line\n"),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "M7NX" {
  let in_yaml =
    #|---
    #|{
    #| a: [
    #|  b, c, {
    #|   d: [e, f]
    #|  }
    #| ]
    #|}
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(
      Map([
        (
          String("a"),
          Sequence([
            String("b"),
            String("c"),
            Mapping(Map([(String("d"), Sequence([String("e"), String("f")]))])),
          ]),
        ),
      ]),
    ),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "M9B4" {
  let in_yaml =
    #||
    #| literal
    #| 	text
    #|
    #|
    #|
  let expected : Array[@yaml.Yaml] = [String("literal\n\ttext\n")]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "MJS9" {
  let in_yaml =
    #|>
    #|  foo 
    #| 
    #|  	 bar
    #|
    #|  baz
    #|
  let expected : Array[@yaml.Yaml] = [String("foo \n\n\t bar\n\nbaz\n")]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "MXS3" {
  let in_yaml =
    #|- {a: b}
    #|
  let expected : Array[@yaml.Yaml] = [
    Sequence([Mapping(Map([(String("a"), String("b"))]))]),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "MYW6" {
  let in_yaml =
    #||-
    #| ab
    #| 
    #| 
    #|...
    #|
  let expected : Array[@yaml.Yaml] = [String("ab")]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "MZX3" {
  let in_yaml =
    #|- plain
    #|- "double quoted"
    #|- 'single quoted'
    #|- >
    #|  block
    #|- plain again
    #|
  let expected : Array[@yaml.Yaml] = [
    Sequence([
      String("plain"),
      String("double quoted"),
      String("single quoted"),
      String("block\n"),
      String("plain again"),
    ]),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "N4JP" {
  let in_yaml =
    #|map:
    #|  key1: "quoted1"
    #| key2: "bad indentation"
    #|
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "N782" {
  let in_yaml =
    #|[
    #|--- ,
    #|...
    #|]
    #|
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "NAT4" {
  let in_yaml =
    #|---
    #|a: '
    #|  '
    #|b: '  
    #|  '
    #|c: "
    #|  "
    #|d: "  
    #|  "
    #|e: '
    #|
    #|  '
    #|f: "
    #|
    #|  "
    #|g: '
    #|
    #|
    #|  '
    #|h: "
    #|
    #|
    #|  "
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(
      Map([
        (String("a"), String(" ")),
        (String("b"), String(" ")),
        (String("c"), String(" ")),
        (String("d"), String(" ")),
        (String("e"), String("\n")),
        (String("f"), String("\n")),
        (String("g"), String("\n\n")),
        (String("h"), String("\n\n")),
      ]),
    ),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "NB6Z" {
  let in_yaml =
    #|key:
    #|  value
    #|  with
    #|  	
    #|  tabs
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(Map([(String("key"), String("value with\ntabs"))])),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "NJ66" {
  let in_yaml =
    #|---
    #|- { single line: value}
    #|- { multi
    #|  line: value}
    #|
  let expected : Array[@yaml.Yaml] = [
    Sequence([
      Mapping(Map([(String("single line"), String("value"))])),
      Mapping(Map([(String("multi line"), String("value"))])),
    ]),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "NP9H" {
  let in_yaml =
    #|"folded 
    #|to a space,	
    #| 
    #|to a line feed, or 	\
    #| \ 	non-content"
    #|
  let expected : Array[@yaml.Yaml] = [
    String("folded to a space,\nto a line feed, or \t \tnon-content"),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "P2AD" {
  let in_yaml =
    #|- | # Empty header↓
    #| literal
    #|- >1 # Indentation indicator↓
    #|  folded
    #|- |+ # Chomping indicator↓
    #| keep
    #|
    #|- >1- # Both indicators↓
    #|  strip
    #|
  let expected : Array[@yaml.Yaml] = [
    Sequence([
      String("literal\n"),
      String(" folded\n"),
      String("keep\n\n"),
      String(" strip"),
    ]),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "P2EQ" {
  let in_yaml =
    #|---
    #|- { y: z }- invalid
    #|
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "P76L" {
  let in_yaml =
    #|%TAG !! tag:example.com,2000:app/
    #|---
    #|!!int 1 - 3 # Interval, not integer
    #|
  let expected : Array[@yaml.Yaml] = [String("1 - 3")]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "P94K" {
  let in_yaml =
    #|key:    # Comment
    #|        # lines
    #|  value
    #|
    #|
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(Map([(String("key"), String("value"))])),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "PBJ2" {
  let in_yaml =
    #|american:
    #|  - Boston Red Sox
    #|  - Detroit Tigers
    #|  - New York Yankees
    #|national:
    #|  - New York Mets
    #|  - Chicago Cubs
    #|  - Atlanta Braves
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(
      Map([
        (
          String("american"),
          Sequence([
            String("Boston Red Sox"),
            String("Detroit Tigers"),
            String("New York Yankees"),
          ]),
        ),
        (
          String("national"),
          Sequence([
            String("New York Mets"),
            String("Chicago Cubs"),
            String("Atlanta Braves"),
          ]),
        ),
      ]),
    ),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "PRH3" {
  let in_yaml =
    #|' 1st non-empty
    #|
    #| 2nd non-empty 
    #|	3rd non-empty '
    #|
  let expected : Array[@yaml.Yaml] = [
    String(" 1st non-empty\n2nd non-empty 3rd non-empty "),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "PUW8" {
  let in_yaml =
    #|---
    #|a: b
    #|---
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(Map([(String("a"), String("b"))])),
    Null,
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "Q4CL" {
  let in_yaml =
    #|key1: "quoted1"
    #|key2: "quoted2" trailing content
    #|key3: "quoted3"
    #|
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "Q5MG" {
  let in_yaml =
    #|	{}
    #|
  let expected : Array[@yaml.Yaml] = [Mapping(Map([]))]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "Q88A" {
  let in_yaml =
    #|- [ a, b ]
    #|- { a: b }
    #|- "a"
    #|- 'b'
    #|- c
    #|
  let expected : Array[@yaml.Yaml] = [
    Sequence([
      Sequence([String("a"), String("b")]),
      Mapping(Map([(String("a"), String("b"))])),
      String("a"),
      String("b"),
      String("c"),
    ]),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "Q8AD" {
  let in_yaml =
    #|---
    #|"folded 
    #|to a space,
    #| 
    #|to a line feed, or 	\
    #| \ 	non-content"
    #|
  let expected : Array[@yaml.Yaml] = [
    String("folded to a space,\nto a line feed, or \t \tnon-content"),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "QB6E" {
  let in_yaml =
    #|---
    #|quoted: "a
    #|b
    #|c"
    #|
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "QF4Y" {
  let in_yaml =
    #|[
    #|foo: bar
    #|]
    #|
  let expected : Array[@yaml.Yaml] = [
    Sequence([Mapping(Map([(String("foo"), String("bar"))]))]),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "QLJ7" {
  let in_yaml =
    #|%TAG !prefix! tag:example.com,2011:
    #|--- !prefix!A
    #|a: b
    #|--- !prefix!B
    #|c: d
    #|--- !prefix!C
    #|e: f
    #|
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "R4YG" {
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
    #| 	
    #| detected
    #|
  let expected : Array[@yaml.Yaml] = [
    Sequence([
      String("detected\n"),
      String("\n\n# detected\n"),
      String(" explicit\n"),
      String("\t\ndetected\n"),
    ]),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "R52L" {
  let in_yaml =
    #|---
    #|{ top1: [item1, {key2: value2}, item3], top2: value2 }
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(
      Map([
        (
          String("top1"),
          Sequence([
            String("item1"),
            Mapping(Map([(String("key2"), String("value2"))])),
            String("item3"),
          ]),
        ),
        (String("top2"), String("value2")),
      ]),
    ),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "RHX7" {
  let in_yaml =
    #|---
    #|key: value
    #|%YAML 1.2
    #|---
    #|
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "RLU9" {
  let in_yaml =
    #|foo:
    #|- 42
    #|bar:
    #|  - 44
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(
      Map([
        (String("foo"), Sequence([Integer(42)])),
        (String("bar"), Sequence([Integer(44)])),
      ]),
    ),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "RR7F" {
  let in_yaml =
    #|a: 4.2
    #|? d
    #|: 23
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(Map([(String("a"), Float(4.2)), (String("d"), Integer(23))])),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "RTP8" {
  let in_yaml =
    #|%YAML 1.2
    #|---
    #|Document
    #|... # Suffix
    #|
  let expected : Array[@yaml.Yaml] = [String("Document")]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "RXY3" {
  let in_yaml =
    #|---
    #|'
    #|...
    #|'
    #|
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "RZT7" {
  let in_yaml =
    #|---
    #|Time: 2001-11-23 15:01:42 -5
    #|User: ed
    #|Warning:
    #|  This is an error message
    #|  for the log file
    #|---
    #|Time: 2001-11-23 15:02:31 -5
    #|User: ed
    #|Warning:
    #|  A slightly different error
    #|  message.
    #|---
    #|Date: 2001-11-23 15:03:17 -5
    #|User: ed
    #|Fatal:
    #|  Unknown variable "bar"
    #|Stack:
    #|  - file: TopClass.py
    #|    line: 23
    #|    code: |
    #|      x = MoreObject("345\n")
    #|  - file: MoreClass.py
    #|    line: 58
    #|    code: |-
    #|      foo = bar
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(
      Map([
        (String("Time"), String("2001-11-23 15:01:42 -5")),
        (String("User"), String("ed")),
        (String("Warning"), String("This is an error message for the log file")),
      ]),
    ),
    Mapping(
      Map([
        (String("Time"), String("2001-11-23 15:02:31 -5")),
        (String("User"), String("ed")),
        (String("Warning"), String("A slightly different error message.")),
      ]),
    ),
    Mapping(
      Map([
        (String("Date"), String("2001-11-23 15:03:17 -5")),
        (String("User"), String("ed")),
        (String("Fatal"), String("Unknown variable \"bar\"")),
        (
          String("Stack"),
          Sequence([
            Mapping(
              Map([
                (String("file"), String("TopClass.py")),
                (String("line"), Integer(23)),
                (String("code"), String("x = MoreObject(\"345\\n\")\n")),
              ]),
            ),
            Mapping(
              Map([
                (String("file"), String("MoreClass.py")),
                (String("line"), Integer(58)),
                (String("code"), String("foo = bar")),
              ]),
            ),
          ]),
        ),
      ]),
    ),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "S4GJ" {
  let in_yaml =
    #|---
    #|folded: > first line
    #|  second line
    #|
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "S4JQ" {
  let in_yaml =
    #|# Assuming conventional resolution:
    #|- "12"
    #|- 12
    #|- ! 12
    #|
  let expected : Array[@yaml.Yaml] = [
    Sequence([String("12"), Integer(12), String("12")]),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "S4T7" {
  let in_yaml =
    #|aaa: bbb
    #|...
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(Map([(String("aaa"), String("bbb"))])),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "S7BG" {
  let in_yaml =
    #|---
    #|- :,
    #|
  let expected : Array[@yaml.Yaml] = [Sequence([String(":,")])]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "S98Z" {
  let in_yaml =
    #|empty block scalar: >
    #| 
    #|  
    #|   
    #| # comment
    #|
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "S9E8" {
  let in_yaml =
    #|sequence:
    #|- one
    #|- two
    #|mapping:
    #|  ? sky
    #|  : blue
    #|  sea : green
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(
      Map([
        (String("sequence"), Sequence([String("one"), String("two")])),
        (
          String("mapping"),
          Mapping(
            Map([
              (String("sky"), String("blue")),
              (String("sea"), String("green")),
            ]),
          ),
        ),
      ]),
    ),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "SF5V" {
  let in_yaml =
    #|%YAML 1.2
    #|%YAML 1.2
    #|---
    #|
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "SKE5" {
  let in_yaml =
    #|---
    #|seq:
    #| &anchor
    #|- a
    #|- b
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(Map([(String("seq"), Sequence([String("a"), String("b")]))])),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "SR86" {
  let in_yaml =
    #|key1: &a value
    #|key2: &b *a
    #|
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "SSW6" {
  let in_yaml =
    #|---
    #|'here''s to "quotes"'
    #|
  let expected : Array[@yaml.Yaml] = [String("here's to \"quotes\"")]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "SU5Z" {
  let in_yaml =
    #|key: "value"# invalid comment
    #|
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "SU74" {
  let in_yaml =
    #|key1: &alias value1
    #|&b *alias : value2
    #|
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "SY6V" {
  let in_yaml =
    #|&anchor - sequence entry
    #|
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "SYW4" {
  let in_yaml =
    #|hr:  65    # Home runs
    #|avg: 0.278 # Batting average
    #|rbi: 147   # Runs Batted In
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(
      Map([
        (String("hr"), Integer(65)),
        (String("avg"), Float(0.278)),
        (String("rbi"), Integer(147)),
      ]),
    ),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "T26H" {
  let in_yaml =
    #|--- |
    #| 
    #|  
    #|  literal
    #|   
    #|  
    #|  text
    #|
    #| # Comment
    #|
  let expected : Array[@yaml.Yaml] = [String("\n\nliteral\n \n\ntext\n")]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "T4YY" {
  let in_yaml =
    #|---
    #|' 1st non-empty
    #|
    #| 2nd non-empty 
    #| 3rd non-empty '
    #|
  let expected : Array[@yaml.Yaml] = [
    String(" 1st non-empty\n2nd non-empty 3rd non-empty "),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "T5N4" {
  let in_yaml =
    #|--- |
    #| literal
    #| 	text
    #|
    #|
    #|
  let expected : Array[@yaml.Yaml] = [String("literal\n\ttext\n")]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "T833" {
  let in_yaml =
    #|---
    #|{
    #| foo: 1
    #| bar: 2 }
    #|
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "TD5N" {
  let in_yaml =
    #|- item1
    #|- item2
    #|invalid
    #|
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "TE2A" {
  let in_yaml =
    #|block mapping:
    #| key: value
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(
      Map([
        (
          String("block mapping"),
          Mapping(Map([(String("key"), String("value"))])),
        ),
      ]),
    ),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "TL85" {
  let in_yaml =
    #|"
    #|  foo 
    #| 
    #|  	 bar
    #|
    #|  baz
    #|"
    #|
  let expected : Array[@yaml.Yaml] = [String(" foo\nbar\nbaz ")]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "TS54" {
  let in_yaml =
    #|>
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
test "U3C3" {
  let in_yaml =
    #|%TAG !yaml! tag:yaml.org,2002:
    #|---
    #|!yaml!str "foo"
    #|
  let expected : Array[@yaml.Yaml] = [String("foo")]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "U3XV" {
  let in_yaml =
    #|---
    #|top1: &node1
    #|  &k1 key1: one
    #|top2: &node2 # comment
    #|  key2: two
    #|top3:
    #|  &k3 key3: three
    #|top4:
    #|  &node4
    #|  &k4 key4: four
    #|top5:
    #|  &node5
    #|  key5: five
    #|top6: &val6
    #|  six
    #|top7:
    #|  &val7 seven
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(
      Map([
        (String("top1"), Mapping(Map([(String("key1"), String("one"))]))),
        (String("top2"), Mapping(Map([(String("key2"), String("two"))]))),
        (String("top3"), Mapping(Map([(String("key3"), String("three"))]))),
        (String("top4"), Mapping(Map([(String("key4"), String("four"))]))),
        (String("top5"), Mapping(Map([(String("key5"), String("five"))]))),
        (String("top6"), String("six")),
        (String("top7"), String("seven")),
      ]),
    ),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "U44R" {
  let in_yaml =
    #|map:
    #|  key1: "quoted1"
    #|   key2: "bad indentation"
    #|
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "U99R" {
  let in_yaml =
    #|- !!str, xxx
    #|
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "U9NS" {
  let in_yaml =
    #|---
    #|time: 20:03:20
    #|player: Sammy Sosa
    #|action: strike (miss)
    #|...
    #|---
    #|time: 20:03:47
    #|player: Sammy Sosa
    #|action: grand slam
    #|...
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(
      Map([
        (String("time"), String("20:03:20")),
        (String("player"), String("Sammy Sosa")),
        (String("action"), String("strike (miss)")),
      ]),
    ),
    Mapping(
      Map([
        (String("time"), String("20:03:47")),
        (String("player"), String("Sammy Sosa")),
        (String("action"), String("grand slam")),
      ]),
    ),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "UDM2" {
  let in_yaml =
    #|- { url: http://example.org }
    #|
  let expected : Array[@yaml.Yaml] = [
    Sequence([Mapping(Map([(String("url"), String("http://example.org"))]))]),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "UDR7" {
  let in_yaml =
    #|sequence: [ one, two, ]
    #|mapping: { sky: blue, sea: green }
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(
      Map([
        (String("sequence"), Sequence([String("one"), String("two")])),
        (
          String("mapping"),
          Mapping(
            Map([
              (String("sky"), String("blue")),
              (String("sea"), String("green")),
            ]),
          ),
        ),
      ]),
    ),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "UGM3" {
  let in_yaml =
    #|--- !<tag:clarkevans.com,2002:invoice>
    #|invoice: 34843
    #|date   : 2001-01-23
    #|bill-to: &id001
    #|    given  : Chris
    #|    family : Dumars
    #|    address:
    #|        lines: |
    #|            458 Walkman Dr.
    #|            Suite #292
    #|        city    : Royal Oak
    #|        state   : MI
    #|        postal  : 48046
    #|ship-to: *id001
    #|product:
    #|    - sku         : BL394D
    #|      quantity    : 4
    #|      description : Basketball
    #|      price       : 450.00
    #|    - sku         : BL4438H
    #|      quantity    : 1
    #|      description : Super Hoop
    #|      price       : 2392.00
    #|tax  : 251.42
    #|total: 4443.52
    #|comments:
    #|    Late afternoon is best.
    #|    Backup contact is Nancy
    #|    Billsmer @ 338-4338.
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(
      Map([
        (String("invoice"), Integer(34843)),
        (String("date"), String("2001-01-23")),
        (
          String("bill-to"),
          Mapping(
            Map([
              (String("given"), String("Chris")),
              (String("family"), String("Dumars")),
              (
                String("address"),
                Mapping(
                  Map([
                    (String("lines"), String("458 Walkman Dr.\nSuite #292\n")),
                    (String("city"), String("Royal Oak")),
                    (String("state"), String("MI")),
                    (String("postal"), Integer(48046)),
                  ]),
                ),
              ),
            ]),
          ),
        ),
        (
          String("ship-to"),
          Mapping(
            Map([
              (String("given"), String("Chris")),
              (String("family"), String("Dumars")),
              (
                String("address"),
                Mapping(
                  Map([
                    (String("lines"), String("458 Walkman Dr.\nSuite #292\n")),
                    (String("city"), String("Royal Oak")),
                    (String("state"), String("MI")),
                    (String("postal"), Integer(48046)),
                  ]),
                ),
              ),
            ]),
          ),
        ),
        (
          String("product"),
          Sequence([
            Mapping(
              Map([
                (String("sku"), String("BL394D")),
                (String("quantity"), Integer(4)),
                (String("description"), String("Basketball")),
                (String("price"), Float(450.0)),
              ]),
            ),
            Mapping(
              Map([
                (String("sku"), String("BL4438H")),
                (String("quantity"), Integer(1)),
                (String("description"), String("Super Hoop")),
                (String("price"), Float(2392.0)),
              ]),
            ),
          ]),
        ),
        (String("tax"), Float(251.42)),
        (String("total"), Float(4443.52)),
        (
          String("comments"),
          String(
            "Late afternoon is best. Backup contact is Nancy Billsmer @ 338-4338.",
          ),
        ),
      ]),
    ),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "UT92" {
  let in_yaml =
    #|---
    #|{ matches
    #|% : 20 }
    #|...
    #|---
    #|# Empty
    #|...
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(Map([(String("matches %"), Integer(20))])),
    Null,
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "UV7Q" {
  let in_yaml =
    #|x:
    #| - x
    #|  	x
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(Map([(String("x"), Sequence([String("x x")]))])),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "V55R" {
  let in_yaml =
    #|- &a a
    #|- &b b
    #|- *a
    #|- *b
    #|
  let expected : Array[@yaml.Yaml] = [
    Sequence([String("a"), String("b"), String("a"), String("b")]),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "W42U" {
  let in_yaml =
    #|- # Empty
    #|- |
    #| block node
    #|- - one # Compact
    #|  - two # sequence
    #|- one: two # Compact mapping
    #|
  let expected : Array[@yaml.Yaml] = [
    Sequence([
      Null,
      String("block node\n"),
      Sequence([String("one"), String("two")]),
      Mapping(Map([(String("one"), String("two"))])),
    ]),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "W4TN" {
  let in_yaml =
    #|%YAML 1.2
    #|--- |
    #|%!PS-Adobe-2.0
    #|...
    #|%YAML 1.2
    #|---
    #|# Empty
    #|...
    #|
  let expected : Array[@yaml.Yaml] = [String("%!PS-Adobe-2.0\n"), Null]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "W5VH" {
  let in_yaml =
    #|a: &:@*!$"<foo>: scalar a
    #|b: *:@*!$"<foo>:
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(
      Map([(String("a"), String("scalar a")), (String("b"), String("scalar a"))]),
    ),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "W9L4" {
  let in_yaml =
    #|---
    #|block scalar: |
    #|     
    #|  more spaces at the beginning
    #|  are invalid
    #|
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "WZ62" {
  let in_yaml =
    #|{
    #|  foo : !!str,
    #|  !!str : bar,
    #|}
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(Map([(String("foo"), String("")), (String(""), String("bar"))])),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "X4QW" {
  let in_yaml =
    #|block: ># comment
    #|  scalar
    #|
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "X8DW" {
  let in_yaml =
    #|---
    #|? key
    #|# comment
    #|: value
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(Map([(String("key"), String("value"))])),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "XLQ9" {
  let in_yaml =
    #|---
    #|scalar
    #|%YAML 1.2
    #|
  let expected : Array[@yaml.Yaml] = [String("scalar %YAML 1.2")]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "XV9V" {
  let in_yaml =
    #|Folding:
    #|  "Empty line
    #|
    #|  as a line feed"
    #|Chomping: |
    #|  Clipped empty lines
    #| 
    #|
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(
      Map([
        (String("Folding"), String("Empty line\nas a line feed")),
        (String("Chomping"), String("Clipped empty lines\n")),
      ]),
    ),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "Y2GN" {
  let in_yaml =
    #|---
    #|key: &an:chor value
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(Map([(String("key"), String("value"))])),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "YD5X" {
  let in_yaml =
    #|- [name        , hr, avg  ]
    #|- [Mark McGwire, 65, 0.278]
    #|- [Sammy Sosa  , 63, 0.288]
    #|
  let expected : Array[@yaml.Yaml] = [
    Sequence([
      Sequence([String("name"), String("hr"), String("avg")]),
      Sequence([String("Mark McGwire"), Integer(65), Float(0.278)]),
      Sequence([String("Sammy Sosa"), Integer(63), Float(0.288)]),
    ]),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "YJV2" {
  let in_yaml =
    #|[-]
    #|
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "Z67P" {
  let in_yaml =
    #|literal: |2
    #|  value
    #|folded: !foo >1
    #| value
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(
      Map([
        (String("literal"), String("value\n")),
        (String("folded"), String("value\n")),
      ]),
    ),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "Z9M4" {
  let in_yaml =
    #|%TAG !e! tag:example.com,2000:app/
    #|---
    #|- !e!foo "bar"
    #|
  let expected : Array[@yaml.Yaml] = [Sequence([String("bar")])]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "ZCZ6" {
  let in_yaml =
    #|a: b: c: d
    #|
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "ZF4X" {
  let in_yaml =
    #|Mark McGwire: {hr: 65, avg: 0.278}
    #|Sammy Sosa: {
    #|    hr: 63,
    #|    avg: 0.288
    #|  }
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(
      Map([
        (
          String("Mark McGwire"),
          Mapping(
            Map([(String("hr"), Integer(65)), (String("avg"), Float(0.278))]),
          ),
        ),
        (
          String("Sammy Sosa"),
          Mapping(
            Map([(String("hr"), Integer(63)), (String("avg"), Float(0.288))]),
          ),
        ),
      ]),
    ),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "ZH7C" {
  let in_yaml =
    #|&a a: b
    #|c: &d d
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(Map([(String("a"), String("b")), (String("c"), String("d"))])),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "ZK9H" {
  let in_yaml =
    #|{ key: [[[
    #|  value
    #| ]]]
    #|}
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(
      Map([(String("key"), Sequence([Sequence([Sequence([String("value")])])]))]),
    ),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "ZL4Z" {
  let in_yaml =
    #|---
    #|a: 'b': c
    #|
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "ZVH3" {
  let in_yaml =
    #|- key: value
    #| - item1
    #|
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "ZWK4" {
  let in_yaml =
    #|---
    #|a: 1
    #|? b
    #|&anchor c: 3
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(
      Map([
        (String("a"), Integer(1)),
        (String("b"), Null),
        (String("c"), Integer(3)),
      ]),
    ),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "ZXT5" {
  let in_yaml =
    #|[ "key"
    #|  :value ]
    #|
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "parse booleans and numbers" {
  let in_yaml =
    #|t: true
    #|f: false
    #|i: 42
    #|x: 0.25
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(
      Map([
        (String("t"), Bool(true)),
        (String("f"), Bool(false)),
        (String("i"), Integer(42)),
        (String("x"), Float(0.25)),
      ]),
    ),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "parse quoted string with escapes" {
  let in_yaml =
    #|a: "line1\nline2\tend"
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(Map([(String("a"), String("line1\nline2\tend"))])),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "parse quoted scalar containing colon" {
  let in_yaml =
    #|a: "b: c"
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(Map([(String("a"), String("b: c"))])),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "impl01 basic example" {
  let in_yaml =
    #|# comment
    #|a0 bb: val
    #|a1:
    #|    b1: 4
    #|    b2: d
    #|a2: 4 # i'm comment
    #|a3: [1, 2, 3]
    #|a4:
    #|    - - a1
    #|      - a2
    #|    - 2
    #|a5: 'single_quoted'
    #|a6: "double_quoted"
    #|a7: 你好
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(
      Map([
        (String("a0 bb"), String("val")),
        (
          String("a1"),
          Mapping(
            Map([(String("b1"), Integer(4)), (String("b2"), String("d"))]),
          ),
        ),
        (String("a2"), Integer(4)),
        (String("a3"), Sequence([Integer(1), Integer(2), Integer(3)])),
        (
          String("a4"),
          Sequence([Sequence([String("a1"), String("a2")]), Integer(2)]),
        ),
        (String("a5"), String("single_quoted")),
        (String("a6"), String("double_quoted")),
        (String("a7"), String("你好")),
      ]),
    ),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "impl01 openapi quoting example" {
  let in_yaml =
    #|example: '[''This is a test.'']'
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(Map([(String("example"), String("['This is a test.']"))])),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "parse sequence" {
  let in_yaml =
    #|- one
    #|- two
    #|- 3
    #|
  let expected : Array[@yaml.Yaml] = [
    Sequence([String("one"), String("two"), Integer(3)]),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "print roundtrip preserves the stream" {
  let in_yaml =
    #|a: 1
    #|b:
    #|  - x
    #|  - y
    #|
  let docs = @yaml.parse(in_yaml)
  assert_eq(@yaml.parse(@yaml.print(docs)), docs)
}

///|
test "flow collections" {
  let in_yaml =
    #|{a: 1, b: [2, 3]}
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(
      Map([
        (String("a"), Integer(1)),
        (String("b"), Sequence([Integer(2), Integer(3)])),
      ]),
    ),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "nested structures" {
  let in_yaml =
    #|a:
    #|  b:
    #|    - 1
    #|    - 2
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(
      Map([
        (
          String("a"),
          Mapping(Map([(String("b"), Sequence([Integer(1), Integer(2)]))])),
        ),
      ]),
    ),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "literal block scalar" {
  let in_yaml =
    #|a: |
    #|  line1
    #|  line2
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(Map([(String("a"), String("line1\nline2\n"))])),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "flow scalar inside block sequence" {
  let in_yaml =
    #|-
    #|  "flow in block"
    #|- >
    #| Block scalar
    #|
  let expected : Array[@yaml.Yaml] = [
    Sequence([String("flow in block"), String("Block scalar\n")]),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "multiple documents returns first document" {
  let in_yaml =
    #|Document
    #|---
    #|# Empty
    #|...
    #|%YAML 1.2
    #|---
    #|matches %: 20
    #|
  let expected : Array[@yaml.Yaml] = [
    String("Document"),
    Null,
    Mapping(Map([(String("matches %"), Integer(20))])),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "explicit empty document is null" {
  let in_yaml =
    #|---
    #|---
    #|
  let expected : Array[@yaml.Yaml] = [Null, Null]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "impl01 comment after tag + docstart" {
  let in_yaml =
    #|%YAML 1.2
    #|# This is a comment
    #|--- #-------
    #|foobar
    #|
  let expected : Array[@yaml.Yaml] = [String("foobar")]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "impl01 large block scalar indent" {
  let in_yaml =
    #|a: |-
    #|                  a
    #|                      b
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(Map([(String("a"), String("a\n    b"))])),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "impl01 three dashes as content" {
  let in_yaml =
    #|---
    #|---word1
    #|word2
    #|
  let expected : Array[@yaml.Yaml] = [String("---word1 word2")]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "impl01 multiline flow mapping keys" {
  let in_yaml =
    #|---
    #|- { "single line", a: b}
    #|- { "multi
    #|  line", a: b}
    #|
  let expected : Array[@yaml.Yaml] = [
    Sequence([
      Mapping(Map([(String("single line"), Null), (String("a"), String("b"))])),
      Mapping(Map([(String("multi line"), Null), (String("a"), String("b"))])),
    ]),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "impl01 flow sequence entries" {
  let in_yaml =
    #|[
    #|"double
    #| quoted", 'single
    #|           quoted',
    #|plain
    #| text, [ nested ],
    #|single: pair,
    #|]
    #|
  let expected : Array[@yaml.Yaml] = [
    Sequence([
      String("double quoted"),
      String("single quoted"),
      String("plain text"),
      Sequence([String("nested")]),
      Mapping(Map([(String("single"), String("pair"))])),
    ]),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "explicit tags for seq/map" {
  let in_yaml =
    #|foo: !!seq
    #|  - !!str a
    #|  - !!map
    #|    key: !!str value
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(
      Map([
        (
          String("foo"),
          Sequence([
            String("a"),
            Mapping(Map([(String("key"), String("value"))])),
          ]),
        ),
      ]),
    ),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "missing values become null" {
  let in_yaml =
    #|---
    #|a: &anchor
    #|b: *anchor
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(Map([(String("a"), Null), (String("b"), Null)])),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "print roundtrip with nesting" {
  let in_yaml =
    #|a:
    #|  b: [1, 2, 3]
    #|  c: {d: 4}
    #|
  let docs = @yaml.parse(in_yaml)
  assert_eq(@yaml.parse(@yaml.print(docs)), docs)
}

///|
test "anchors and aliases as keys" {
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
test "sets become null-valued mapping" {
  let in_yaml =
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
test "explicit and block keys" {
  let in_yaml =
    #|? explicit key # Empty value
    #|? |
    #|  block key
    #|: - one # Explicit compact
    #|  - two # block value
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(
      Map([
        (String("explicit key"), Null),
        (String("block key\n"), Sequence([String("one"), String("two")])),
      ]),
    ),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "question-mark prefixed key in flow mapping" {
  let in_yaml =
    #|{ ?foo: bar,
    #|bar: 42
    #|}
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(
      Map([(String("?foo"), String("bar")), (String("bar"), Integer(42))]),
    ),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "tabs are treated as whitespace" {
  let in_yaml =
    #|- foo:	 bar
    #|- - baz
    #|  -	baz
    #|
  let expected : Array[@yaml.Yaml] = [
    Sequence([
      Mapping(Map([(String("foo"), String("bar"))])),
      Sequence([String("baz"), String("baz")]),
    ]),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "impl01 tag handle declared only in the first document is an error" {
  let in_yaml =
    #|%YAML 1.1
    #|%TAG !t! tag:test,2024:
    #|--- !t!1 &1
    #|foo: "bar"
    #|--- !t!2 &2
    #|baz: "qux"
    #|
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "impl01 anchors in mapping" {
  let in_yaml =
    #|&a a: b
    #|c: &d d
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(Map([(String("a"), String("b")), (String("c"), String("d"))])),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "impl01 implicit flow keys under implicit block key" {
  let in_yaml =
    #|"implicit block key" : [
    #|  "implicit flow key" : value,
    #| ]
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(
      Map([
        (
          String("implicit block key"),
          Sequence([
            Mapping(Map([(String("implicit flow key"), String("value"))])),
          ]),
        ),
      ]),
    ),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "impl01 node properties with anchors" {
  let in_yaml =
    #|!!str &a1 "foo":
    #|  !!str bar
    #|&a2 baz : *a1
    #|
  let expected : Array[@yaml.Yaml] = [
    Mapping(
      Map([(String("foo"), String("bar")), (String("baz"), String("foo"))]),
    ),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "print roundtrip with anchors" {
  let in_yaml =
    #|a: &anchor
    #|  b: 1
    #|c: *anchor
    #|
  let docs = @yaml.parse(in_yaml)
  assert_eq(@yaml.parse(@yaml.print(docs)), docs)
}

///|
test "spec/stream/comment-only" {
  let in_yaml =
    #|# nothing here
    #|
  let expected : Array[@yaml.Yaml] = []
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "spec/stream/document-end-only" {
  let in_yaml =
    #|...
  let expected : Array[@yaml.Yaml] = []
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "spec/stream/document-end-then-bare-document" {
  let in_yaml =
    #|...
    #|...
    #|foo
  let expected : Array[@yaml.Yaml] = [String("foo")]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "spec/stream/trailing-document-start" {
  let in_yaml =
    #|a
    #|---
  let expected : Array[@yaml.Yaml] = [String("a"), Null]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "spec/stream/syntax-error-in-second-document" {
  let in_yaml =
    #|a: 1
    #|---
    #|b: [1, 2
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "spec/stream/indentation-error-in-third-document" {
  let in_yaml =
    #|--- x
    #|--- y
    #|---
    #|a:
    #|  b: 1
    #| c: 2
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "spec/stream/escape-error-in-second-document" {
  let in_yaml =
    #|ok
    #|...
    #|"\q"
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "spec/errors/unterminated-single-quoted" {
  let in_yaml =
    #|a: 'x
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "spec/errors/unterminated-single-quoted-at-root" {
  let in_yaml =
    #|'abc
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "spec/errors/unterminated-flow-mapping" {
  let in_yaml =
    #|a: {b: 1
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "spec/errors/flow-mapping-missing-comma" {
  let in_yaml =
    #|{a: 1 b: 2}
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "spec/encoding/nel-allowed-in-plain-scalar" {
  let in_yaml = "a: x\u{85}y\n"
  let expected : Array[@yaml.Yaml] = [
    Mapping(Map([(String("a"), String("x\u{85}y"))])),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "spec/schema/core-resolution-rows" {
  let in_yaml =
    #|- null
    #|- Null
    #|- NULL
    #|- ~
    #|-
    #|- true
    #|- True
    #|- TRUE
    #|- false
    #|- False
    #|- FALSE
    #|- 0
    #|- +12
    #|- -12
    #|- 007
    #|- 0o17
    #|- 0x1F
    #|- 0xfF
    #|- 1.5
    #|- .5
    #|- 5.
    #|- +1.5
    #|- -1.5e3
    #|- 1E-3
    #|- 1e3
    #|- 12.
    #|- .inf
    #|- .Inf
    #|- .INF
    #|- +.inf
    #|- -.inf
    #|- -.Inf
    #|- .nan
    #|- .NaN
    #|- .NAN
    #|- yes
    #|- no
    #|- on
    #|- off
    #|- y
    #|- n
    #|- 1_000
    #|- 0b101
    #|- 0o
    #|- 0x
    #|- -0x1
    #|- 1e
    #|- .e3
    #|- .
    #|- +.nan
    #|- -.nan
    #|- 2001-12-14
    #|- 12:30
    #|- 0123
    #|- 0o8
    #|- 0x1G
    #|- 1.5.2
    #|- +
  let expected : Array[@yaml.Yaml] = [
    Sequence([
      Null,
      Null,
      Null,
      Null,
      Null,
      Bool(true),
      Bool(true),
      Bool(true),
      Bool(false),
      Bool(false),
      Bool(false),
      Integer(0),
      Integer(12),
      Integer(-12),
      Integer(7),
      Integer(15),
      Integer(31),
      Integer(255),
      Float(1.5),
      Float(0.5),
      Float(5.0),
      Float(1.5),
      Float(-1500.0),
      Float(0.001),
      Float(1000.0),
      Float(12.0),
      Float(@double.infinity),
      Float(@double.infinity),
      Float(@double.infinity),
      Float(@double.infinity),
      Float(@double.neg_infinity),
      Float(@double.neg_infinity),
      Float(@double.not_a_number),
      Float(@double.not_a_number),
      Float(@double.not_a_number),
      String("yes"),
      String("no"),
      String("on"),
      String("off"),
      String("y"),
      String("n"),
      String("1_000"),
      String("0b101"),
      String("0o"),
      String("0x"),
      String("-0x1"),
      String("1e"),
      String(".e3"),
      String("."),
      String("+.nan"),
      String("-.nan"),
      String("2001-12-14"),
      String("12:30"),
      Integer(123),
      String("0o8"),
      String("0x1G"),
      String("1.5.2"),
      String("+"),
    ]),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "spec/schema/quoted-and-block-scalars-are-strings" {
  let in_yaml =
    #|- '12'
    #|- "true"
    #|- 'null'
    #|- ""
    #|- |
    #|  12
    #|- >
    #|  1.5
    #|- ! 7
  let expected : Array[@yaml.Yaml] = [
    Sequence([
      String("12"),
      String("true"),
      String("null"),
      String(""),
      String("12\n"),
      String("1.5\n"),
      String("7"),
    ]),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "spec/schema/negative-zero-and-float-forms" {
  let in_yaml =
    #|- -0
    #|- -0.0
    #|- 0.0
    #|- 1e21
    #|- 5e-324
  let expected : Array[@yaml.Yaml] = [
    Sequence([
      Integer(0),
      Float(-0.0),
      Float(0.0),
      Float(1.0e21),
      Float(5.0e-324),
    ]),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "spec/keys/duplicate-by-value-decimal-vs-hex" {
  let in_yaml =
    #|1: a
    #|0x1: b
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "spec/keys/duplicate-by-value-octal-vs-decimal" {
  let in_yaml =
    #|{0o10: a, 8: b}
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "spec/keys/duplicate-by-value-float-forms" {
  let in_yaml =
    #|1.0: a
    #|1e0: b
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "spec/keys/duplicate-by-value-null-forms" {
  let in_yaml =
    #|~: a
    #|null: b
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "spec/keys/duplicate-by-value-bool-forms" {
  let in_yaml =
    #|true: a
    #|True: b
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "spec/keys/duplicate-by-value-quoted-vs-plain-string" {
  let in_yaml =
    #|a: 1
    #|"a": 2
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "spec/keys/duplicate-by-value-explicit-tag" {
  let in_yaml =
    #|!!str 1: a
    #|"1": b
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "spec/keys/duplicate-collection-keys" {
  let in_yaml =
    #|? [1, 2]
    #|: a
    #|? [1, 2]
    #|: b
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "spec/keys/duplicate-in-nested-mapping" {
  let in_yaml =
    #|outer:
    #|  x: 1
    #|  y: 2
    #|  x: 3
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "spec/keys/duplicate-in-flow-mapping" {
  let in_yaml =
    #|{a: 1, b: 2, a: 3}
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "spec/keys/distinct-int-and-string-keys-in-flow-mapping" {
  let in_yaml =
    #|{1: a, "1": b, 1.0: c}
  let expected : Array[@yaml.Yaml] = [
    Mapping(
      Map([
        (Integer(1), String("a")),
        (String("1"), String("b")),
        (Float(1.0), String("c")),
      ]),
    ),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "spec/keys/block-collection-keys" {
  let in_yaml =
    #|? [1, 2]
    #|: seq
    #|? {a: b}
    #|: map
    #|[3, 4]: flow
    #|? - 5
    #|  - 6
    #|: block seq
    #|? x: y
    #|: block map
  let expected : Array[@yaml.Yaml] = [
    Mapping(
      Map([
        (Sequence([Integer(1), Integer(2)]), String("seq")),
        (Mapping(Map([(String("a"), String("b"))])), String("map")),
        (Sequence([Integer(3), Integer(4)]), String("flow")),
        (Sequence([Integer(5), Integer(6)]), String("block seq")),
        (Mapping(Map([(String("x"), String("y"))])), String("block map")),
      ]),
    ),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "spec/keys/flow-collection-keys" {
  let in_yaml =
    #|{[1, 2]: a, {k: v}: b, ? [3] : c, true: d, 1.5: e, ? : f}
  let expected : Array[@yaml.Yaml] = [
    Mapping(
      Map([
        (Sequence([Integer(1), Integer(2)]), String("a")),
        (Mapping(Map([(String("k"), String("v"))])), String("b")),
        (Sequence([Integer(3)]), String("c")),
        (Bool(true), String("d")),
        (Float(1.5), String("e")),
        (Null, String("f")),
      ]),
    ),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "spec/keys/mapping-equality-ignores-entry-order" {
  let in_yaml =
    #|b: 2
    #|a: 1
  let expected : Array[@yaml.Yaml] = [
    Mapping(Map([(String("a"), Integer(1)), (String("b"), Integer(2))])),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "spec/keys/nan-keys-are-equal" {
  let in_yaml =
    #|.nan: a
    #|.NaN: b
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "spec/tags/explicit-core-tags-on-any-style" {
  let in_yaml =
    #|- !!str 12
    #|- !!int "12"
    #|- !!float 1
    #|- !!float '1e3'
    #|- !!bool "TRUE"
    #|- !!null ""
    #|- !!null ~
    #|- !!str
    #|- !!int 0o17
    #|- !!int 0x1F
    #|- !!int -12
    #|- !!float .inf
    #|- !!float -.INF
  let expected : Array[@yaml.Yaml] = [
    Sequence([
      String("12"),
      Integer(12),
      Float(1.0),
      Float(1000.0),
      Bool(true),
      Null,
      Null,
      String(""),
      Integer(15),
      Integer(31),
      Integer(-12),
      Float(@double.infinity),
      Float(@double.neg_infinity),
    ]),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "spec/tags/float-invalid-signed-nan" {
  let in_yaml =
    #|!!float -.nan
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "spec/tags/int-invalid-content" {
  let in_yaml =
    #|!!int abc
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "spec/tags/int-invalid-float-content" {
  let in_yaml =
    #|!!int 1.5
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "spec/tags/float-invalid-content" {
  let in_yaml =
    #|!!float 1_000
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "spec/tags/null-invalid-content" {
  let in_yaml =
    #|!!null x
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "spec/tags/str-on-sequence" {
  let in_yaml =
    #|!!str [a]
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "spec/tags/str-on-mapping" {
  let in_yaml =
    #|!!str {a: b}
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "spec/tags/int-on-mapping" {
  let in_yaml =
    #|!!int {a: b}
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "spec/tags/float-on-sequence" {
  let in_yaml =
    #|!!float [1]
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "spec/tags/bool-on-sequence" {
  let in_yaml =
    #|!!bool [true]
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "spec/tags/null-on-mapping" {
  let in_yaml =
    #|!!null {}
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "spec/tags/seq-on-mapping" {
  let in_yaml =
    #|!!seq {a: b}
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "spec/tags/map-on-sequence" {
  let in_yaml =
    #|!!map [a]
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "spec/tags/map-on-scalar" {
  let in_yaml =
    #|!!map a
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "spec/tags/seq-on-scalar" {
  let in_yaml =
    #|--- !!seq
    #|scalar
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "spec/tags/verbatim-core-tags" {
  let in_yaml =
    #|- !<tag:yaml.org,2002:str> 12
    #|- !<tag:yaml.org,2002:int> "7"
    #|- !<tag:yaml.org,2002:float> 2
    #|- !<tag:yaml.org,2002:bool> true
    #|- !<tag:yaml.org,2002:null> null
  let expected : Array[@yaml.Yaml] = [
    Sequence([String("12"), Integer(7), Float(2.0), Bool(true), Null]),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "spec/tags/verbatim-core-tag-invalid-content" {
  let in_yaml =
    #|!<tag:yaml.org,2002:int> x
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "spec/tags/named-handle-expands-to-core" {
  let in_yaml =
    #|%TAG !y! tag:yaml.org,2002:
    #|---
    #|- !y!str 12
    #|- !y!int "7"
  let expected : Array[@yaml.Yaml] = [Sequence([String("12"), Integer(7)])]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "spec/tags/named-handle-expands-to-core-invalid-content" {
  let in_yaml =
    #|%TAG !y! tag:yaml.org,2002:
    #|---
    #|!y!int x
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "spec/tags/undeclared-named-handle" {
  let in_yaml =
    #|!e!foo bar
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "spec/tags/primary-handle-remapped-to-core" {
  let in_yaml =
    #|%TAG ! tag:yaml.org,2002:
    #|---
    #|- !str 12
    #|- !int "3"
  let expected : Array[@yaml.Yaml] = [Sequence([String("12"), Integer(3)])]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "spec/tags/secondary-handle-remapped-away-from-core" {
  let in_yaml =
    #|%TAG !! tag:example.com,2000:app/
    #|---
    #|- !!int 12
    #|- !!str x
  let expected : Array[@yaml.Yaml] = [Sequence([String("12"), String("x")])]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "spec/tags/tag-directive-scopes-to-one-document" {
  let in_yaml =
    #|%TAG !e! tag:a,2000:
    #|--- !e!x 1
    #|...
    #|%TAG !e! tag:b,2000:
    #|--- !e!x 2
  let expected : Array[@yaml.Yaml] = [String("1"), String("2")]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "spec/tags/tag-directive-not-carried-after-document-end" {
  let in_yaml =
    #|%TAG !e! tag:a,2000:
    #|--- !e!x 1
    #|...
    #|--- !e!x 2
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "spec/tags/repeated-tag-directive-same-handle" {
  let in_yaml =
    #|%TAG ! !foo
    #|%TAG ! !foo
    #|---
    #|bar
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "spec/aliases/most-recent-preceding-anchor" {
  let in_yaml =
    #|- &a 1
    #|- *a
    #|- &a 2
    #|- *a
  let expected : Array[@yaml.Yaml] = [
    Sequence([Integer(1), Integer(1), Integer(2), Integer(2)]),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "spec/aliases/alias-copies-collection" {
  let in_yaml =
    #|a: &x [1, {b: 2}]
    #|c: *x
    #|*x : d
  let expected : Array[@yaml.Yaml] = [
    Mapping(
      Map([
        (
          String("a"),
          Sequence([Integer(1), Mapping(Map([(String("b"), Integer(2))]))]),
        ),
        (
          String("c"),
          Sequence([Integer(1), Mapping(Map([(String("b"), Integer(2))]))]),
        ),
        (
          Sequence([Integer(1), Mapping(Map([(String("b"), Integer(2))]))]),
          String("d"),
        ),
      ]),
    ),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "spec/aliases/alias-keeps-resolved-type" {
  let in_yaml =
    #|- &n 12
    #|- !!str *n
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "spec/aliases/undefined-alias" {
  let in_yaml =
    #|- *nope
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "spec/aliases/alias-before-anchor" {
  let in_yaml =
    #|- *a
    #|- &a 1
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "spec/aliases/anchors-do-not-cross-documents" {
  let in_yaml =
    #|--- &a x
    #|--- *a
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "spec/aliases/cycle-in-sequence" {
  let in_yaml =
    #|&a [*a]
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "spec/aliases/cycle-through-key" {
  let in_yaml =
    #|&k {*k : 1}
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "spec/aliases/same-anchor-nested-is-not-a-cycle" {
  let in_yaml =
    #|- &a [&a 1, *a]
    #|- *a
  let expected : Array[@yaml.Yaml] = [
    Sequence([
      Sequence([Integer(1), Integer(1)]),
      // The inner &a is the latest anchor event even after the outer
      // sequence closes (YAML 1.2.2 section 3.2.2.2).
      Integer(1),
    ]),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "spec/directives/yaml-1.1-processed-as-1.2" {
  let in_yaml =
    #|%YAML 1.1
    #|---
    #|- yes
    #|- 1_000
    #|- 0o17
  let expected : Array[@yaml.Yaml] = [
    Sequence([String("yes"), String("1_000"), Integer(15)]),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "spec/directives/yaml-malformed-version" {
  let in_yaml =
    #|%YAML 1
    #|---
    #|foo
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "spec/directives/repeated-yaml-directive" {
  let in_yaml =
    #|%YAML 1.2
    #|%YAML 1.2
    #|---
    #|foo
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "spec/directives/reserved-directive-ignored" {
  let in_yaml =
    #|%FOO bar baz
    #|---
    #|x
  let expected : Array[@yaml.Yaml] = [String("x")]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "spec/directives/directive-needs-document-start" {
  let in_yaml =
    #|%YAML 1.2
    #|foo
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "spec/directives/directive-needs-document-end-before-it" {
  let in_yaml =
    #|a: b
    #|%YAML 1.2
    #|---
    #|bar
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "spec/directives/percent-line-continues-plain-scalar" {
  let in_yaml =
    #|foo
    #|%YAML 1.2
    #|---
    #|bar
  let expected : Array[@yaml.Yaml] = [String("foo %YAML 1.2"), String("bar")]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "spec/directives/directive-after-document-end" {
  let in_yaml =
    #|foo
    #|...
    #|%YAML 1.2
    #|---
    #|bar
  let expected : Array[@yaml.Yaml] = [String("foo"), String("bar")]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "spec/line-breaks/cr-only" {
  let in_yaml = "a: 1\rb: 2\r"
  let expected : Array[@yaml.Yaml] = [
    Mapping(Map([(String("a"), Integer(1)), (String("b"), Integer(2))])),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "spec/line-breaks/crlf" {
  let in_yaml = "a: 1\r\nb: 2\r\n"
  let expected : Array[@yaml.Yaml] = [
    Mapping(Map([(String("a"), Integer(1)), (String("b"), Integer(2))])),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "spec/line-breaks/cr-in-block-scalar" {
  let in_yaml = "a: |\r  x\r  y\r"
  let expected : Array[@yaml.Yaml] = [
    Mapping(Map([(String("a"), String("x\ny\n"))])),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "spec/encoding/bom-at-stream-start" {
  let in_yaml = "\u{FEFF}a: 1\n"
  let expected : Array[@yaml.Yaml] = [Mapping(Map([(String("a"), Integer(1))]))]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "spec/encoding/bom-at-document-start" {
  let in_yaml = "\u{FEFF}a: 1\n...\n\u{FEFF}b: 2\n"
  let expected : Array[@yaml.Yaml] = [
    Mapping(Map([(String("a"), Integer(1))])),
    Mapping(Map([(String("b"), Integer(2))])),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "spec/encoding/bom-inside-quoted-scalar" {
  let in_yaml = "a: \"x\u{FEFF}y\"\n"
  let expected : Array[@yaml.Yaml] = [
    Mapping(Map([(String("a"), String("x\u{FEFF}y"))])),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "spec/encoding/bom-inside-plain-scalar" {
  let in_yaml = "a: x\u{FEFF}y\n"
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "spec/encoding/bom-inside-document" {
  let in_yaml = "a: 1\n\u{FEFF}b: 2\n"
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "spec/encoding/bom-inside-flow-scalar" {
  let in_yaml = "[x\u{FEFF}y]\n"
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "spec/encoding/nul-rejected" {
  let in_yaml = "a: b\u{0}\n"
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "spec/encoding/del-rejected" {
  let in_yaml = "a: x\u{7F}y\n"
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "spec/encoding/c1-control-rejected" {
  let in_yaml = "- x\u{9F}y\n"
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "spec/encoding/noncharacter-rejected" {
  let in_yaml =
    #|- ￿
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "spec/encoding/c0-control-rejected-in-quoted" {
  let in_yaml = "- '\u{2}'\n"
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "spec/encoding/non-c0-allowed-in-quoted" {
  let in_yaml = "- \"\u{7F}\u{9F}￿\"\n- '\u{80}'\n"
  let expected : Array[@yaml.Yaml] = [
    Sequence([String("\u{7F}\u{9F}\u{FFFF}"), String("\u{80}")]),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "spec/encoding/escaped-controls-accepted" {
  let in_yaml =
    #|- "a\x01b\x7f\u009F"
  let expected : Array[@yaml.Yaml] = [Sequence([String("a\u{1}b\u{7F}\u{9F}")])]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "spec/escapes/all-double-quoted-escapes" {
  let in_yaml =
    #|- "\0\a\b\t\	\n\v\f\r\e\ \"\/\\\N\_\L\P\x41\u0042\U00000043\U0001F600"
  let expected : Array[@yaml.Yaml] = [
    Sequence([
      String(
        "\u{0}\u{7}\u{8}\t\t\n\u{B}\u{C}\r\u{1B} \"/\\\u{85}\u{A0}\u{2028}\u{2029}ABC😀",
      ),
    ]),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "spec/escapes/unknown-escape-rejected" {
  let in_yaml =
    #|"\q"
  @test.assert_raise(() => @yaml.parse(in_yaml))
}

///|
test "spec/escapes/single-quoted-has-no-escapes" {
  let in_yaml =
    #|'a\n''b'
  let expected : Array[@yaml.Yaml] = [String("a\\n'b")]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "spec/encoding/printable-non-ascii-accepted" {
  let in_yaml = "a: \"x\u{85}y z😀\u{2028}\"\n"
  let expected : Array[@yaml.Yaml] = [
    Mapping(Map([(String("a"), String("x\u{85}y\u{A0}z😀\u{2028}"))])),
  ]
  assert_eq(@yaml.parse(in_yaml), expected)
}

///|
test "parse/stringview-window" {
  let text = "%YAML 9.9\n---\nx: 1\n"
  let window = text[14:]
  let expected : Array[@yaml.Yaml] = [Mapping(Map([(String("x"), Integer(1))]))]
  assert_eq(@yaml.parse(window), expected)
}

///|
test "print/empty-stream" {
  let docs : Array[@yaml.Yaml] = []
  assert_eq(@yaml.parse(@yaml.print(docs)), docs)
}

///|
test "print/roundtrip-numbers" {
  let docs : Array[@yaml.Yaml] = [
    Sequence([
      Integer(0),
      Integer(-1),
      Integer(9223372036854775807),
      Integer(-9223372036854775808),
      Integer(18446744073709551616N),
      Integer(-340282366920938463463374607431768211456N),
      Float(0.0),
      Float(-0.0),
      Float(1.5),
      Float(-2.25),
      Float(1.0e21),
      Float(1.0e-7),
      Float(5.0e-324),
      Float(1.7976931348623157e308),
      Float(3.0e14),
      Float(6.626e-34),
      Float(9007199254740993.0),
      Float(@double.infinity),
      Float(@double.neg_infinity),
      Float(@double.not_a_number),
      Float(100.0),
      Float(1.0e16),
    ]),
  ]
  assert_eq(@yaml.parse(@yaml.print(docs)), docs)
}

///|
test "print/roundtrip-keys" {
  let docs : Array[@yaml.Yaml] = [
    Mapping(
      Map([
        (Null, Integer(1)),
        (Bool(true), Integer(2)),
        (Bool(false), Integer(3)),
        (Integer(7), Integer(4)),
        (Float(1.5), Integer(5)),
        (Float(@double.not_a_number), Integer(6)),
        (Sequence([Integer(1), String("x")]), Integer(7)),
        (Mapping(Map([(String("k"), Null)])), Integer(8)),
        (Sequence([]), Integer(9)),
        (Mapping(Map([])), Integer(10)),
        (String("1"), Integer(11)),
        (Integer(1), Integer(12)),
        (Float(1.0), Integer(13)),
      ]),
    ),
  ]
  assert_eq(@yaml.parse(@yaml.print(docs)), docs)
}

///|
test "print/roundtrip-multi-document" {
  let docs : Array[@yaml.Yaml] = [
    Null,
    Sequence([]),
    Mapping(Map([])),
    String(""),
    String("---"),
    String("..."),
    Sequence([
      Null,
      Sequence([Sequence([])]),
      Mapping(
        Map([
          (String("a"), Mapping(Map([(String("b"), Sequence([Integer(1)]))]))),
        ]),
      ),
    ]),
    Bool(false),
  ]
  assert_eq(@yaml.parse(@yaml.print(docs)), docs)
}
