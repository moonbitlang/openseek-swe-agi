///|
test "w3c/not-wf/not_wf_sa_001" {
  let xml_text =
    #|<doc>
    #|<doc
    #|?
    #|<a</a>
    #|</doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_002" {
  let xml_text =
    #|<doc>
    #|<.doc></.doc>
    #|</doc>
    #|
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_003" {
  let xml_text =
    #|<doc><? ?></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_004" {
  let xml_text =
    #|<doc><?target some data></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_005" {
  let xml_text =
    #|<doc><?target some data?</doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_006" {
  let xml_text =
    #|<doc><!-- a comment -- another --></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_007" {
  let xml_text =
    #|<doc>&amp no refc</doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_008" {
  let xml_text =
    #|<doc>&.entity;</doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_009" {
  let xml_text =
    #|<doc>&#RE;</doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_010" {
  let xml_text =
    #|<doc>A & B</doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_011" {
  let xml_text =
    #|<doc a1></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_012" {
  let xml_text =
    #|<doc a1=v1></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_013" {
  let xml_text =
    #|<doc a1="v1'></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_014" {
  let xml_text =
    #|<doc a1="<foo>"></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_015" {
  let xml_text =
    #|<doc a1=></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_016" {
  let xml_text =
    #|<doc a1="v1" "v2"></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_017" {
  let xml_text =
    #|<doc><![CDATA[</doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_018" {
  let xml_text =
    #|<doc><![CDATA [ stuff]]></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_019" {
  let xml_text =
    #|<doc></>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_020" {
  let xml_text =
    #|<doc a1="A & B"></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_021" {
  let xml_text =
    #|<doc a1="a&b"></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_022" {
  let xml_text =
    #|<doc a1="&#123:"></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_023" {
  let xml_text =
    #|<doc 12="34"></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_024" {
  let xml_text =
    #|<doc>
    #|<123></123>
    #|</doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_025" {
  let xml_text =
    #|<doc>]]></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_026" {
  let xml_text =
    #|<doc>]]]></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_027" {
  let xml_text =
    #|<doc>
    #|<!-- abc
    #|</doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_028" {
  let xml_text =
    #|<doc>
    #|<?a pi that is not closed
    #|</doc>
    #|
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/valid/valid_sa_001" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|]>
    #|<doc></doc>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("doc"),
    Start(name="doc", attributes=Map([])),
    End("doc"),
  ])
}

///|
test "w3c/valid/valid_sa_002" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|]>
    #|<doc ></doc>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("doc"),
    Start(name="doc", attributes=Map([])),
    End("doc"),
  ])
}

///|
test "w3c/valid/valid_sa_003" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|]>
    #|<doc></doc >
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("doc"),
    Start(name="doc", attributes=Map([])),
    End("doc"),
  ])
}

///|
test "w3c/valid/valid_sa_004" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|<!ATTLIST doc a1 CDATA #IMPLIED>
    #|]>
    #|<doc a1="v1"></doc>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("doc"),
    Start(name="doc", attributes={ "a1": "v1" }),
    End("doc"),
  ])
}

///|
test "w3c/valid/valid_sa_005" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|<!ATTLIST doc a1 CDATA #IMPLIED>
    #|]>
    #|<doc a1 = "v1"></doc>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("doc"),
    Start(name="doc", attributes={ "a1": "v1" }),
    End("doc"),
  ])
}

///|
test "w3c/valid/valid_sa_006" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|<!ATTLIST doc a1 CDATA #IMPLIED>
    #|]>
    #|<doc a1='v1'></doc>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("doc"),
    Start(name="doc", attributes={ "a1": "v1" }),
    End("doc"),
  ])
}

///|
test "w3c/valid/valid_sa_007" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|]>
    #|<doc>&#32;</doc>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("doc"),
    Start(name="doc", attributes=Map([])),
    Text(" "),
    End("doc"),
  ])
}

///|
test "w3c/valid/valid_sa_008" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|]>
    #|<doc>&amp;&lt;&gt;&quot;&apos;</doc>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("doc"),
    Start(name="doc", attributes=Map([])),
    Text("&<>\"'"),
    End("doc"),
  ])
}

///|
test "w3c/valid/valid_sa_009" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|]>
    #|<doc>&#x20;</doc>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("doc"),
    Start(name="doc", attributes=Map([])),
    Text(" "),
    End("doc"),
  ])
}

///|
test "w3c/valid/valid_sa_010" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|<!ATTLIST doc a1 CDATA #IMPLIED>
    #|]>
    #|<doc a1="v1" ></doc>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("doc"),
    Start(name="doc", attributes={ "a1": "v1" }),
    End("doc"),
  ])
}

///|
test "w3c/valid/valid_sa_011" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|<!ATTLIST doc a1 CDATA #IMPLIED a2 CDATA #IMPLIED>
    #|]>
    #|<doc a1="v1" a2="v2"></doc>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("doc"),
    Start(name="doc", attributes={ "a1": "v1", "a2": "v2" }),
    End("doc"),
  ])
}

///|
test "w3c/valid/valid_sa_012" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|<!ATTLIST doc : CDATA #IMPLIED>
    #|]>
    #|<doc :="v1"></doc>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("doc"),
    Start(name="doc", attributes={ ":": "v1" }),
    End("doc"),
  ])
}

///|
test "w3c/valid/valid_sa_013" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|<!ATTLIST doc _.-0123456789 CDATA #IMPLIED>
    #|]>
    #|<doc _.-0123456789="v1"></doc>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("doc"),
    Start(name="doc", attributes={ "_.-0123456789": "v1" }),
    End("doc"),
  ])
}

///|
test "w3c/valid/valid_sa_014" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|<!ATTLIST doc abcdefghijklmnopqrstuvwxyz CDATA #IMPLIED>
    #|]>
    #|<doc abcdefghijklmnopqrstuvwxyz="v1"></doc>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("doc"),
    Start(name="doc", attributes={ "abcdefghijklmnopqrstuvwxyz": "v1" }),
    End("doc"),
  ])
}

///|
test "w3c/valid/valid_sa_015" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|<!ATTLIST doc ABCDEFGHIJKLMNOPQRSTUVWXYZ CDATA #IMPLIED>
    #|]>
    #|<doc ABCDEFGHIJKLMNOPQRSTUVWXYZ="v1"></doc>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("doc"),
    Start(name="doc", attributes={ "ABCDEFGHIJKLMNOPQRSTUVWXYZ": "v1" }),
    End("doc"),
  ])
}

///|
test "w3c/valid/valid_sa_016" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|]>
    #|<doc><?pi?></doc>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("doc"),
    Start(name="doc", attributes=Map([])),
    PI(target="pi", data=""),
    End("doc"),
  ])
}

///|
test "w3c/valid/valid_sa_017" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|]>
    #|<doc><?pi some data ?><?x?></doc>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("doc"),
    Start(name="doc", attributes=Map([])),
    PI(target="pi", data="some data "),
    PI(target="x", data=""),
    End("doc"),
  ])
}

///|
test "w3c/valid/valid_sa_018" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|]>
    #|<doc><![CDATA[<foo>]]></doc>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("doc"),
    Start(name="doc", attributes=Map([])),
    Text("<foo>"),
    End("doc"),
  ])
}

///|
test "w3c/valid/valid_sa_019" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|]>
    #|<doc><![CDATA[<&]]></doc>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("doc"),
    Start(name="doc", attributes=Map([])),
    Text("<&"),
    End("doc"),
  ])
}

///|
test "w3c/valid/valid_sa_020" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|]>
    #|<doc><![CDATA[<&]>]]]></doc>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("doc"),
    Start(name="doc", attributes=Map([])),
    Text("<&]>]"),
    End("doc"),
  ])
}

///|
test "w3c/valid/valid_sa_021" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|]>
    #|<doc><!-- a comment --></doc>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("doc"),
    Start(name="doc", attributes=Map([])),
    Comment(" a comment "),
    End("doc"),
  ])
}

///|
test "w3c/valid/valid_sa_022" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|]>
    #|<doc><!-- a comment ->--></doc>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("doc"),
    Start(name="doc", attributes=Map([])),
    Comment(" a comment ->"),
    End("doc"),
  ])
}

///|
test "w3c/valid/valid_sa_023" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|<!ENTITY e "">
    #|]>
    #|<doc>&e;</doc>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("doc"),
    Start(name="doc", attributes=Map([])),
    End("doc"),
  ])
}

///|
test "w3c/valid/valid_sa_024" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (foo)>
    #|<!ELEMENT foo (#PCDATA)>
    #|<!ENTITY e "&#60;foo></foo>">
    #|]>
    #|<doc>&e;</doc>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("doc"),
    Start(name="doc", attributes=Map([])),
    Start(name="foo", attributes=Map([])),
    End("foo"),
    End("doc"),
  ])
}

///|
test "w3c/valid/valid_sa_025" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (foo*)>
    #|<!ELEMENT foo (#PCDATA)>
    #|]>
    #|<doc><foo/><foo></foo></doc>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("doc"),
    Start(name="doc", attributes=Map([])),
    Start(name="foo", attributes=Map([])),
    End("foo"),
    Start(name="foo", attributes=Map([])),
    End("foo"),
    End("doc"),
  ])
}

///|
test "w3c/valid/valid_sa_026" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (foo*)>
    #|<!ELEMENT foo EMPTY>
    #|]>
    #|<doc><foo/><foo></foo></doc>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("doc"),
    Start(name="doc", attributes=Map([])),
    Start(name="foo", attributes=Map([])),
    End("foo"),
    Start(name="foo", attributes=Map([])),
    End("foo"),
    End("doc"),
  ])
}

///|
test "w3c/valid/valid_sa_027" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (foo*)>
    #|<!ELEMENT foo ANY>
    #|]>
    #|<doc><foo/><foo></foo></doc>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("doc"),
    Start(name="doc", attributes=Map([])),
    Start(name="foo", attributes=Map([])),
    End("foo"),
    Start(name="foo", attributes=Map([])),
    End("foo"),
    End("doc"),
  ])
}

///|
test "w3c/valid/valid_sa_028" {
  let xml_text =
    #|<?xml version="1.0"?>
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|]>
    #|<doc></doc>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    Decl(version="1.0", encoding=None, standalone=None),
    DocType("doc"),
    Start(name="doc", attributes=Map([])),
    End("doc"),
  ])
}

///|
test "w3c/valid/valid_sa_029" {
  let xml_text =
    #|<?xml version='1.0'?>
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|]>
    #|<doc></doc>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    Decl(version="1.0", encoding=None, standalone=None),
    DocType("doc"),
    Start(name="doc", attributes=Map([])),
    End("doc"),
  ])
}

///|
test "w3c/valid/valid_sa_030" {
  let xml_text =
    #|<?xml version = "1.0"?>
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|]>
    #|<doc></doc>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    Decl(version="1.0", encoding=None, standalone=None),
    DocType("doc"),
    Start(name="doc", attributes=Map([])),
    End("doc"),
  ])
}

///|
test "w3c/valid/valid_sa_031" {
  let xml_text =
    #|<?xml version='1.0' encoding="UTF-8"?>
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|]>
    #|<doc></doc>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    Decl(version="1.0", encoding=Some("UTF-8"), standalone=None),
    DocType("doc"),
    Start(name="doc", attributes=Map([])),
    End("doc"),
  ])
}

///|
test "w3c/valid/valid_sa_032" {
  let xml_text =
    #|<?xml version='1.0' standalone='yes'?>
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|]>
    #|<doc></doc>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    Decl(version="1.0", encoding=None, standalone=Some(true)),
    DocType("doc"),
    Start(name="doc", attributes=Map([])),
    End("doc"),
  ])
}

///|
test "w3c/valid/valid_sa_033" {
  let xml_text =
    #|<?xml version='1.0' encoding="UTF-8" standalone='yes'?>
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|]>
    #|<doc></doc>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    Decl(version="1.0", encoding=Some("UTF-8"), standalone=Some(true)),
    DocType("doc"),
    Start(name="doc", attributes=Map([])),
    End("doc"),
  ])
}

///|
test "w3c/valid/valid_sa_034" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|]>
    #|<doc/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("doc"),
    Start(name="doc", attributes=Map([])),
    End("doc"),
  ])
}

///|
test "w3c/valid/valid_sa_035" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|]>
    #|<doc />
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("doc"),
    Start(name="doc", attributes=Map([])),
    End("doc"),
  ])
}

///|
test "w3c/valid/valid_sa_036" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|]>
    #|<doc></doc>
    #|<?pi data?>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("doc"),
    Start(name="doc", attributes=Map([])),
    End("doc"),
    PI(target="pi", data="data"),
  ])
}

///|
test "w3c/valid/valid_sa_017a" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|]>
    #|<doc><?pi some data ? > <??></doc>
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("doc"),
    Start(name="doc", attributes=Map([])),
    PI(target="pi", data="some data ? > <?"),
    End("doc"),
  ])
}

///|
test "w3c/valid/valid_sa_037" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|]>
    #|<doc></doc>
    #|<!-- comment -->
    #|
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("doc"),
    Start(name="doc", attributes=Map([])),
    End("doc"),
    Comment(" comment "),
  ])
}

///|
test "w3c/valid/valid_sa_038" {
  let xml_text =
    #|<!-- comment -->
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|]>
    #|<doc></doc>
    #|
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    Comment(" comment "),
    DocType("doc"),
    Start(name="doc", attributes=Map([])),
    End("doc"),
  ])
}

///|
test "w3c/valid/valid_sa_039" {
  let xml_text =
    #|<?pi data?>
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|]>
    #|<doc></doc>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    PI(target="pi", data="data"),
    DocType("doc"),
    Start(name="doc", attributes=Map([])),
    End("doc"),
  ])
}

///|
test "w3c/valid/valid_sa_040" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|<!ATTLIST doc a1 CDATA #IMPLIED>
    #|]>
    #|<doc a1="&quot;&lt;&amp;&gt;&apos;"></doc>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("doc"),
    Start(name="doc", attributes={ "a1": "\"<&>'" }),
    End("doc"),
  ])
}

///|
test "w3c/valid/valid_sa_041" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|<!ATTLIST doc a1 CDATA #IMPLIED>
    #|]>
    #|<doc a1="&#65;"></doc>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("doc"),
    Start(name="doc", attributes={ "a1": "A" }),
    End("doc"),
  ])
}

///|
test "w3c/valid/valid_sa_042" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|]>
    #|<doc>&#00000000000000000000000000000000065;</doc>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("doc"),
    Start(name="doc", attributes=Map([])),
    Text("A"),
    End("doc"),
  ])
}

///|
test "w3c/valid/valid_sa_043" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ATTLIST doc a1 CDATA #IMPLIED>
    #|<!ELEMENT doc (#PCDATA)>
    #|]>
    #|<doc a1="foo
    #|bar"></doc>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("doc"),
    Start(name="doc", attributes={ "a1": "foo bar" }),
    End("doc"),
  ])
}

///|
test "w3c/valid/valid_sa_044" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (e*)>
    #|<!ELEMENT e EMPTY>
    #|<!ATTLIST e a1 CDATA "v1" a2 CDATA "v2" a3 CDATA #IMPLIED>
    #|]>
    #|<doc>
    #|<e a3="v3"/>
    #|<e a1="w1"/>
    #|<e a2="w2" a3="v3"/>
    #|</doc>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("doc"),
    Start(name="doc", attributes=Map([])),
    Text("\n"),
    Start(name="e", attributes={ "a3": "v3", "a1": "v1", "a2": "v2" }),
    End("e"),
    Text("\n"),
    Start(name="e", attributes={ "a1": "w1", "a2": "v2" }),
    End("e"),
    Text("\n"),
    Start(name="e", attributes={ "a2": "w2", "a3": "v3", "a1": "v1" }),
    End("e"),
    Text("\n"),
    End("doc"),
  ])
}

///|
test "parse/line-ends/crlf-normalized" {
  // Section 2.11: CRLF and lone CR are normalized to LF on input, in text, attribute values and comments alike.
  let xml_text = "<!--k\r\nl--><a b=\"x\ry\">m\r\nn\ro</a>"
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    Comment("k\nl"),
    Start(name="a", attributes={ "b": "x y" }),
    Text("m\nn\no"),
    End("a"),
  ])
}

///|
test "parse/entity/external-subset-undeclared-entity" {
  // Section 4.1: with an external subset the parser does not read, an undeclared entity in content is not a well-formedness error unless standalone='yes'; it is reported as an unexpanded EntityRef.
  let xml_text =
    #|<!DOCTYPE d SYSTEM "d.dtd"><d>a&u;b</d>
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("d"),
    Start(name="d", attributes=Map([])),
    Text("a"),
    EntityRef("u"),
    Text("b"),
    End("d"),
  ])
}

///|
test "print/escape-roundtrip" {
  // Character data and attribute values containing markup characters, quotes and white space must survive printing.
  let events : Array[@xml.Event] = [
    Start(name="a", attributes={ "b": "<&\"'\t\n\r>" }),
    Text("<&>\"']]>\r\n"),
    End("a"),
  ]
  assert_eq(@xml.parse(@xml.print(events)), events)
}

///|
test "quickcheck: roundtrips" {
  @quickcheck.check(
    (doc : QcDoc) => @xml.parse(@xml.print(doc.0)) == doc.0,
    count=300,
  )
}

///|
test "quickcheck: parse should never panic" {
  @quickcheck.check((s : String) => {
    try @xml.parse(s) catch {
      _ => true
    } noraise {
      _ => true
    }
  })
}

///|
test "spec/dtd/percent-in-attribute-default-is-literal" {
  // AttValue does not recognize parameter entities, unlike EntityValue.
  let xml_text =
    #|<!DOCTYPE doc [<!ATTLIST doc a1 CDATA "%e;">]><doc/>
  assert_eq(@xml.parse(xml_text), [
    DocType("doc"),
    Start(name="doc", attributes={ "a1": "%e;" }),
    End("doc"),
  ])
}

///|
test "spec/dtd/parameter-reference-in-entity-value-is-forbidden" {
  // XML 1.0 section 2.8 forbids PE references inside internal-subset
  // declarations, even inside the EntityValue's quotation marks.
  let xml_text =
    #|<!DOCTYPE doc [<!ENTITY % e "value"><!ENTITY text "%e;">]><doc/>
  @test.assert_raise(() => @xml.parse(xml_text))
}
