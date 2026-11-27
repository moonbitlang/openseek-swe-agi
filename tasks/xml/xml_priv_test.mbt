///|
test "w3c/not-wf/not_wf_sa_029" {
  let xml_text =
    #|<doc>abc]]]>def</doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_030" {
  let xml_text = "<doc>A form feed (\u{0C}) is not legal in data</doc>\n"
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_031" {
  let xml_text = "<doc><?pi a form feed (\u{0C}) is not allowed in a pi?></doc>\n"
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_032" {
  let xml_text = "<doc><!-- a form feed (\u{0C}) is not allowed in a comment --></doc>\n"
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_033" {
  let xml_text = "<doc>abc\u{1B}def</doc>\n"
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_034" {
  let xml_text = "<doc\u{0C}>A form-feed is not white space or a name character</doc\u{0C}>\n"
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_035" {
  let xml_text =
    #|<doc>1 < 2 but not in XML</doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_036" {
  let xml_text =
    #|<doc></doc>
    #|Illegal data
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_037" {
  let xml_text =
    #|<doc></doc>
    #|&#32;
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_038" {
  let xml_text =
    #|<doc x="foo" y="bar" x="baz"></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_039" {
  let xml_text =
    #|<doc><a></aa></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_040" {
  let xml_text =
    #|<doc></doc>
    #|<doc></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_041" {
  let xml_text =
    #|<doc/>
    #|<doc></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_042" {
  let xml_text =
    #|<doc/></doc/>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_043" {
  let xml_text =
    #|<doc/>
    #|Illegal data
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_044" {
  let xml_text =
    #|<doc/><doc/>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_045" {
  let xml_text =
    #|<doc>
    #|<a/
    #|</doc>
    #|
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_046" {
  let xml_text =
    #|<doc>
    #|<a/</a>
    #|</doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_047" {
  let xml_text =
    #|<doc>
    #|<a / >
    #|</doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_048" {
  let xml_text =
    #|<doc>
    #|</doc>
    #|<![CDATA[]]>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_049" {
  let xml_text =
    #|<doc>
    #|<a><![CDATA[xyz]]]></a>
    #|<![CDATA[]]></a>
    #|</doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_050" {
  let xml_text =
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_051" {
  let xml_text =
    #|<!-- a comment -->
    #|<![CDATA[]]>
    #|<doc></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_052" {
  let xml_text =
    #|<!-- a comment -->
    #|&#32;
    #|<doc></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_053" {
  let xml_text =
    #|<doc></DOC>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_055" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<doc></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_056" {
  let xml_text =
    #|<!DOCTYPE doc -- a comment -- []>
    #|<doc></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_057" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ENTITY e "whatever" -- a comment -->
    #|]>
    #|<doc></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_058" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|<!ATTLIST doc a1 (foo,bar) #IMPLIED>
    #|]>
    #|<doc></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_059" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|<!ATTLIST doc a1 NMTOKEN v1>
    #|]>
    #|<doc></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_060" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|<!ATTLIST doc a1 NAME #IMPLIED>
    #|]>
    #|<doc></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_062" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ENTITY foo"some text">
    #|]>
    #|<doc></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_063" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<![INCLUDE[ ]]>
    #|]>
    #|<doc></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_064" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|<!ATTLIST e a1 CDATA"foo">
    #|]>
    #|<doc></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_065" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|<!ATTLIST doc a1(foo|bar) #IMPLIED>
    #|]>
    #|<doc></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_066" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|<!ATTLIST doc a1 (foo|bar)#IMPLIED>
    #|]>
    #|<doc></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_067" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|<!ATTLIST doc a1 (foo)"foo">
    #|]>
    #|<doc></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_068" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|<!ATTLIST doc a1 NOTATION(foo) #IMPLIED>
    #|]>
    #|<doc></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_070" {
  let xml_text =
    #|<!-- a comment ending with three dashes --->
    #|<doc></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_071" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ENTITY e1 "&e2;">
    #|<!ENTITY e2 "&e3;">
    #|<!ENTITY e3 "&e1;">
    #|]>
    #|<doc>&e1;</doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_072" {
  let xml_text =
    #|<doc>&foo;</doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_073" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ENTITY e "whatever">
    #|]>
    #|<doc>&f;</doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_074" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ENTITY e "</foo><foo>">
    #|]>
    #|<doc>
    #|<foo>&e;</foo>
    #|</doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_075" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ENTITY e1 "&e2;">
    #|<!ENTITY e2 "&e3;">
    #|<!ENTITY e3 "&e1;">
    #|]>
    #|<doc a="&e1;"></doc>
    #|
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_076" {
  let xml_text =
    #|<doc a="&foo;"></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_077" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ENTITY foo "&bar;">
    #|]>
    #|<doc a="&foo;"></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_078" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|<!ATTLIST doc a CDATA "&foo;">
    #|]>
    #|<doc></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_079" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ENTITY e1 "&e2;">
    #|<!ENTITY e2 "&e3;">
    #|<!ENTITY e3 "&e1;">
    #|<!ELEMENT doc (#PCDATA)>
    #|<!ATTLIST doc a CDATA "&e1;">
    #|]>
    #|<doc></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_080" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ENTITY e1 "&e2;">
    #|<!ENTITY e2 "&e3;">
    #|<!ENTITY e3 "&e1;">
    #|<!ELEMENT doc (#PCDATA)>
    #|<!ATTLIST doc a CDATA #FIXED "&e1;">
    #|]>
    #|<doc></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_085" {
  let xml_text =
    #|<!DOCTYPE doc PUBLIC "[" "null.ent">
    #|<doc></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_087" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!NOTATION foo PUBLIC "[" "null.ent">
    #|]>
    #|<doc></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_088" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|<!ATTLIST doc a CDATA #IMPLIED>
    #|<!ENTITY e '"'>
    #|]>
    #|<doc a="&e;></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_090" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ENTITY e "<foo a='&#60;'></foo>">
    #|]>
    #|<doc>&e;</doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_092" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ENTITY e "<foo a='&#38;'></foo>">
    #|]>
    #|<doc>&e;</doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_093" {
  let xml_text =
    #|<doc>&#X58;</doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_094" {
  let xml_text =
    #|<?xml VERSION="1.0"?>
    #|<doc></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_095" {
  let xml_text =
    #|<?xml encoding="UTF-8" version="1.0"?>
    #|<doc></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_096" {
  let xml_text =
    #|<?xml version="1.0"encoding="UTF-8" ?>
    #|<doc></doc>
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_097" {
  let xml_text =
    #|<?xml version="1.0' encoding="UTF-8" ?>
    #|<doc></doc>
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_098" {
  let xml_text =
    #|<?xml version="1.0" version="1.0"?>
    #|<doc></doc>
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_099" {
  let xml_text =
    #|<?xml version="1.0" valid="no" ?>
    #|<doc></doc>
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_100" {
  let xml_text =
    #|<?xml version="1.0" standalone="YES" ?>
    #|<doc></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_101" {
  let xml_text =
    #|<?xml version="1.0" encoding=" UTF-8"?>
    #|<doc></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_102" {
  let xml_text =
    #|<?xml version="1.0 " ?>
    #|<doc></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_103" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ENTITY e "&#60;foo>">
    #|]>
    #|<doc>&e;</doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_104" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ENTITY e "<foo>">
    #|]>
    #|<doc>&e;</foo></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_105" {
  let xml_text =
    #|<?pi stuff?>
    #|<![CDATA[]]>
    #|<doc>
    #|</doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_106" {
  let xml_text =
    #|<?pi data?>
    #|&#32;<doc></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_107" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<![CDATA[]]>
    #|]>
    #|<doc></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_108" {
  let xml_text =
    #|<doc>
    #|<![CDATA [  ]]>
    #|</doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_109" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ENTITY e "<doc></doc>">
    #|]>
    #|&e;
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_110" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ENTITY e "">
    #|]>
    #|<doc></doc>
    #|&e;
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_111" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ENTITY e "foo='bar'">
    #|]>
    #|<doc &e;></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_112" {
  let xml_text =
    #|<doc>
    #|<![cdata[data]]>
    #|</doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_113" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ENTITY % foo "&">
    #|]>
    #|<doc></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_114" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ENTITY foo "&">
    #|]>
    #|<doc></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_115" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ENTITY e "&#38;">
    #|]>
    #|<doc a="&e;"></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_116" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ENTITY e "&#38;#9">
    #|]>
    #|<doc>&e;7;</doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_117" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ENTITY e "&#38;">
    #|]>
    #|<doc>&e;#97;</doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_118" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ENTITY e "#">
    #|]>
    #|<doc>&&e;97;</doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_119" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ENTITY e "&#38;">
    #|]>
    #|<doc>
    #|&e;#38;
    #|</doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_120" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ENTITY e "&#38;">
    #|]>
    #|<doc>
    #|&e;
    #|</doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_121" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ENTITY #DEFAULT "default">
    #|]>
    #|<doc></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_122" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (a, (b) | c)?>
    #|]>
    #|<doc></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_123" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc ((doc?)))>
    #|]>
    #|<doc></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_124" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (doc|#PCDATA)*>
    #|]>
    #|<doc></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_125" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc ((#PCDATA))>
    #|]>
    #|<doc></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_126" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)+>
    #|]>
    #|<doc></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_127" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)?>
    #|]>
    #|<doc></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_128" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc CDATA>
    #|]>
    #|<doc></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_129" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc - - (#PCDATA)>
    #|]>
    #|<doc></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_130" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (doc?) +(foo)>
    #|]>
    #|<doc></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_131" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (doc?) -(foo)>
    #|]>
    #|<doc></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_132" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (a, (b, c), (d, (e, f) | g))?>
    #|]>
    #|<doc></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_133" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (a *)>
    #|]>
    #|<doc></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_134" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (a) *>
    #|]>
    #|<doc></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_135" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (a & b)?>
    #|]>
    #|<doc></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_136" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc O O (#PCDATA)>
    #|]>
    #|<doc></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_137" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc(#PCDATA)>
    #|]>
    #|<doc></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_138" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (doc*?)>
    #|]>
    #|<doc></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_139" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc ()>
    #|]>
    #|<doc></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_142" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|]>
    #|<doc>&#0;</doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_143" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|]>
    #|<doc>&#31;</doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_144" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|]>
    #|<doc>&#xFFFF;</doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_145" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|]>
    #|<doc>&#xD800;</doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_146" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|]>
    #|<doc>&#x110000;</doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_147" {
  let xml_text =
    #|
    #|<?xml version="1.0"?>
    #|<doc></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_148" {
  let xml_text =
    #|<!-- -->
    #|<?xml version="1.0"?>
    #|<doc></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_149" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|<?xml version="1.0"?>
    #|]>
    #|<doc></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_150" {
  let xml_text =
    #|<doc>
    #|<?xml version="1.0"?>
    #|</doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_151" {
  let xml_text =
    #|<doc>
    #|</doc>
    #|<?xml version="1.0"?>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_152" {
  let xml_text =
    #|<?xml encoding="UTF-8"?>
    #|<doc></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_153" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|<!ENTITY e "<?xml encoding='UTF-8'?>">
    #|]>
    #|<doc>&e;</doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_154" {
  let xml_text =
    #|<?XML version="1.0"?>
    #|<doc></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_155" {
  let xml_text =
    #|<?xmL version="1.0"?>
    #|<doc></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_156" {
  let xml_text =
    #|<doc>
    #|<?xMl version="1.0"?>
    #|</doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_157" {
  let xml_text =
    #|<doc>
    #|<?xmL?>
    #|</doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_158" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|<!NOTATION gif PUBLIC "image/gif" "">
    #|<!ATTLIST #NOTATION gif a1 CDATA #IMPLIED>
    #|]>
    #|<doc></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_159" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|<!ENTITY e "<![CDATA[Tim & Michael]]>">
    #|]>
    #|<doc>&e;</doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_160" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|<!ENTITY % e "">
    #|<!ENTITY foo "%e;">
    #|]>
    #|<doc></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_161" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ENTITY % e "#PCDATA">
    #|<!ELEMENT doc (%e;)>
    #|]>
    #|<doc></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_162" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|<!ENTITY % e1 "">
    #|<!ENTITY % e2 "%e1;">
    #|]>
    #|<doc></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_163" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|<!ENTITY % e "">
    #|]>
    #|%e;
    #|<doc></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_164" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|<!ENTITY % e "">
    #|] %e; >
    #|<doc></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_165" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ENTITY% e "">
    #|<!ELEMENT doc (#PCDATA)>
    #|]>
    #|<doc></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_166" {
  let xml_text =
    #|<doc>￿</doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_167" {
  let xml_text =
    #|<doc>￾</doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_171" {
  let xml_text =
    #|<!-- ￿ -->
    #|<doc></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_172" {
  let xml_text =
    #|<?pi ￿?>
    #|<doc></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_173" {
  let xml_text =
    #|<doc a="￿"></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_174" {
  let xml_text =
    #|<doc><![CDATA[￿]]></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_175" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|<!ENTITY % e "￿">
    #|]>
    #|<doc></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_176" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|]>
    #|<doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_177" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|]>
    #|<doc>A￿</doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_178" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|<!ATTLIST doc a CDATA #IMPLIED>
    #|]>
    #|<doc a="&#34;></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_179" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ENTITY e "&#34;>
    #|]>
    #|<doc></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_180" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|<!ATTLIST doc a CDATA "&e;">
    #|<!ENTITY e "v">
    #|]>
    #|<doc></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_181" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ENTITY e "&#60;![CDATA[">
    #|<!ELEMENT doc (#PCDATA)>
    #|]>
    #|<doc>&e;]]></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_182" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ENTITY e "&#60;!--">
    #|<!ELEMENT doc (#PCDATA)>
    #|]>
    #|<doc>&e;--></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_183" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA | foo*)* >
    #|<!ELEMENT foo EMPTY>
    #|]>
    #|<doc></doc>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_184" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA | (foo))* >
    #|<!ELEMENT foo EMPTY>
    #|]>
    #|<doc></doc>
    #|
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/not_wf_sa_186" {
  let xml_text =
    #|<!DOCTYPE a [
    #|<!ELEMENT a EMPTY>
    #|<!ATTLIST a b CDATA #IMPLIED d CDATA #IMPLIED>
    #|]>
    #|<a b="c"d="e"/>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/rmt_ns10_035" {
  let xml_text =
    #|<?xml version="1.0"?>
    #|<!-- Attribute uniqueness: repeated identical attribute -->
    #|<foo xmlns:a="http://example.org/~wilbur"
    #|     xmlns:b="http://example.org/~wilbur">
    #|
    #|<bar a:attr="1" a:attr="2"/>
    #|
    #|</foo>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/attlist01" {
  let xml_text =
    #|<!DOCTYPE root [
    #|    <!ELEMENT root EMPTY>
    #|
    #|    <!-- SGML-ism:  illegal attribute types -->
    #|
    #|    <!ATTLIST root
    #|	number	NUTOKEN	"1"
    #|	>
    #|
    #|]>
    #|
    #|<root/>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/attlist02" {
  let xml_text =
    #|<!DOCTYPE root [
    #|    <!ELEMENT root EMPTY>
    #|
    #|    <!-- SGML-ism:  illegal attribute types -->
    #|
    #|    <!ATTLIST root
    #|	number	NUTOKENS	"1 2 3"
    #|	>
    #|
    #|]>
    #|
    #|<root/>
    #|
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/attlist03" {
  let xml_text =
    #|<!DOCTYPE root [
    #|    <!ELEMENT root EMPTY>
    #|
    #|    <!-- SGML-ism:  illegal attribute types -->
    #|
    #|    <!ATTLIST root
    #|	choice	(a,b,c)	"a"
    #|	>
    #|
    #|]>
    #|
    #|<root/>
    #|
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/attlist04" {
  let xml_text =
    #|<!DOCTYPE root [
    #|    <!ELEMENT root EMPTY>
    #|
    #|    <!-- SGML-ism:  illegal attribute types -->
    #|
    #|    <!ATTLIST root
    #|	number	NUMBER	"1"
    #|	>
    #|
    #|]>
    #|
    #|<root/>
    #|
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/attlist05" {
  let xml_text =
    #|<!DOCTYPE root [
    #|    <!ELEMENT root EMPTY>
    #|
    #|    <!-- SGML-ism:  illegal attribute types -->
    #|
    #|    <!ATTLIST root
    #|	numbers	NUMBERS	"1 2 3 4"
    #|	>
    #|
    #|]>
    #|
    #|<root/>
    #|
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/attlist06" {
  let xml_text =
    #|<!DOCTYPE root [
    #|    <!ELEMENT root EMPTY>
    #|
    #|    <!-- SGML-ism:  illegal attribute types -->
    #|
    #|    <!ATTLIST root
    #|	number	NAME	"Elvis"
    #|	>
    #|
    #|]>
    #|
    #|<root/>
    #|
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/attlist07" {
  let xml_text =
    #|<!DOCTYPE root [
    #|    <!ELEMENT root EMPTY>
    #|
    #|    <!-- SGML-ism:  illegal attribute types -->
    #|
    #|    <!ATTLIST root
    #|	number	NAMES	"The King"
    #|	>
    #|
    #|]>
    #|
    #|<root/>
    #|
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/attlist08" {
  let xml_text =
    #|<!DOCTYPE root [
    #|    <!ELEMENT root EMPTY>
    #|
    #|    <!-- SGML-ism:  illegal attribute default -->
    #|
    #|    <!ATTLIST root
    #|	language	CDATA	#CURRENT
    #|	>
    #|
    #|]>
    #|
    #|<root/>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/attlist09" {
  let xml_text =
    #|<!DOCTYPE root [
    #|    <!-- SGML-ism:  illegal attribute default -->
    #|
    #|    <!ATTLIST root
    #|	language	CDATA	#CONREF
    #|	>
    #|
    #|]>
    #|
    #|<root language="Dutch"/>
    #|
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/attlist10" {
  let xml_text =
    #|<!DOCTYPE root [
    #|<!ELEMENT root ANY>
    #|<!ATTLIST root att1 CDATA #IMPLIED>
    #|<!ATTLIST root att2 CDATA #IMPLIED>
    #|]>
    #|<root att1="value1"att2="value2">
    #|    <!-- whitespace required between attributes -->
    #|</root>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/attlist11" {
  let xml_text =
    #|<!DOCTYPE root [
    #|<!ELEMENT root ANY>
    #|<!ATTLIST root att1 CDATA #IMPLIED>
    #|<!ATTLIST root att2 CDATA #IMPLIED>
    #|]>
    #|<root att1="value1"att2="value2"/>
    #|    <!-- whitespace required between attributes -->
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/content01" {
  let xml_text =
    #|<!DOCTYPE root [
    #|    <!-- no whitespace before '?', '*', '+' -->
    #|    <!ELEMENT root ((root) ?)>
    #|]>
    #|<root/>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/content02" {
  let xml_text =
    #|<!DOCTYPE root [
    #|    <!-- no whitespace before '?', '*', '+' -->
    #|    <!ELEMENT root ((root) *)>
    #|]>
    #|<root/>
    #|
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/content03" {
  let xml_text =
    #|<!DOCTYPE root [
    #|    <!-- no whitespace before '?', '*', '+' -->
    #|    <!ELEMENT root (root +)>
    #|]>
    #|<root/>
    #|
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/nwf_dtd00" {
  let xml_text =
    #|<!DOCTYPE root [
    #|    <!ELEMENT root (foo, bar? foo)>
    #|	<!-- comma omitted -->
    #|    <!ELEMENT foo EMPTY>
    #|    <!ELEMENT bar EMPTY>
    #|]>
    #|
    #|<root> <foo/> <foo/> </root>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/nwf_dtd01" {
  let xml_text =
    #|<!DOCTYPE root [
    #|    <!ELEMENT root (foo, bar? | foo)>
    #|	<!-- comma swapped for vertical bar -->
    #|    <!ELEMENT foo EMPTY>
    #|    <!ELEMENT bar EMPTY>
    #|]>
    #|
    #|<root> <foo/> <foo/> </root>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/dtd02" {
  let xml_text =
    #|<!DOCTYPE root [
    #|    <!ELEMENT root EMPTY>
    #|    <!-- correct PE ref syntax -->
    #|    <!ENTITY % foo "<!ATTLIST root>">
    #|    % foo;
    #|]>
    #|
    #|<root/>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/dtd03" {
  let xml_text =
    #|<!DOCTYPE root [
    #|    <!ELEMENT root EMPTY>
    #|    <!-- correct PE ref syntax -->
    #|    <!ENTITY % foo "<!ATTLIST root>">
    #|    %foo
    #|    ;
    #|]>
    #|
    #|<root/>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/element00" {
  let xml_text =
    #|<root>
    #|    Incomplete end tag.
    #|</ro
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/element01" {
  let xml_text =
    #|<root>
    #|    Incomplete end tag.
    #|</root
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/element02" {
  let xml_text =
    #|<!DOCTYPE html [ <!ELEMENT html ANY> ]>
    #|<html>
    #|    <% @ LANGUAGE="VBSCRIPT" %>
    #|</html>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/element03" {
  let xml_text =
    #|<!DOCTYPE html [ <!ELEMENT html ANY> ]>
    #|<html>
    #|    <% document.println ("hello, world"); %>
    #|</html>
    #|
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/element04" {
  let xml_text =
    #|<!DOCTYPE root [ <!ELEMENT root ANY> ]>
    #|<root>
    #|    <!ELEMENT foo EMPTY>
    #|</root>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/encoding01" {
  let xml_text =
    #|<?xml version="1.0" encoding=" utf-8"?>
    #|<root/>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/encoding02" {
  let xml_text =
    #|<?xml version="1.0" encoding="a/b"?>
    #|<root/>
    #|
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/encoding03" {
  let xml_text =
    #|<?xml version="1.0" encoding="just&#41;word"?>
    #|<root/>
    #|
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/encoding04" {
  let xml_text =
    #|<?xml version="1.0" encoding="utf:8"?>
    #|<root/>
    #|
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/encoding05" {
  let xml_text =
    #|<?xml version="1.0" encoding="@import(sys-encoding)"?>
    #|<root/>
    #|
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/encoding06" {
  let xml_text =
    #|<?xml version="1.0" encoding="XYZ+999"?>
    #|
    #|<!-- WF ... but illegal encoding name, also a fatal error --> 
    #|
    #|<root/>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/pi" {
  let xml_text =
    #|<!DOCTYPE root [
    #|<!ELEMENT root EMPTY>
    #|<!-- space before PI data and ?> -->
    #|<?bad-pi+?>
    #|]>
    #|<root/>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/sgml01" {
  let xml_text =
    #|<!DOCTYPE root [
    #|    <!ELEMENT root EMPTY>
    #|
    #|    <!-- SGML-ism:  omitted end tag -->
    #|]>
    #|
    #|<root>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/sgml02" {
  let xml_text =
    #| <?xml version="1.0"?>
    #|    <!-- SGML-ism:  XML PI not at beginning -->
    #|<!DOCTYPE root [ <!ELEMENT root EMPTY> ]>
    #|<root/>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/sgml03" {
  let xml_text =
    #|<!DOCTYPE root [ <!ELEMENT root EMPTY> ]>
    #|
    #|    <!-- SGML-ism:  -- inside comment -->
    #|<root/>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/sgml04" {
  let xml_text =
    #|<!DOCTYPE root [
    #|    <!-- SGML-ism:  multiple attlist types -->
    #|
    #|    <!ELEMENT root EMPTY>
    #|    <!ELEMENT branch EMPTY>
    #|
    #|    <!ATTLIST (root|branch)
    #|	TreeType CDATA #REQUIRED
    #|	>
    #|]>
    #|
    #|<root/>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/sgml05" {
  let xml_text =
    #|<!DOCTYPE root [
    #|    <!-- SGML-ism:  multiple element types -->
    #|
    #|    <!ELEMENT root EMPTY>
    #|    <!ELEMENT leaves EMPTY>
    #|    <!ELEMENT branch EMPTY>
    #|
    #|    <!ELEMENT (bush|tree) (root,leaves,branch)>
    #|]>
    #|
    #|<root/>
    #|
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/sgml06" {
  let xml_text =
    #|<!DOCTYPE root [
    #|    <!-- Web-SGML-ism:  global attlist types -->
    #|
    #|    <!ELEMENT root EMPTY>
    #|
    #|    <!ATTLIST #ALL
    #|	TreeType CDATA #REQUIRED
    #|	>
    #|]>
    #|
    #|<root/>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/sgml07" {
  let xml_text =
    #|<!DOCTYPE root [
    #|    <!-- SGML-ism:  omitted tag minimzation spec -->
    #|    <!ELEMENT root - o EMPTY>
    #|]>
    #|
    #|<root/>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/sgml08" {
  let xml_text =
    #|<!DOCTYPE root [
    #|    <!-- SGML-ism:  omitted tag minimzation spec -->
    #|    <!ELEMENT root - - EMPTY>
    #|]>
    #|
    #|<root/>
    #|
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/sgml09" {
  let xml_text =
    #|<!DOCTYPE root [
    #|    <!-- SGML-ism:  exception spec -->
    #|
    #|    <!ELEMENT footnote (para*) -footnote>
    #|]>
    #|
    #|<root/>
    #|
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/sgml10" {
  let xml_text =
    #|<!DOCTYPE root [
    #|    <!-- SGML-ism:  exception spec -->
    #|    <!ELEMENT section (header,(para|section))* +(annotation|todo)>
    #|]>
    #|
    #|<root/>
    #|
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/sgml11" {
  let xml_text =
    #|<!DOCTYPE root [
    #|    <!-- SGML-ism:  CDATA content type -->
    #|    <!ELEMENT ROOT CDATA>
    #|]>
    #|
    #|<root/>
    #|
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/sgml12" {
  let xml_text =
    #|<!DOCTYPE root [
    #|    <!-- SGML-ism:  RCDATA content type -->
    #|    <!ELEMENT ROOT RCDATA>
    #|]>
    #|
    #|<root/>
    #|
    #|
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/sgml13" {
  let xml_text =
    #|<!DOCTYPE root [
    #|    <!-- SGML-ism:  unordered content type -->
    #|    <!ELEMENT ROOT (a & b & c)>
    #|    <!ELEMENT a EMPTY>
    #|    <!ELEMENT b EMPTY>
    #|    <!ELEMENT c EMPTY>
    #|]>
    #|
    #|<root><b/><c/><a/></root>
    #|
    #|
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/x_ibm_1_0_5_not_wf_P04_ibm04n02_xml" {
  let xml_text =
    #|<!DOCTYPE ̳IllegalNameStartChar [
    #|<!ELEMENT ̳IllegalNameStartChar ANY>
    #|]>
    #|<!-- IllegalNameStartChar P4: #0x333 -->
    #|<̳IllegalNameStartChar/>
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/x_ibm_1_0_5_not_wf_P04_ibm04n03_xml" {
  let xml_text =
    #|<!DOCTYPE ͩIllegalNameStartChar [
    #|<!ELEMENT ͩIllegalNameStartChar ANY>
    #|]>
    #|<!-- IllegalNameStartChar #0x369  -->
    #|<ͩIllegalNameStartChar/>
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/x_ibm_1_0_5_not_wf_P04_ibm04n04_xml" {
  let xml_text =
    #|<!DOCTYPE ;IllegalNameStartChar [
    #|<!ELEMENT ;IllegalNameStartChar ANY>
    #|]>
    #|<!-- IllegalNameStartChar  #0x37E  -->
    #|<;IllegalNameStartChar/>
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/x_ibm_1_0_5_not_wf_P04_ibm04n05_xml" {
  let xml_text =
    #|<!DOCTYPE  IllegalNameStartChar [
    #|<!ELEMENT  IllegalNameStartChar ANY>
    #|]>
    #|<!-- IllegalNameStartChar #x2000  -->
    #|< IllegalNameStartChar/>
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/x_ibm_1_0_5_not_wf_P04_ibm04n06_xml" {
  let xml_text =
    #|<!DOCTYPE  IllegalNameStartChar [
    #|<!ELEMENT  IllegalNameStartChar ANY>
    #|]>
    #|<!-- IllegalNameStartChar #x2001 -->
    #|< IllegalNameStartChar/>
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/x_ibm_1_0_5_not_wf_P04_ibm04n07_xml" {
  let xml_text =
    #|<!DOCTYPE  IllegalNameStartChar [
    #|<!ELEMENT  IllegalNameStartChar ANY>
    #|]>
    #|<!-- IllegalNameStartChar #x2002 -->
    #|< IllegalNameStartChar/>
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/x_ibm_1_0_5_not_wf_P04_ibm04n08_xml" {
  let xml_text =
    #|<!DOCTYPE  IllegalNameStartChar [
    #|<!ELEMENT  IllegalNameStartChar ANY>
    #|]>
    #|<!-- IllegalNameStartChar #x2005 -->
    #|< IllegalNameStartChar/>
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/x_ibm_1_0_5_not_wf_P04_ibm04n09_xml" {
  let xml_text =
    #|<!DOCTYPE ​IllegalNameStartChar [
    #|<!ELEMENT ​IllegalNameStartChar ANY>
    #|]>
    #|<!-- IllegalNameStartChar #0x200B -->
    #|<​IllegalNameStartChar/>
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/x_ibm_1_0_5_not_wf_P04_ibm04n10_xml" {
  let xml_text =
    #|<!DOCTYPE ‎IllegalNameStartChar [
    #|<!ELEMENT ‎IllegalNameStartChar ANY>
    #|]>
    #|<!-- IllegalNameStartChar #0x200E -->
    #|<‎IllegalNameStartChar/>
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/x_ibm_1_0_5_not_wf_P04_ibm04n11_xml" {
  let xml_text =
    #|<!DOCTYPE ‏IllegalNameStartChar [
    #|<!ELEMENT ‏IllegalNameStartChar ANY>
    #|]>
    #|<!-- IllegalNameStartChar #0x200F  -->
    #|<‏IllegalNameStartChar/>
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/x_ibm_1_0_5_not_wf_P04_ibm04n12_xml" {
  let xml_text =
    #|<!DOCTYPE ⁩IllegalNameStartChar [
    #|<!ELEMENT ⁩IllegalNameStartChar ANY>
    #|]>
    #|<!-- IllegalNameStartChar #0x2069 -->
    #|<⁩IllegalNameStartChar/>
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/x_ibm_1_0_5_not_wf_P04_ibm04n13_xml" {
  let xml_text =
    #|<!DOCTYPE ←IllegalNameStartChar [
    #|<!ELEMENT ←IllegalNameStartChar ANY>
    #|]>
    #|<!-- IllegalNameStartChar #0x2190 -->
    #|<←IllegalNameStartChar/>
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/x_ibm_1_0_5_not_wf_P04_ibm04n14_xml" {
  let xml_text =
    #|<!DOCTYPE ⏿IllegalNameStartChar [
    #|<!ELEMENT ⏿IllegalNameStartChar ANY>
    #|]>
    #|<!-- IllegalNameStartChar #x23FF -->
    #|<⏿IllegalNameStartChar/>
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/x_ibm_1_0_5_not_wf_P04_ibm04n15_xml" {
  let xml_text =
    #|<!DOCTYPE ⠏IllegalNameStartChar [
    #|<!ELEMENT ⠏IllegalNameStartChar ANY>
    #|]>
    #|<!-- IllegalNameStartChar #0x280F  -->
    #|<⠏IllegalNameStartChar/>
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/x_ibm_1_0_5_not_wf_P04_ibm04n16_xml" {
  let xml_text =
    #|<!DOCTYPE ⨀IllegalNameStartChar [
    #|<!ELEMENT ⨀IllegalNameStartChar ANY>
    #|]>
    #|<!-- IllegalNameStartChar #0x2A00 -->
    #|<⨀IllegalNameStartChar/>
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/x_ibm_1_0_5_not_wf_P04_ibm04n17_xml" {
  let xml_text =
    #|<!DOCTYPE ⬀IllegalNameStartChar [
    #|<!ELEMENT ⬀IllegalNameStartChar ANY>
    #|]>
    #|<!-- IllegalNameStartChar #0x2B00  -->
    #|<⬀IllegalNameStartChar/>
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/x_ibm_1_0_5_not_wf_P04_ibm04n18_xml" {
  let xml_text =
    #|<!DOCTYPE ⯿IllegalNameStartChar [
    #|<!ELEMENT ⯿IllegalNameStartChar ANY>
    #|]>
    #|<!-- IllegalNameStartChar x2BFF 
    #|in p02:   -->
    #|<⯿IllegalNameStartChar/>
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/x_ibm_1_0_5_not_wf_P04_ibm04n19_xml" {
  let xml_text =
    #|<!DOCTYPE ⿿IllegalNameStartChar [
    #|<!ELEMENT ⿿IllegalNameStartChar ANY>
    #|]>
    #|<!-- IllegalNameStartChar #0x2FFF -->
    #|<⿿IllegalNameStartChar/>
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/x_ibm_1_0_5_not_wf_P04_ibm04n20_xml" {
  let xml_text = "<!DOCTYPE \u{3000}IllegalNameStartChar [\n<!ELEMENT \u{3000}IllegalNameStartChar ANY>\n]>\n<!-- IllegalNameStartChar #0x3000 -->\n<\u{3000}IllegalNameStartChar/>"
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/x_ibm_1_0_5_not_wf_P04_ibm04n21_xml" {
  let xml_text = "<!DOCTYPE í \u{80}IllegalNameStartChar [\n<!ELEMENT í \u{80}IllegalNameStartChar ANY>\n]>\n<!-- IllegalNameStartChar #0xD800 -->\n<í \u{80}IllegalNameStartChar/>\n"
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/x_ibm_1_0_5_not_wf_P04_ibm04n22_xml" {
  let xml_text = "<!DOCTYPE í \u{81}IllegalNameStartChar [\n<!ELEMENT í \u{81}IllegalNameStartChar ANY>\n]>\n<!-- IllegalNameStartChar #0xD801 -->\n<í \u{81}IllegalNameStartChar/>\n"
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/x_ibm_1_0_5_not_wf_P04_ibm04n23_xml" {
  let xml_text =
    #|<!DOCTYPE í«¿IllegalNameStartChar [
    #|<!ELEMENT í«¿IllegalNameStartChar ANY>
    #|]>
    #|<!-- IllegalNameStartChar #0xDAFF -->
    #|<í«¿IllegalNameStartChar/>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/x_ibm_1_0_5_not_wf_P04_ibm04n24_xml" {
  let xml_text =
    #|<!DOCTYPE í¿¿IllegalNameStartChar [
    #|<!ELEMENT í¿¿IllegalNameStartChar ANY>
    #|]>
    #|<!-- IllegalNameStartChar #0xDFFF -->
    #|<í¿¿IllegalNameStartChar/>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/x_ibm_1_0_5_not_wf_P04_ibm04n25_xml" {
  let xml_text =
    #|<!DOCTYPE IllegalNameStartChar [
    #|<!ELEMENT IllegalNameStartChar ANY>
    #|]>
    #|<!-- IllegalNameStartChar #0xEFFF -->
    #|<IllegalNameStartChar/>
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/x_ibm_1_0_5_not_wf_P04_ibm04n26_xml" {
  let xml_text =
    #|<!DOCTYPE IllegalNameStartChar [
    #|<!ELEMENT IllegalNameStartChar ANY>
    #|]>
    #|<!-- IllegalNameStartChar #0xF1FF -->
    #|<IllegalNameStartChar/>
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/x_ibm_1_0_5_not_wf_P04_ibm04n27_xml" {
  let xml_text =
    #|<!DOCTYPE IllegalNameStartChar [
    #|<!ELEMENT IllegalNameStartChar ANY>
    #|]>
    #|<!-- IllegalNameStartChar #0xF8FF -->
    #|<IllegalNameStartChar/>
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/x_ibm_1_0_5_not_wf_P04_ibm04n28_xml" {
  let xml_text =
    #|<!DOCTYPE ￿IllegalNameStartChar [
    #|<!ELEMENT ￿IllegalNameStartChar ANY>
    #|]>
    #|<!-- IllegalNameStartChar #0xFFFFF -->
    #|<￿IllegalNameStartChar/>
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/x_ibm_1_0_5_not_wf_P04a_ibm04an01_xml" {
  let xml_text =
    #|<!DOCTYPE IllegalNameChar¸ [
    #|<!ELEMENT IllegalNameChar¸ ANY>
    #|]>
    #|<!-- IllegalNameChar #xB8 -->
    #|<IllegalNameChar¸/>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/x_ibm_1_0_5_not_wf_P04a_ibm04an02_xml" {
  let xml_text =
    #|<!DOCTYPE IllegalNameChar¡ [
    #|<!ELEMENT IllegalNameChar¡ ANY>
    #|]>
    #|<!-- IllegalNameChar #0xA1 -->
    #|<IllegalNameChar¡/>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/x_ibm_1_0_5_not_wf_P04a_ibm04an03_xml" {
  let xml_text =
    #|<!DOCTYPE IllegalNameChar¯ [
    #|<!ELEMENT IllegalNameChar¯ ANY>
    #|]>
    #|<!-- IllegalNameChar #0xAF   -->
    #|<IllegalNameChar¯/>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/x_ibm_1_0_5_not_wf_P04a_ibm04an04_xml" {
  let xml_text =
    #|<!DOCTYPE IllegalNameChar; [
    #|<!ELEMENT IllegalNameChar; ANY>
    #|]>
    #|<!-- IllegalNameChar #0x37E -->
    #|<IllegalNameChar;/>
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/x_ibm_1_0_5_not_wf_P04a_ibm04an05_xml" {
  let xml_text =
    #|<!DOCTYPE IllegalNameChar  [
    #|<!ELEMENT IllegalNameChar  ANY>
    #|]>
    #|<!-- IllegalNameChar #0x2000 -->
    #|<IllegalNameChar />
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/x_ibm_1_0_5_not_wf_P04a_ibm04an06_xml" {
  let xml_text =
    #|<!DOCTYPE IllegalNameChar  [
    #|<!ELEMENT IllegalNameChar  ANY>
    #|]>
    #|<!-- IllegalNameChar #0x2001 -->
    #|<IllegalNameChar />
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/x_ibm_1_0_5_not_wf_P04a_ibm04an07_xml" {
  let xml_text =
    #|<!DOCTYPE IllegalNameChar  [
    #|<!ELEMENT IllegalNameChar  ANY>
    #|]>
    #|<!-- IllegalNameChar #0x2002 -->
    #|<IllegalNameChar />
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/x_ibm_1_0_5_not_wf_P04a_ibm04an08_xml" {
  let xml_text =
    #|<!DOCTYPE IllegalNameChar  [
    #|<!ELEMENT IllegalNameChar  ANY>
    #|]>
    #|<!-- IllegalNameChar #0x2005 -->
    #|<IllegalNameChar />
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/x_ibm_1_0_5_not_wf_P04a_ibm04an09_xml" {
  let xml_text =
    #|<!DOCTYPE IllegalNameChar​ [
    #|<!ELEMENT IllegalNameChar​ ANY>
    #|]>
    #|<!-- IllegalNameChar #0x200B -->
    #|<IllegalNameChar​/>
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/x_ibm_1_0_5_not_wf_P04a_ibm04an10_xml" {
  let xml_text =
    #|<!DOCTYPE IllegalNameChar‎ [
    #|<!ELEMENT IllegalNameChar‎ ANY>
    #|]>
    #|<!-- IllegalNameChar #0x200E -->
    #|<IllegalNameChar‎/>
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/x_ibm_1_0_5_not_wf_P04a_ibm04an11_xml" {
  let xml_text =
    #|<!DOCTYPE IllegalNameChar‽ [
    #|<!ELEMENT IllegalNameChar‽ ANY>
    #|]>
    #|<!-- IllegalNameChar #0x2038 -->
    #|<IllegalNameChar‽/>
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/x_ibm_1_0_5_not_wf_P04a_ibm04an12_xml" {
  let xml_text =
    #|<!DOCTYPE IllegalNameChar⁁ [
    #|<!ELEMENT IllegalNameChar⁁ ANY>
    #|]>
    #|<!-- IllegalNameChar #0x2041 -->
    #|<IllegalNameChar⁁/>
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/x_ibm_1_0_5_not_wf_P04a_ibm04an13_xml" {
  let xml_text =
    #|<!DOCTYPE IllegalNameChar← [
    #|<!ELEMENT IllegalNameChar← ANY>
    #|]>
    #|<!-- IllegalNameChar #0x2190 -->
    #|<IllegalNameChar←/>
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/x_ibm_1_0_5_not_wf_P04a_ibm04an14_xml" {
  let xml_text =
    #|<!DOCTYPE IllegalNameChar⏿ [
    #|<!ELEMENT IllegalNameChar⏿ ANY>
    #|]>
    #|<!-- IllegalNameChar #0x23FF -->
    #|<IllegalNameChar⏿/>
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/x_ibm_1_0_5_not_wf_P04a_ibm04an15_xml" {
  let xml_text =
    #|<!DOCTYPE IllegalNameChar⠏ [
    #|<!ELEMENT IllegalNameChar⠏ ANY>
    #|]>
    #|<!-- IllegalNameChar #0x280F -->
    #|<IllegalNameChar⠏/>
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/x_ibm_1_0_5_not_wf_P04a_ibm04an16_xml" {
  let xml_text =
    #|<!DOCTYPE IllegalNameChar⨀ [
    #|<!ELEMENT IllegalNameChar⨀ ANY>
    #|]>
    #|<!-- IllegalNameChar #0x2A00 -->
    #|<IllegalNameChar⨀/>
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/x_ibm_1_0_5_not_wf_P04a_ibm04an17_xml" {
  let xml_text =
    #|<!DOCTYPE IllegalNameChar﷐ [
    #|<!ELEMENT IllegalNameChar﷐ ANY>
    #|]>
    #|<!-- IllegalNameChar #0xFDD0 -->
    #|<IllegalNameChar﷐/>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/x_ibm_1_0_5_not_wf_P04a_ibm04an18_xml" {
  let xml_text =
    #|<!DOCTYPE IllegalNameChar﷯ [
    #|<!ELEMENT IllegalNameChar﷯ ANY>
    #|]>
    #|<!-- IllegalNameChar #0xFDEF -->
    #|<IllegalNameChar﷯/>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/x_ibm_1_0_5_not_wf_P04a_ibm04an19_xml" {
  let xml_text =
    #|<!DOCTYPE IllegalNameChar⿿ [
    #|<!ELEMENT IllegalNameChar⿿ ANY>
    #|]>
    #|<!-- IllegalNameChar #0x2FFF -->
    #|<IllegalNameChar⿿/>
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/x_ibm_1_0_5_not_wf_P04a_ibm04an20_xml" {
  let xml_text = "<!DOCTYPE IllegalNameChar\u{3000} [\n<!ELEMENT IllegalNameChar\u{3000} ANY>\n]>\n<!-- IllegalNameChar  #0x3000 -->\n<IllegalNameChar\u{3000}/>"
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/x_ibm_1_0_5_not_wf_P04a_ibm04an21_xml" {
  let xml_text = "<!DOCTYPE IllegalNameCharí \u{80} [\n<!ELEMENT IllegalNameCharí \u{80} ANY>\n]>\n<!-- IllegalNameChar #0xD800 -->\n<IllegalNameCharí \u{80}/>\n"
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/x_ibm_1_0_5_not_wf_P04a_ibm04an22_xml" {
  let xml_text = "<!DOCTYPE IllegalNameCharí \u{81} [\n<!ELEMENT IllegalNameCharí \u{81} ANY>\n]>\n<!-- IllegalNameChar #0xD801 -->\n<IllegalNameCharí \u{81}/>\n"
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/x_ibm_1_0_5_not_wf_P04a_ibm04an23_xml" {
  let xml_text =
    #|<!DOCTYPE IllegalNameCharí«¿ [
    #|<!ELEMENT IllegalNameCharí«¿ ANY>
    #|]>
    #|<!-- IllegalNameChar #0xDAFF -->
    #|<IllegalNameCharí«¿/>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/x_ibm_1_0_5_not_wf_P04a_ibm04an24_xml" {
  let xml_text =
    #|<!DOCTYPE IllegalNameCharí¿¿ [
    #|<!ELEMENT IllegalNameCharí¿¿ ANY>
    #|]>
    #|<!-- IllegalNameChar #0xDFFF -->
    #|<IllegalNameCharí¿¿/>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/x_ibm_1_0_5_not_wf_P04a_ibm04an25_xml" {
  let xml_text =
    #|<!DOCTYPE IllegalNameChar [
    #|<!ELEMENT IllegalNameChar ANY>
    #|]>
    #|<!-- IllegalNameChar #0xEFFF -->
    #|<IllegalNameChar/>
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/x_ibm_1_0_5_not_wf_P04a_ibm04an26_xml" {
  let xml_text =
    #|<!DOCTYPE IllegalNameChar [
    #|<!ELEMENT IllegalNameChar ANY>
    #|]>
    #|<!-- IllegalNameChar #0xF1FF -->
    #|<IllegalNameChar/>
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/x_ibm_1_0_5_not_wf_P04a_ibm04an27_xml" {
  let xml_text =
    #|<!DOCTYPE IllegalNameChar [
    #|<!ELEMENT IllegalNameChar ANY>
    #|]>
    #|<!-- IllegalNameChar #0xF8FF -->
    #|<IllegalNameChar/>
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/x_ibm_1_0_5_not_wf_P04a_ibm04an28_xml" {
  let xml_text =
    #|<!DOCTYPE IllegalNameChar￿ [
    #|<!ELEMENT IllegalNameChar￿ ANY>
    #|]>
    #|<!-- IllegalNameChar #0xFFFFF -->
    #|<IllegalNameChar￿/>
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/x_ibm_1_0_5_not_wf_P05_ibm05n01_xml" {
  let xml_text = "<!DOCTYPE root [\n<!ELEMENT root ANY>\n<!ELEMENT BadName\u{0B} EMPTY>\n]>\n<!-- BadName containing char 0x0B; -->\n<root>\n\t<BadName\u{0B}/>\t\n</root>"
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/x_ibm_1_0_5_not_wf_P05_ibm05n02_xml" {
  let xml_text =
    #|<!DOCTYPE root [
    #|<!ELEMENT root ANY>
    #|<!ELEMENT ̀BadName EMPTY>
    #|]>
    #|<!-- BadName containing char 0x300; -->
    #|<root>
    #|	<̀BadName/>	
    #|</root>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/x_ibm_1_0_5_not_wf_P05_ibm05n03_xml" {
  let xml_text =
    #|<!DOCTYPE root [
    #|<!ELEMENT root ANY>
    #|<!ELEMENT ͯBadName EMPTY>
    #|]>
    #|<!-- BadName containing char 0x36F; -->
    #|<root>
    #|	<ͯBadName/>	
    #|</root>
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/x_ibm_1_0_5_not_wf_P05_ibm05n04_xml" {
  let xml_text =
    #|<!DOCTYPE root [
    #|<!ELEMENT root ANY>
    #|<!ELEMENT ‿BadName EMPTY>
    #|]>
    #|<!-- BadName containing char 0x203F; -->
    #|<root>
    #|	<‿BadName/>	
    #|</root>
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/x_ibm_1_0_5_not_wf_P05_ibm05n05_xml" {
  let xml_text =
    #|<!DOCTYPE root [
    #|<!ELEMENT root ANY>
    #|<!ELEMENT ⁀BadName EMPTY>
    #|]>
    #|<!-- BadName containing char #x2040; -->
    #|<root>
    #|	<⁀BadName/>	
    #|</root>
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/x_ibm_1_0_5_not_wf_P05_ibm05n06_xml" {
  let xml_text =
    #|<!DOCTYPE root [
    #|<!ELEMENT root ANY>
    #|<!ELEMENT ·BadName EMPTY>
    #|]>
    #|<!-- BadName containing char 0xB7; -->
    #|<root>
    #|	<·BadName/>	
    #|</root>
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/hst_bh_001" {
  let xml_text =
    #|<!DOCTYPE p [
    #|<!ELEMENT p (#PCDATA)>
    #|]>
    #|<p>Fa&#xFF000000F6;il</p>          <!-- 32 bit integer overflow -->
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/hst_bh_002" {
  let xml_text =
    #|<!DOCTYPE p [
    #|<!ELEMENT p (#PCDATA)>
    #|]>
    #|<p>Fa&#4294967542;il</p>           <!-- 32 bit integer overflow -->
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/hst_bh_003" {
  let xml_text =
    #|<!DOCTYPE p [
    #|<!ELEMENT p (#PCDATA)>
    #|]>
    #|<p>Fa&#xFFFFFFFF000000F6;il</p>    <!-- 64 bit integer overflow -->
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/hst_bh_004" {
  let xml_text =
    #|<!DOCTYPE p [
    #|<!ELEMENT p (#PCDATA)>
    #|]>
    #|<p>Fa&#18446744073709551862;il</p> <!-- 64 bit integer overflow -->
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/not-wf/hst_lhs_009" {
  let xml_text =
    #|þÿ<?xml encoding='utf-8'?><x/>
    #|
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "w3c/valid/valid_sa_045" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|<!ATTLIST doc a1 CDATA "v1">
    #|<!ATTLIST doc a1 CDATA "z1">
    #|]>
    #|<doc></doc>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("doc"),
    Start(name="doc", attributes={ "a1": "v1" }),
    End("doc"),
  ])
}

///|
test "w3c/valid/valid_sa_046" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|<!ATTLIST doc a1 CDATA "v1">
    #|<!ATTLIST doc a2 CDATA "v2">
    #|]>
    #|<doc></doc>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("doc"),
    Start(name="doc", attributes={ "a1": "v1", "a2": "v2" }),
    End("doc"),
  ])
}

///|
test "w3c/valid/valid_sa_047" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|]>
    #|<doc>X
    #|Y</doc>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("doc"),
    Start(name="doc", attributes=Map([])),
    Text("X\nY"),
    End("doc"),
  ])
}

///|
test "w3c/valid/valid_sa_048" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|]>
    #|<doc>]</doc>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("doc"),
    Start(name="doc", attributes=Map([])),
    Text("]"),
    End("doc"),
  ])
}

///|
test "w3c/valid/valid_sa_052" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|]>
    #|<doc>𐀀􏿽</doc>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("doc"),
    Start(name="doc", attributes=Map([])),
    Text("𐀀􏿽"),
    End("doc"),
  ])
}

///|
test "w3c/valid/valid_sa_053" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ENTITY e "<e/>">
    #|<!ELEMENT doc (e)>
    #|<!ELEMENT e EMPTY>
    #|]>
    #|<doc>&e;</doc>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("doc"),
    Start(name="doc", attributes=Map([])),
    Start(name="e", attributes=Map([])),
    End("e"),
    End("doc"),
  ])
}

///|
test "w3c/valid/valid_sa_054" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|]>
    #|
    #|
    #|<doc
    #|></doc
    #|>
    #|
    #|
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("doc"),
    Start(name="doc", attributes=Map([])),
    End("doc"),
  ])
}

///|
test "w3c/valid/valid_sa_055" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|]>
    #|<?pi  data?>
    #|<doc></doc>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("doc"),
    PI(target="pi", data="data"),
    Start(name="doc", attributes=Map([])),
    End("doc"),
  ])
}

///|
test "w3c/valid/valid_sa_056" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|]>
    #|<doc>&#x0000000000000000000000000000000000000041;</doc>
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
test "w3c/valid/valid_sa_057" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (a*)>
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
test "w3c/valid/valid_sa_058" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ATTLIST doc a1 NMTOKENS #IMPLIED>
    #|<!ELEMENT doc (#PCDATA)>
    #|]>
    #|<doc a1=" 1  	2 	"></doc>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("doc"),
    Start(name="doc", attributes={ "a1": "1 2" }),
    End("doc"),
  ])
}

///|
test "w3c/valid/valid_sa_059" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (e*)>
    #|<!ELEMENT e EMPTY>
    #|<!ATTLIST e a1 CDATA #IMPLIED a2 CDATA #IMPLIED a3 CDATA #IMPLIED>
    #|]>
    #|<doc>
    #|<e a1="v1" a2="v2" a3="v3"/>
    #|<e a1="w1" a2="v2"/>
    #|<e a1="v1" a2="w2" a3="v3"/>
    #|</doc>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("doc"),
    Start(name="doc", attributes=Map([])),
    Text("\n"),
    Start(name="e", attributes={ "a1": "v1", "a2": "v2", "a3": "v3" }),
    End("e"),
    Text("\n"),
    Start(name="e", attributes={ "a1": "w1", "a2": "v2" }),
    End("e"),
    Text("\n"),
    Start(name="e", attributes={ "a1": "v1", "a2": "w2", "a3": "v3" }),
    End("e"),
    Text("\n"),
    End("doc"),
  ])
}

///|
test "w3c/valid/valid_sa_060" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|]>
    #|<doc>X&#10;Y</doc>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("doc"),
    Start(name="doc", attributes=Map([])),
    Text("X\nY"),
    End("doc"),
  ])
}

///|
test "w3c/valid/valid_sa_061" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|]>
    #|<doc>&#163;</doc>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("doc"),
    Start(name="doc", attributes=Map([])),
    Text("£"),
    End("doc"),
  ])
}

///|
test "w3c/valid/valid_sa_062" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|]>
    #|<doc>&#xe40;&#xe08;&#xe21;ส์</doc>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("doc"),
    Start(name="doc", attributes=Map([])),
    Text("เจมส์"),
    End("doc"),
  ])
}

///|
test "w3c/valid/valid_sa_063" {
  let xml_text =
    #|<!DOCTYPE เจมส์ [
    #|<!ELEMENT เจมส์ (#PCDATA)>
    #|]>
    #|<เจมส์></เจมส์>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("เจมส์"),
    Start(name="เจมส์", attributes=Map([])),
    End("เจมส์"),
  ])
}

///|
test "w3c/valid/valid_sa_064" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|]>
    #|<doc>&#x10000;&#x10FFFD;</doc>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("doc"),
    Start(name="doc", attributes=Map([])),
    Text("𐀀􏿽"),
    End("doc"),
  ])
}

///|
test "w3c/valid/valid_sa_065" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ENTITY e "&#60;">
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
test "w3c/valid/valid_sa_066" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|<!ATTLIST doc a1 CDATA #IMPLIED>
    #|<!-- 34 is double quote -->
    #|<!ENTITY e1 "&#34;">
    #|]>
    #|<doc a1="&e1;"></doc>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("doc"),
    Comment(" 34 is double quote "),
    Start(name="doc", attributes={ "a1": "\"" }),
    End("doc"),
  ])
}

///|
test "w3c/valid/valid_sa_067" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|]>
    #|<doc>&#13;</doc>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("doc"),
    Start(name="doc", attributes=Map([])),
    Text("\r"),
    End("doc"),
  ])
}

///|
test "w3c/valid/valid_sa_068" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|<!ENTITY e "&#13;">
    #|]>
    #|<doc>&e;</doc>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("doc"),
    Start(name="doc", attributes=Map([])),
    Text("\r"),
    End("doc"),
  ])
}

///|
test "w3c/valid/valid_sa_069" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|<!NOTATION n PUBLIC "whatever">
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
test "w3c/valid/valid_sa_071" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|<!ATTLIST doc a ID #IMPLIED>
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
test "w3c/valid/valid_sa_072" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|<!ATTLIST doc a IDREF #IMPLIED>
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
test "w3c/valid/valid_sa_073" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|<!ATTLIST doc a IDREFS #IMPLIED>
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
test "w3c/valid/valid_sa_074" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|<!ATTLIST doc a ENTITY #IMPLIED>
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
test "w3c/valid/valid_sa_075" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|<!ATTLIST doc a ENTITIES #IMPLIED>
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
test "w3c/valid/valid_sa_076" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|<!ATTLIST doc a NOTATION (n1|n2) #IMPLIED>
    #|<!NOTATION n1 SYSTEM "http://www.w3.org/">
    #|<!NOTATION n2 SYSTEM "http://www.w3.org/">
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
test "w3c/valid/valid_sa_077" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|<!ATTLIST doc a (1|2) #IMPLIED>
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
test "w3c/valid/valid_sa_078" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|<!ATTLIST doc a CDATA #REQUIRED>
    #|]>
    #|<doc a="v"></doc>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("doc"),
    Start(name="doc", attributes={ "a": "v" }),
    End("doc"),
  ])
}

///|
test "w3c/valid/valid_sa_079" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|<!ATTLIST doc a CDATA #FIXED "v">
    #|]>
    #|<doc a="v"></doc>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("doc"),
    Start(name="doc", attributes={ "a": "v" }),
    End("doc"),
  ])
}

///|
test "w3c/valid/valid_sa_080" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|<!ATTLIST doc a CDATA #FIXED "v">
    #|]>
    #|<doc></doc>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("doc"),
    Start(name="doc", attributes={ "a": "v" }),
    End("doc"),
  ])
}

///|
test "w3c/valid/valid_sa_081" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (a, b, c)>
    #|<!ELEMENT a (a?)>
    #|<!ELEMENT b (b*)>
    #|<!ELEMENT c (a | b)+>
    #|]>
    #|<doc><a/><b/><c><a/></c></doc>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("doc"),
    Start(name="doc", attributes=Map([])),
    Start(name="a", attributes=Map([])),
    End("a"),
    Start(name="b", attributes=Map([])),
    End("b"),
    Start(name="c", attributes=Map([])),
    Start(name="a", attributes=Map([])),
    End("a"),
    End("c"),
    End("doc"),
  ])
}

///|
test "w3c/valid/valid_sa_084" {
  let xml_text =
    #|<!DOCTYPE doc [<!ELEMENT doc (#PCDATA)>]><doc></doc>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("doc"),
    Start(name="doc", attributes=Map([])),
    End("doc"),
  ])
}

///|
test "w3c/valid/valid_sa_085" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|<!ENTITY % e "<foo>">
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
test "w3c/valid/valid_sa_086" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|<!ENTITY e "">
    #|<!ENTITY e "<foo>">
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
test "w3c/valid/valid_sa_087" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ENTITY e "<foo/&#62;">
    #|<!ELEMENT doc (foo)>
    #|<!ELEMENT foo EMPTY>
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
test "w3c/valid/valid_sa_088" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|<!ENTITY e "&lt;foo>">
    #|]>
    #|<doc>&e;</doc>
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
test "w3c/valid/valid_sa_089" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ENTITY e "&#x10000;&#x10FFFD;&#x10FFFF;">
    #|<!ELEMENT doc (#PCDATA)>
    #|]>
    #|<doc>&e;</doc>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("doc"),
    Start(name="doc", attributes=Map([])),
    Text("𐀀􏿽􏿿"),
    End("doc"),
  ])
}

///|
test "w3c/valid/valid_sa_090" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ATTLIST e a NOTATION (n) #IMPLIED>
    #|<!ELEMENT doc (e)*>
    #|<!ELEMENT e (#PCDATA)>
    #|<!NOTATION n PUBLIC "whatever">
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
test "w3c/valid/valid_sa_092" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (a)*>
    #|<!ELEMENT a EMPTY>
    #|]>
    #|<doc>
    #|<a/>
    #|    <a/>	<a/>
    #|
    #|
    #|</doc>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("doc"),
    Start(name="doc", attributes=Map([])),
    Text("\n"),
    Start(name="a", attributes=Map([])),
    End("a"),
    Text("\n    "),
    Start(name="a", attributes=Map([])),
    End("a"),
    Text("\t"),
    Start(name="a", attributes=Map([])),
    End("a"),
    Text("\n\n\n"),
    End("doc"),
  ])
}

///|
test "w3c/valid/valid_sa_093" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|]>
    #|<doc>
    #|
    #|
    #|</doc>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("doc"),
    Start(name="doc", attributes=Map([])),
    Text("\n\n\n"),
    End("doc"),
  ])
}

///|
test "w3c/valid/valid_sa_094" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ENTITY % e "foo">
    #|<!ELEMENT doc (#PCDATA)>
    #|<!ATTLIST doc a1 CDATA "%e;">
    #|]>
    #|<doc></doc>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("doc"),
    Start(name="doc", attributes={ "a1": "%e;" }),
    End("doc"),
  ])
}

///|
test "w3c/valid/valid_sa_095" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ATTLIST doc a1 CDATA #IMPLIED>
    #|<!ATTLIST doc a1 NMTOKENS #IMPLIED>
    #|<!ELEMENT doc (#PCDATA)>
    #|]>
    #|<doc a1="1  2"></doc>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("doc"),
    Start(name="doc", attributes={ "a1": "1  2" }),
    End("doc"),
  ])
}

///|
test "w3c/valid/valid_sa_096" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ATTLIST doc a1 NMTOKENS " 1  	2 	">
    #|<!ELEMENT doc (#PCDATA)>
    #|]>
    #|<doc></doc>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("doc"),
    Start(name="doc", attributes={ "a1": "1 2" }),
    End("doc"),
  ])
}

///|
test "w3c/valid/valid_sa_098" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|]>
    #|<doc><?pi x
    #|y?></doc>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("doc"),
    Start(name="doc", attributes=Map([])),
    PI(target="pi", data="x\ny"),
    End("doc"),
  ])
}

///|
test "w3c/valid/valid_sa_099" {
  let xml_text =
    #|<?xml version="1.0" encoding="utf-8"?>
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|]>
    #|<doc></doc>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    Decl(version="1.0", encoding=Some("utf-8"), standalone=None),
    DocType("doc"),
    Start(name="doc", attributes=Map([])),
    End("doc"),
  ])
}

///|
test "w3c/valid/valid_sa_101" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|<!ENTITY e "&#34;">
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
test "w3c/valid/valid_sa_102" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|<!ATTLIST doc a CDATA #IMPLIED>
    #|]>
    #|<doc a="&#34;"></doc>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("doc"),
    Start(name="doc", attributes={ "a": "\"" }),
    End("doc"),
  ])
}

///|
test "w3c/valid/valid_sa_103" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|]>
    #|<doc>&#60;doc></doc>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("doc"),
    Start(name="doc", attributes=Map([])),
    Text("<doc>"),
    End("doc"),
  ])
}

///|
test "w3c/valid/valid_sa_104" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|<!ATTLIST doc a CDATA #IMPLIED>
    #|]>
    #|<doc a="x	y"></doc>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("doc"),
    Start(name="doc", attributes={ "a": "x y" }),
    End("doc"),
  ])
}

///|
test "w3c/valid/valid_sa_105" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|<!ATTLIST doc a CDATA #IMPLIED>
    #|]>
    #|<doc a="x&#9;y"></doc>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("doc"),
    Start(name="doc", attributes={ "a": "x\ty" }),
    End("doc"),
  ])
}

///|
test "w3c/valid/valid_sa_106" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|<!ATTLIST doc a CDATA #IMPLIED>
    #|]>
    #|<doc a="x&#10;y"></doc>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("doc"),
    Start(name="doc", attributes={ "a": "x\ny" }),
    End("doc"),
  ])
}

///|
test "w3c/valid/valid_sa_107" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|<!ATTLIST doc a CDATA #IMPLIED>
    #|]>
    #|<doc a="x&#13;y"></doc>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("doc"),
    Start(name="doc", attributes={ "a": "x\ry" }),
    End("doc"),
  ])
}

///|
test "w3c/valid/valid_sa_108" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|<!ENTITY e "
    #|">
    #|<!ATTLIST doc a CDATA #IMPLIED>
    #|]>
    #|<doc a="x&e;y"></doc>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("doc"),
    Start(name="doc", attributes={ "a": "x y" }),
    End("doc"),
  ])
}

///|
test "w3c/valid/valid_sa_109" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|<!ATTLIST doc a CDATA #IMPLIED>
    #|]>
    #|<doc a=""></doc>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("doc"),
    Start(name="doc", attributes={ "a": "" }),
    End("doc"),
  ])
}

///|
test "w3c/valid/valid_sa_110" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|<!ENTITY e "&#13;&#10;">
    #|<!ATTLIST doc a CDATA #IMPLIED>
    #|]>
    #|<doc a="x&e;y"></doc>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("doc"),
    Start(name="doc", attributes={ "a": "x  y" }),
    End("doc"),
  ])
}

///|
test "w3c/valid/valid_sa_111" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|<!ATTLIST doc a NMTOKENS #IMPLIED>
    #|]>
    #|<doc a="&#32;x&#32;&#32;y&#32;"></doc>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("doc"),
    Start(name="doc", attributes={ "a": "x y" }),
    End("doc"),
  ])
}

///|
test "w3c/valid/valid_sa_112" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (a | b)>
    #|<!ELEMENT a (#PCDATA)>
    #|]>
    #|<doc><a></a></doc>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("doc"),
    Start(name="doc", attributes=Map([])),
    Start(name="a", attributes=Map([])),
    End("a"),
    End("doc"),
  ])
}

///|
test "w3c/valid/valid_sa_113" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|<!ATTLIST e a CDATA #IMPLIED>
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
test "w3c/valid/valid_sa_114" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|<!ENTITY e "<![CDATA[&foo;]]>">
    #|]>
    #|<doc>&e;</doc>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("doc"),
    Start(name="doc", attributes=Map([])),
    Text("&foo;"),
    End("doc"),
  ])
}

///|
test "w3c/valid/valid_sa_115" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|<!ENTITY e1 "&e2;">
    #|<!ENTITY e2 "v">
    #|]>
    #|<doc>&e1;</doc>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("doc"),
    Start(name="doc", attributes=Map([])),
    Text("v"),
    End("doc"),
  ])
}

///|
test "w3c/valid/valid_sa_116" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|]>
    #|<doc><![CDATA[
    #|]]></doc>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("doc"),
    Start(name="doc", attributes=Map([])),
    Text("\n"),
    End("doc"),
  ])
}

///|
test "w3c/valid/valid_sa_117" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|<!ENTITY rsqb "]">
    #|]>
    #|<doc>&rsqb;</doc>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("doc"),
    Start(name="doc", attributes=Map([])),
    Text("]"),
    End("doc"),
  ])
}

///|
test "w3c/valid/valid_sa_118" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc (#PCDATA)>
    #|<!ENTITY rsqb "]]">
    #|]>
    #|<doc>&rsqb;</doc>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("doc"),
    Start(name="doc", attributes=Map([])),
    Text("]]"),
    End("doc"),
  ])
}

///|
test "w3c/valid/valid_sa_119" {
  let xml_text =
    #|<!DOCTYPE doc [
    #|<!ELEMENT doc ANY>
    #|]>
    #|<doc><!-- -á --></doc>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("doc"),
    Start(name="doc", attributes=Map([])),
    Comment(" -á "),
    End("doc"),
  ])
}

///|
test "w3c/valid/rmt_ns10_001" {
  let xml_text =
    #|<?xml version="1.0"?>
    #|<!-- Namespace name test: a perfectly good http URI -->
    #|<!DOCTYPE foo [
    #|<!ELEMENT foo ANY>
    #|<!ATTLIST foo xmlns CDATA #IMPLIED>
    #|]>
    #|<foo xmlns="http://example.org/namespace"/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    Decl(version="1.0", encoding=None, standalone=None),
    Comment(" Namespace name test: a perfectly good http URI "),
    DocType("foo"),
    Start(name="foo", attributes={ "xmlns": "http://example.org/namespace" }),
    End("foo"),
  ])
}

///|
test "w3c/valid/rmt_ns10_002" {
  let xml_text =
    #|<?xml version="1.0"?>
    #|<!-- Namespace name test: a syntactically plausible URI with a 
    #|     fictitious scheme -->
    #|<!DOCTYPE foo [
    #|<!ELEMENT foo ANY>
    #|<!ATTLIST foo xmlns CDATA #IMPLIED>
    #|]>
    #|<foo xmlns="zarquon://example.org/namespace"/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    Decl(version="1.0", encoding=None, standalone=None),
    Comment(
      " Namespace name test: a syntactically plausible URI with a \n     fictitious scheme ",
    ),
    DocType("foo"),
    Start(name="foo", attributes={ "xmlns": "zarquon://example.org/namespace" }),
    End("foo"),
  ])
}

///|
test "w3c/valid/rmt_ns10_003" {
  let xml_text =
    #|<?xml version="1.0"?>
    #|<!-- Namespace name test: a perfectly good http URI with a fragment -->
    #|<!DOCTYPE foo [
    #|<!ELEMENT foo ANY>
    #|<!ATTLIST foo xmlns CDATA #IMPLIED>
    #|]>
    #|<foo xmlns="http://example.org/namespace#apples"/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    Decl(version="1.0", encoding=None, standalone=None),
    Comment(" Namespace name test: a perfectly good http URI with a fragment "),
    DocType("foo"),
    Start(name="foo", attributes={
      "xmlns": "http://example.org/namespace#apples",
    }),
    End("foo"),
  ])
}

///|
test "w3c/valid/rmt_ns10_007" {
  let xml_text =
    #|<?xml version="1.0"?>
    #|<!-- Namespace inequality test: different capitalization -->
    #|<!DOCTYPE foo [
    #|<!ELEMENT foo ANY>
    #|<!ATTLIST foo xmlns:a CDATA #IMPLIED
    #|              xmlns:b CDATA #IMPLIED
    #|              xmlns:c CDATA #IMPLIED>
    #|<!ELEMENT bar ANY>
    #|<!ATTLIST bar a:attr CDATA #IMPLIED
    #|              b:attr CDATA #IMPLIED
    #|              c:attr CDATA #IMPLIED>
    #|]>
    #|<foo xmlns:a="http://example.org/wine"
    #|     xmlns:b="http://Example.org/wine"
    #|     xmlns:c="http://example.org/Wine">
    #|
    #|<bar a:attr="1" b:attr="2" c:attr="3"/>
    #|
    #|</foo>
    #|
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    Decl(version="1.0", encoding=None, standalone=None),
    Comment(" Namespace inequality test: different capitalization "),
    DocType("foo"),
    Start(name="foo", attributes={
      "xmlns:a": "http://example.org/wine",
      "xmlns:b": "http://Example.org/wine",
      "xmlns:c": "http://example.org/Wine",
    }),
    Text("\n\n"),
    Start(name="bar", attributes={ "a:attr": "1", "b:attr": "2", "c:attr": "3" }),
    End("bar"),
    Text("\n\n"),
    End("foo"),
  ])
}

///|
test "w3c/valid/rmt_ns10_008" {
  let xml_text =
    #|<?xml version="1.0"?>
    #|<!-- Namespace inequality test: different escaping -->
    #|<!DOCTYPE foo [
    #|<!ELEMENT foo ANY>
    #|<!ATTLIST foo xmlns:a CDATA #IMPLIED
    #|              xmlns:b CDATA #IMPLIED
    #|              xmlns:c CDATA #IMPLIED>
    #|<!ELEMENT bar ANY>
    #|<!ATTLIST bar a:attr CDATA #IMPLIED
    #|              b:attr CDATA #IMPLIED
    #|              c:attr CDATA #IMPLIED>
    #|]>
    #|<foo xmlns:a="http://example.org/~wilbur"
    #|     xmlns:b="http://example.org/%7ewilbur"
    #|     xmlns:c="http://example.org/%7Ewilbur">
    #|
    #|<bar a:attr="1" b:attr="2" c:attr="3"/>
    #|
    #|</foo>
    #|
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    Decl(version="1.0", encoding=None, standalone=None),
    Comment(" Namespace inequality test: different escaping "),
    DocType("foo"),
    Start(name="foo", attributes={
      "xmlns:a": "http://example.org/~wilbur",
      "xmlns:b": "http://example.org/%7ewilbur",
      "xmlns:c": "http://example.org/%7Ewilbur",
    }),
    Text("\n\n"),
    Start(name="bar", attributes={ "a:attr": "1", "b:attr": "2", "c:attr": "3" }),
    End("bar"),
    Text("\n\n"),
    End("foo"),
  ])
}

///|
test "w3c/valid/ht_ns10_047" {
  let xml_text =
    #|<!DOCTYPE xml:foo [
    #|<!ELEMENT xml:foo EMPTY>
    #|]>
    #|<xml:foo/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("xml:foo"),
    Start(name="xml:foo", attributes=Map([])),
    End("xml:foo"),
  ])
}

///|
test "w3c/valid/ht_ns10_048" {
  let xml_text =
    #|<!DOCTYPE x [
    #|<!ELEMENT x EMPTY>
    #|<!ATTLIST x xml:foo CDATA #IMPLIED>
    #|]>
    #|<x xml:foo=""/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("x"),
    Start(name="x", attributes={ "xml:foo": "" }),
    End("x"),
  ])
}

///|
test "w3c/valid/dtd00" {
  let xml_text =
    #|<!DOCTYPE root [
    #|    <!ELEMENT root EMPTY>
    #|    <!ELEMENT x (#PCDATA)>
    #|    <!ELEMENT y (#PCDATA)*>
    #|]>
    #|
    #|<root/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("root"),
    Start(name="root", attributes=Map([])),
    End("root"),
  ])
}

///|
test "w3c/valid/dtd01" {
  let xml_text =
    #|<!DOCTYPE root [
    #|    <!ELEMENT root EMPTY>
    #|    <!ENTITY % PE "this is a PE">
    #|    <!-- %these; %are; %not; %PEs; -->
    #|]>
    #|<root/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("root"),
    Comment(" %these; %are; %not; %PEs; "),
    Start(name="root", attributes=Map([])),
    End("root"),
  ])
}

///|
test "w3c/valid/element" {
  let xml_text =
    #|<!DOCTYPE root [
    #|<!ELEMENT root ANY>
    #|<!ELEMENT empty EMPTY>
    #|<!ELEMENT mixed1 (#PCDATA)>
    #|<!ELEMENT mixed2 (#PCDATA)*>
    #|<!ELEMENT mixed3 (#PCDATA|empty)*>
    #|]>
    #|
    #|<root>
    #|    <empty/>
    #|
    #|    <mixed1/>
    #|    <mixed1></mixed1>
    #|
    #|    <mixed2/>
    #|    <mixed2></mixed2>
    #|
    #|    <mixed3/>
    #|    <mixed3></mixed3>
    #|
    #|    <mixed1>allowed</mixed1>
    #|    <mixed1><![CDATA[<allowed>]]></mixed1>
    #|
    #|    <mixed2>also</mixed2>
    #|    <mixed2><![CDATA[<% illegal otherwise %>]]></mixed2>
    #|
    #|    <mixed3>moreover</mixed3>
    #|
    #|    <mixed1>allowed &amp; stuff</mixed1>
    #|
    #|    <mixed2>also</mixed2>
    #|
    #|    <mixed3>moreover <empty></empty> </mixed3>
    #|    <mixed3>moreover <empty/> </mixed3>
    #|    <mixed3><empty/> </mixed3>
    #|    <mixed3><empty/> too</mixed3>
    #|
    #|</root>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("root"),
    Start(name="root", attributes=Map([])),
    Text("\n    "),
    Start(name="empty", attributes=Map([])),
    End("empty"),
    Text("\n\n    "),
    Start(name="mixed1", attributes=Map([])),
    End("mixed1"),
    Text("\n    "),
    Start(name="mixed1", attributes=Map([])),
    End("mixed1"),
    Text("\n\n    "),
    Start(name="mixed2", attributes=Map([])),
    End("mixed2"),
    Text("\n    "),
    Start(name="mixed2", attributes=Map([])),
    End("mixed2"),
    Text("\n\n    "),
    Start(name="mixed3", attributes=Map([])),
    End("mixed3"),
    Text("\n    "),
    Start(name="mixed3", attributes=Map([])),
    End("mixed3"),
    Text("\n\n    "),
    Start(name="mixed1", attributes=Map([])),
    Text("allowed"),
    End("mixed1"),
    Text("\n    "),
    Start(name="mixed1", attributes=Map([])),
    Text("<allowed>"),
    End("mixed1"),
    Text("\n\n    "),
    Start(name="mixed2", attributes=Map([])),
    Text("also"),
    End("mixed2"),
    Text("\n    "),
    Start(name="mixed2", attributes=Map([])),
    Text("<% illegal otherwise %>"),
    End("mixed2"),
    Text("\n\n    "),
    Start(name="mixed3", attributes=Map([])),
    Text("moreover"),
    End("mixed3"),
    Text("\n\n    "),
    Start(name="mixed1", attributes=Map([])),
    Text("allowed & stuff"),
    End("mixed1"),
    Text("\n\n    "),
    Start(name="mixed2", attributes=Map([])),
    Text("also"),
    End("mixed2"),
    Text("\n\n    "),
    Start(name="mixed3", attributes=Map([])),
    Text("moreover "),
    Start(name="empty", attributes=Map([])),
    End("empty"),
    Text(" "),
    End("mixed3"),
    Text("\n    "),
    Start(name="mixed3", attributes=Map([])),
    Text("moreover "),
    Start(name="empty", attributes=Map([])),
    End("empty"),
    Text(" "),
    End("mixed3"),
    Text("\n    "),
    Start(name="mixed3", attributes=Map([])),
    Start(name="empty", attributes=Map([])),
    End("empty"),
    Text(" "),
    End("mixed3"),
    Text("\n    "),
    Start(name="mixed3", attributes=Map([])),
    Start(name="empty", attributes=Map([])),
    End("empty"),
    Text(" too"),
    End("mixed3"),
    Text("\n\n"),
    End("root"),
  ])
}

///|
test "w3c/valid/required00" {
  let xml_text =
    #|<!DOCTYPE root [
    #|    <!ELEMENT root EMPTY>
    #|    <!ATTLIST root
    #|	req CDATA #REQUIRED
    #|	>
    #|]>
    #|
    #|<root req="foo"/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("root"),
    Start(name="root", attributes={ "req": "foo" }),
    End("root"),
  ])
}

///|
test "w3c/valid/sa01" {
  let xml_text =
    #|<?xml version='1.0' standalone='yes'?>
    #|
    #|<!DOCTYPE root [
    #|    <!ELEMENT root (child)*>
    #|    <!ELEMENT child (#PCDATA)>
    #|]>
    #|
    #|<root>
    #|    <child>
    #|    The whitespace around this element would be
    #|    invalid as standalone were the DTD external.
    #|    </child>
    #|</root>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    Decl(version="1.0", encoding=None, standalone=Some(true)),
    DocType("root"),
    Start(name="root", attributes=Map([])),
    Text("\n    "),
    Start(name="child", attributes=Map([])),
    Text(
      "\n    The whitespace around this element would be\n    invalid as standalone were the DTD external.\n    ",
    ),
    End("child"),
    Text("\n"),
    End("root"),
  ])
}

///|
test "w3c/valid/v_sgml01" {
  let xml_text =
    #|<!DOCTYPE root [
    #|    <!ELEMENT root EMPTY>
    #|    <!--
    #|	SGML dislikes token reuse.  It's legal XML, so any
    #|	XML parser must accept it, though it's discouraged
    #|	in documents "for interoperability"
    #|    -->
    #|    <!ATTLIST root
    #|	status		(initial-draft|revision|final) "initial-draft"
    #|	position	(first|intermediate|final) "first"
    #|	>
    #|]>
    #|
    #|<root/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("root"),
    Comment(
      "\n\tSGML dislikes token reuse.  It's legal XML, so any\n\tXML parser must accept it, though it's discouraged\n\tin documents \"for interoperability\"\n    ",
    ),
    Start(name="root", attributes={
      "status": "initial-draft",
      "position": "first",
    }),
    End("root"),
  ])
}

///|
test "w3c/valid/v_lang01" {
  let xml_text =
    #|<!DOCTYPE root [
    #|<!ELEMENT root EMPTY>
    #|<!ATTLIST root xml:lang CDATA #IMPLIED>
    #|]>
    #|<root xml:lang="en"/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("root"),
    Start(name="root", attributes={ "xml:lang": "en" }),
    End("root"),
  ])
}

///|
test "w3c/valid/v_lang02" {
  let xml_text =
    #|<!DOCTYPE root [
    #|<!ELEMENT root EMPTY>
    #|<!ATTLIST root xml:lang CDATA #IMPLIED>
    #|]>
    #|<root xml:lang="en-IN"/>
    #|
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("root"),
    Start(name="root", attributes={ "xml:lang": "en-IN" }),
    End("root"),
  ])
}

///|
test "w3c/valid/v_lang03" {
  let xml_text =
    #|<!DOCTYPE root [
    #|<!ELEMENT root EMPTY>
    #|<!ATTLIST root xml:lang CDATA #IMPLIED>
    #|]>
    #|<root xml:lang="i-klingon-whorf"/>
    #|
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("root"),
    Start(name="root", attributes={ "xml:lang": "i-klingon-whorf" }),
    End("root"),
  ])
}

///|
test "w3c/valid/v_lang04" {
  let xml_text =
    #|<!DOCTYPE root [
    #|<!ELEMENT root EMPTY>
    #|<!ATTLIST root xml:lang CDATA #IMPLIED>
    #|]>
    #|<root xml:lang="x-dialect-valleygirl"/>
    #|
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("root"),
    Start(name="root", attributes={ "xml:lang": "x-dialect-valleygirl" }),
    End("root"),
  ])
}

///|
test "w3c/valid/v_lang05" {
  let xml_text =
    #|<!DOCTYPE root [
    #|<!ELEMENT root EMPTY>
    #|<!ATTLIST root xml:lang CDATA #IMPLIED>
    #|]>
    #|<root xml:lang="DE"/>
    #|
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("root"),
    Start(name="root", attributes={ "xml:lang": "DE" }),
    End("root"),
  ])
}

///|
test "w3c/valid/v_lang06" {
  let xml_text =
    #|<!DOCTYPE root [
    #|<!ELEMENT root EMPTY>
    #|<!ATTLIST root xml:lang CDATA #IMPLIED>
    #|]>
    #|<root xml:lang="X-Java"/>
    #|
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("root"),
    Start(name="root", attributes={ "xml:lang": "X-Java" }),
    End("root"),
  ])
}

///|
test "w3c/valid/v_pe03" {
  let xml_text =
    #|<!DOCTYPE root [
    #|<!ELEMENT root (p)>
    #|<!ELEMENT p (#PCDATA)>
    #|<!-- Example 1 from XML spec 1.0 Appendix D -->
    #|<!ENTITY example "<p>An ampersand (&#38;#38;) may be escaped
    #|numerically (&#38;#38;#38) or with a general entity (&amp;amp;).</p>" >
    #|]>
    #|<root>&example;</root>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("root"),
    Comment(" Example 1 from XML spec 1.0 Appendix D "),
    Start(name="root", attributes=Map([])),
    Start(name="p", attributes=Map([])),
    Text(
      "An ampersand (&) may be escaped\nnumerically (&#38) or with a general entity (&amp;).",
    ),
    End("p"),
    End("root"),
  ])
}

///|
test "w3c/valid/rmt_e2e_15e" {
  let xml_text =
    #|<!DOCTYPE foo [
    #|<!ELEMENT foo (foo*)>
    #|<!ENTITY space " ">
    #|]>
    #|<foo><foo/>&space;<foo/></foo>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("foo"),
    Start(name="foo", attributes=Map([])),
    Start(name="foo", attributes=Map([])),
    End("foo"),
    Text(" "),
    Start(name="foo", attributes=Map([])),
    End("foo"),
    End("foo"),
  ])
}

///|
test "w3c/valid/rmt_e2e_15f" {
  let xml_text =
    #|<!DOCTYPE foo [
    #|<!ELEMENT foo (foo*)>
    #|<!ENTITY space "&#32;">
    #|]>
    #|<foo><foo/>&space;<foo/></foo>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("foo"),
    Start(name="foo", attributes=Map([])),
    Start(name="foo", attributes=Map([])),
    End("foo"),
    Text(" "),
    Start(name="foo", attributes=Map([])),
    End("foo"),
    End("foo"),
  ])
}

///|
test "w3c/valid/rmt_e2e_15i" {
  let xml_text =
    #|<!DOCTYPE foo [
    #|<!ELEMENT foo (foo*)>
    #|]>
    #|<foo><foo/><!-- comment --><foo/></foo>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("foo"),
    Start(name="foo", attributes=Map([])),
    Start(name="foo", attributes=Map([])),
    End("foo"),
    Comment(" comment "),
    Start(name="foo", attributes=Map([])),
    End("foo"),
    End("foo"),
  ])
}

///|
test "w3c/valid/rmt_e2e_15j" {
  let xml_text =
    #|<!DOCTYPE foo [
    #|<!ELEMENT foo (foo*)>
    #|]>
    #|<foo><foo/><?pi xxx?><foo/></foo>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("foo"),
    Start(name="foo", attributes=Map([])),
    Start(name="foo", attributes=Map([])),
    End("foo"),
    PI(target="pi", data="xxx"),
    Start(name="foo", attributes=Map([])),
    End("foo"),
    End("foo"),
  ])
}

///|
test "w3c/valid/rmt_e2e_15k" {
  let xml_text =
    #|<!DOCTYPE foo [
    #|<!ELEMENT foo (PCDATA|foo)*>
    #|]>
    #|<foo><foo/><!-- comment --><foo/></foo>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("foo"),
    Start(name="foo", attributes=Map([])),
    Start(name="foo", attributes=Map([])),
    End("foo"),
    Comment(" comment "),
    Start(name="foo", attributes=Map([])),
    End("foo"),
    End("foo"),
  ])
}

///|
test "w3c/valid/rmt_e2e_15l" {
  let xml_text =
    #|<!DOCTYPE foo [
    #|<!ELEMENT foo (PCDATA|foo)*>
    #|]>
    #|<foo><foo/><?pi xxx?><foo/></foo>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("foo"),
    Start(name="foo", attributes=Map([])),
    Start(name="foo", attributes=Map([])),
    End("foo"),
    PI(target="pi", data="xxx"),
    Start(name="foo", attributes=Map([])),
    End("foo"),
    End("foo"),
  ])
}

///|
test "w3c/valid/rmt_e2e_22" {
  let xml_text = "\u{FEFF}<?xml version=\"1.0\"?>\n<!DOCTYPE foo [\n<!ELEMENT foo ANY>\n]>\n<foo/>\n"
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    Decl(version="1.0", encoding=None, standalone=None),
    DocType("foo"),
    Start(name="foo", attributes=Map([])),
    End("foo"),
  ])
}

///|
test "w3c/valid/rmt_e2e_24" {
  let xml_text =
    #|<!DOCTYPE foo [
    #|<!ELEMENT foo ANY>
    #|<!ENTITY gt ">">
    #|]>
    #|<foo>You can use ]]&gt; or ]]&#62;</foo>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("foo"),
    Start(name="foo", attributes=Map([])),
    Text("You can use ]]> or ]]>"),
    End("foo"),
  ])
}

///|
test "w3c/valid/rmt_e2e_29" {
  let xml_text =
    #|<!DOCTYPE foo [
    #|<!ELEMENT foo ANY>
    #|<!ATTLIST foo xml:lang NMTOKEN #IMPLIED>
    #|]>
    #|<foo xml:lang="nds">
    #| <foo xml:lang="art-lojban"/>
    #|</foo>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("foo"),
    Start(name="foo", attributes={ "xml:lang": "nds" }),
    Text("\n "),
    Start(name="foo", attributes={ "xml:lang": "art-lojban" }),
    End("foo"),
    Text("\n"),
    End("foo"),
  ])
}

///|
test "w3c/valid/rmt_e2e_41" {
  let xml_text =
    #|<!DOCTYPE foo [
    #|<!ELEMENT foo ANY>
    #|<!ATTLIST foo xml:lang CDATA #IMPLIED>
    #|]>
    #|<foo xml:lang=""/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("foo"),
    Start(name="foo", attributes={ "xml:lang": "" }),
    End("foo"),
  ])
}

///|
test "w3c/valid/rmt_e2e_48" {
  let xml_text =
    #|<!DOCTYPE foo [
    #|<!ELEMENT foo ANY>
    #|]>
    #|<foo>hello</foo>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("foo"),
    Start(name="foo", attributes=Map([])),
    Text("hello"),
    End("foo"),
  ])
}

///|
test "w3c/valid/rmt_e3e_05a" {
  let xml_text =
    #|<!-- CDATA sections may occur in Mixed content. -->
    #|<!DOCTYPE foo [
    #|<!ELEMENT foo (#PCDATA|foo)*>
    #|]>
    #|<foo>a <![CDATA[cdata section]]> in mixed content</foo>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    Comment(" CDATA sections may occur in Mixed content. "),
    DocType("foo"),
    Start(name="foo", attributes=Map([])),
    Text("a cdata section in mixed content"),
    End("foo"),
  ])
}

///|
test "w3c/valid/rmt_e3e_05b" {
  let xml_text =
    #|<!-- CDATA sections, comments and PIs may occur in ANY content. -->
    #|<!DOCTYPE foo [
    #|<!ELEMENT foo ANY>
    #|]>
    #|<foo>
    #|a <![CDATA[cdata section]]> in mixed content.
    #|a <!-- comment --> in mixed content.
    #|a <?processing instruction?> in mixed content.
    #|</foo>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    Comment(" CDATA sections, comments and PIs may occur in ANY content. "),
    DocType("foo"),
    Start(name="foo", attributes=Map([])),
    Text("\na cdata section in mixed content.\na "),
    Comment(" comment "),
    Text(" in mixed content.\na "),
    PI(target="processing", data="instruction"),
    Text(" in mixed content.\n"),
    End("foo"),
  ])
}

///|
test "w3c/valid/x_rmt_008b" {
  let xml_text =
    #|<?xml version="1.7"?>
    #|<!-- an implausibly-versioned document -->
    #|<!DOCTYPE foo [
    #|<!ELEMENT foo ANY>
    #|]>
    #|<foo/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    Decl(version="1.7", encoding=None, standalone=None),
    Comment(" an implausibly-versioned document "),
    DocType("foo"),
    Start(name="foo", attributes=Map([])),
    End("foo"),
  ])
}

///|
test "w3c/valid/x_rmt5_014a" {
  let xml_text =
    #|<!-- Has a "long s" in an ID, legal in XML 1.1, illegal in XML 1.0 -->
    #|<!DOCTYPE egg [
    #|<!ELEMENT egg EMPTY>
    #|<!ATTLIST egg id ID #REQUIRED>
    #|]>
    #|<egg id="eggſ"/>
    #|
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    Comment(" Has a \"long s\" in an ID, legal in XML 1.1, illegal in XML 1.0 "),
    DocType("egg"),
    Start(name="egg", attributes={ "id": "eggſ" }),
    End("egg"),
  ])
}

///|
test "w3c/valid/x_ibm_1_0_5_valid_P04_ibm04v01_xml" {
  let xml_text =
    #|<!DOCTYPE LegalNameStartChar [
    #|<!ELEMENT LegalNameStartChar ANY>
    #|<!ELEMENT :LegalNameStartChar ANY>
    #|<!ELEMENT ÀLegalNameStartChar ANY>
    #|<!ELEMENT ÁLegalNameStartChar ANY>
    #|<!ELEMENT ˾LegalNameStartChar ANY>
    #|<!ELEMENT ˿LegalNameStartChar ANY>
    #|<!ELEMENT ͰLegalNameStartChar ANY>
    #|<!ELEMENT ͱLegalNameStartChar ANY>
    #|<!ELEMENT ͼLegalNameStartChar ANY>
    #|<!ELEMENT ͽLegalNameStartChar ANY>
    #|<!ELEMENT ͿLegalNameStartChar ANY>
    #|<!ELEMENT ΀LegalNameStartChar ANY>
    #|<!ELEMENT ῾LegalNameStartChar ANY>
    #|<!ELEMENT ῿LegalNameStartChar ANY>
    #|<!ELEMENT ‌LegalNameStartChar ANY>
    #|<!ELEMENT ‍LegalNameStartChar ANY>
    #|<!ELEMENT ⁰LegalNameStartChar ANY>
    #|<!ELEMENT ⁱLegalNameStartChar ANY>
    #|<!ELEMENT ↎LegalNameStartChar ANY>
    #|<!ELEMENT ↏LegalNameStartChar ANY>
    #|<!ELEMENT ⰀLegalNameStartChar ANY>
    #|<!ELEMENT ⰁLegalNameStartChar ANY>
    #|<!ELEMENT ⿮LegalNameStartChar ANY>
    #|<!ELEMENT ⿯LegalNameStartChar ANY>
    #|<!ELEMENT 、LegalNameStartChar ANY>
    #|<!ELEMENT 。LegalNameStartChar ANY>
    #|<!ELEMENT ퟾LegalNameStartChar ANY>
    #|<!ELEMENT ퟿LegalNameStartChar ANY>
    #|<!ELEMENT 豈LegalNameStartChar ANY>
    #|<!ELEMENT 更LegalNameStartChar ANY>
    #|]>
    #|<!-- LegalNameChar  0x3A,0xC0,,0xC1,0x2FE,0xC0,,0xC1,0x2FE,0x2FF,0x370,0x371,0x37C,0x37D,0x37F,0x380,0x1FFE,0x1FFF,0x200C,0x200D,0x2070,0x2071,0x218E,0x218F,0x2C00,0x2C01,0x2FEE,0x2FEF,0x3001,0x3002,0xD7FE,0xD7FF,0xF900,0xF901,0xEFFFF,0xFFFFF
    #|in p02:   -->
    #|<LegalNameStartChar>	<:LegalNameStartChar/>
    #|	<ÀLegalNameStartChar/>
    #|	<ÁLegalNameStartChar/>
    #|	<˾LegalNameStartChar/>
    #|	<˿LegalNameStartChar/>
    #|	<ͰLegalNameStartChar/>
    #|	<ͱLegalNameStartChar/>
    #|	<ͼLegalNameStartChar/>
    #|	<ͽLegalNameStartChar/>
    #|	<ͿLegalNameStartChar/>
    #|	<΀LegalNameStartChar/>
    #|	<῾LegalNameStartChar/>
    #|	<῿LegalNameStartChar/>
    #|	<‌LegalNameStartChar/>
    #|	<‍LegalNameStartChar/>
    #|	<⁰LegalNameStartChar/>
    #|	<ⁱLegalNameStartChar/>
    #|	<↎LegalNameStartChar/>
    #|	<↏LegalNameStartChar/>
    #|	<ⰀLegalNameStartChar/>
    #|	<ⰁLegalNameStartChar/>
    #|	<⿮LegalNameStartChar/>
    #|	<⿯LegalNameStartChar/>
    #|	<、LegalNameStartChar/>
    #|	<。LegalNameStartChar/>
    #|	<퟾LegalNameStartChar/>
    #|	<퟿LegalNameStartChar/>
    #|	<豈LegalNameStartChar/>
    #|	<更LegalNameStartChar/>
    #|
    #|</LegalNameStartChar>
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("LegalNameStartChar"),
    Comment(
      " LegalNameChar  0x3A,0xC0,,0xC1,0x2FE,0xC0,,0xC1,0x2FE,0x2FF,0x370,0x371,0x37C,0x37D,0x37F,0x380,0x1FFE,0x1FFF,0x200C,0x200D,0x2070,0x2071,0x218E,0x218F,0x2C00,0x2C01,0x2FEE,0x2FEF,0x3001,0x3002,0xD7FE,0xD7FF,0xF900,0xF901,0xEFFFF,0xFFFFF\nin p02:   ",
    ),
    Start(name="LegalNameStartChar", attributes=Map([])),
    Text("\t"),
    Start(name=":LegalNameStartChar", attributes=Map([])),
    End(":LegalNameStartChar"),
    Text("\n\t"),
    Start(name="ÀLegalNameStartChar", attributes=Map([])),
    End("ÀLegalNameStartChar"),
    Text("\n\t"),
    Start(name="ÁLegalNameStartChar", attributes=Map([])),
    End("ÁLegalNameStartChar"),
    Text("\n\t"),
    Start(name="˾LegalNameStartChar", attributes=Map([])),
    End("˾LegalNameStartChar"),
    Text("\n\t"),
    Start(name="˿LegalNameStartChar", attributes=Map([])),
    End("˿LegalNameStartChar"),
    Text("\n\t"),
    Start(name="ͰLegalNameStartChar", attributes=Map([])),
    End("ͰLegalNameStartChar"),
    Text("\n\t"),
    Start(name="ͱLegalNameStartChar", attributes=Map([])),
    End("ͱLegalNameStartChar"),
    Text("\n\t"),
    Start(name="ͼLegalNameStartChar", attributes=Map([])),
    End("ͼLegalNameStartChar"),
    Text("\n\t"),
    Start(name="ͽLegalNameStartChar", attributes=Map([])),
    End("ͽLegalNameStartChar"),
    Text("\n\t"),
    Start(name="ͿLegalNameStartChar", attributes=Map([])),
    End("ͿLegalNameStartChar"),
    Text("\n\t"),
    Start(name="΀LegalNameStartChar", attributes=Map([])),
    End("΀LegalNameStartChar"),
    Text("\n\t"),
    Start(name="῾LegalNameStartChar", attributes=Map([])),
    End("῾LegalNameStartChar"),
    Text("\n\t"),
    Start(name="῿LegalNameStartChar", attributes=Map([])),
    End("῿LegalNameStartChar"),
    Text("\n\t"),
    Start(name="‌LegalNameStartChar", attributes=Map([])),
    End("‌LegalNameStartChar"),
    Text("\n\t"),
    Start(name="‍LegalNameStartChar", attributes=Map([])),
    End("‍LegalNameStartChar"),
    Text("\n\t"),
    Start(name="⁰LegalNameStartChar", attributes=Map([])),
    End("⁰LegalNameStartChar"),
    Text("\n\t"),
    Start(name="ⁱLegalNameStartChar", attributes=Map([])),
    End("ⁱLegalNameStartChar"),
    Text("\n\t"),
    Start(name="↎LegalNameStartChar", attributes=Map([])),
    End("↎LegalNameStartChar"),
    Text("\n\t"),
    Start(name="↏LegalNameStartChar", attributes=Map([])),
    End("↏LegalNameStartChar"),
    Text("\n\t"),
    Start(name="ⰀLegalNameStartChar", attributes=Map([])),
    End("ⰀLegalNameStartChar"),
    Text("\n\t"),
    Start(name="ⰁLegalNameStartChar", attributes=Map([])),
    End("ⰁLegalNameStartChar"),
    Text("\n\t"),
    Start(name="⿮LegalNameStartChar", attributes=Map([])),
    End("⿮LegalNameStartChar"),
    Text("\n\t"),
    Start(name="⿯LegalNameStartChar", attributes=Map([])),
    End("⿯LegalNameStartChar"),
    Text("\n\t"),
    Start(name="、LegalNameStartChar", attributes=Map([])),
    End("、LegalNameStartChar"),
    Text("\n\t"),
    Start(name="。LegalNameStartChar", attributes=Map([])),
    End("。LegalNameStartChar"),
    Text("\n\t"),
    Start(name="퟾LegalNameStartChar", attributes=Map([])),
    End("퟾LegalNameStartChar"),
    Text("\n\t"),
    Start(name="퟿LegalNameStartChar", attributes=Map([])),
    End("퟿LegalNameStartChar"),
    Text("\n\t"),
    Start(name="豈LegalNameStartChar", attributes=Map([])),
    End("豈LegalNameStartChar"),
    Text("\n\t"),
    Start(name="更LegalNameStartChar", attributes=Map([])),
    End("更LegalNameStartChar"),
    Text("\n\n"),
    End("LegalNameStartChar"),
  ])
}

///|
test "w3c/valid/x_ibm_1_0_5_valid_P04_ibm04av01_xml" {
  let xml_text =
    #|<!DOCTYPE LegalNameChar [
    #|<!ELEMENT LegalNameChar ANY>
    #|<!ELEMENT LegalNameCharÀ ANY>
    #|<!ELEMENT LegalNameCharÁ ANY>
    #|<!ELEMENT LegalNameChar˾ ANY>
    #|<!ELEMENT LegalNameCharÂ ANY>
    #|<!ELEMENT LegalNameCharÃ ANY>
    #|<!ELEMENT LegalNameChar˽ ANY>
    #|<!ELEMENT LegalNameChar˿ ANY>
    #|<!ELEMENT LegalNameCharͰ ANY>
    #|<!ELEMENT LegalNameCharͱ ANY>
    #|<!ELEMENT LegalNameCharͼ ANY>
    #|<!ELEMENT LegalNameCharͽ ANY>
    #|<!ELEMENT LegalNameCharͿ ANY>
    #|<!ELEMENT LegalNameChar΀ ANY>
    #|<!ELEMENT LegalNameChar῾ ANY>
    #|<!ELEMENT LegalNameChar῿ ANY>
    #|<!ELEMENT LegalNameChar‌ ANY>
    #|<!ELEMENT LegalNameChar‍ ANY>
    #|<!ELEMENT LegalNameChar⁰ ANY>
    #|<!ELEMENT LegalNameCharⁱ ANY>
    #|<!ELEMENT LegalNameChar↎ ANY>
    #|<!ELEMENT LegalNameChar↏ ANY>
    #|<!ELEMENT LegalNameCharⰀ ANY>
    #|<!ELEMENT LegalNameCharⰁ ANY>
    #|<!ELEMENT LegalNameChar⿮ ANY>
    #|<!ELEMENT LegalNameChar⿯ ANY>
    #|<!ELEMENT LegalNameChar、 ANY>
    #|<!ELEMENT LegalNameChar。 ANY>
    #|<!ELEMENT LegalNameChar퟾ ANY>
    #|<!ELEMENT LegalNameChar퟿ ANY>
    #|<!ELEMENT LegalNameChar豈 ANY>
    #|<!ELEMENT LegalNameChar更 ANY>
    #|<!ELEMENT LegalNameChar� ANY>
    #|<!ELEMENT LegalNameChar- ANY>
    #|<!ELEMENT LegalNameChar. ANY>
    #|<!ELEMENT LegalNameCharA ANY>
    #|<!ELEMENT LegalNameCharz ANY>
    #|<!ELEMENT LegalNameChar0 ANY>
    #|<!ELEMENT LegalNameChar· ANY>
    #|<!ELEMENT LegalNameChar̀ ANY>
    #|<!ELEMENT LegalNameChaŕ ANY>
    #|<!ELEMENT LegalNameCharͮ ANY>
    #|<!ELEMENT LegalNameCharͯ ANY>
    #|<!ELEMENT LegalNameChar‿ ANY>
    #|<!ELEMENT LegalNameChar⁀ ANY>
    #|]>
    #|<!-- LegalNameChars ending with
    #|0x003A, 0x00C0, 0x00C1, 0x02FE, 0x00C2, 0x00C3, 0x02FD, 0x02FF, 0x0370, 0x0371, 0x037C, 0x037D, 0x037F, 0x0380, 0x1FFE, 0x1FFF, 0x200C, 0x200D, 0x2070, 0x2071, 0x218E, 0x218F, 0x2C00, 0x2C01, 0x2FEE, 0x2FEF, 0x3001, 0x3002, 0xD7FE, 0xD7FF, 0xF900, 0xF901, 0xFFFD, 0x002D, 0x002E, 0x0041, 0x007A, 0x0030, 0x00B7, 0x0300, 0x0301, 0x036E, 0x036F, 0x203F, 0x2040
    #|-->
    #|<LegalNameChar>	
    #|	<LegalNameCharÀ/>
    #|	<LegalNameCharÁ/>
    #|	<LegalNameChar˾/>
    #|	<LegalNameCharÂ/>
    #|	<LegalNameCharÃ/>
    #|	<LegalNameChar˽/>
    #|	<LegalNameChar˿/>
    #|	<LegalNameCharͰ/>
    #|	<LegalNameCharͱ/>
    #|	<LegalNameCharͼ/>
    #|	<LegalNameCharͽ/>
    #|	<LegalNameCharͿ/>
    #|	<LegalNameChar΀/>
    #|	<LegalNameChar῾/>
    #|	<LegalNameChar῿/>
    #|	<LegalNameChar‌/>
    #|	<LegalNameChar‍/>
    #|	<LegalNameChar⁰/>
    #|	<LegalNameCharⁱ/>
    #|	<LegalNameChar↎/>
    #|	<LegalNameChar↏/>
    #|	<LegalNameCharⰀ/>
    #|	<LegalNameCharⰁ/>
    #|	<LegalNameChar⿮/>
    #|	<LegalNameChar⿯/>
    #|	<LegalNameChar、/>
    #|	<LegalNameChar。/>
    #|	<LegalNameChar퟾/>
    #|	<LegalNameChar퟿/>
    #|	<LegalNameChar豈/>
    #|	<LegalNameChar更/>
    #|	<LegalNameChar�/>
    #|	<LegalNameChar-/>
    #|	<LegalNameChar./>
    #|	<LegalNameCharA/>
    #|	<LegalNameCharz/>
    #|	<LegalNameChar0/>
    #|	<LegalNameChar·/>
    #|	<LegalNameChar̀/>
    #|	<LegalNameChaŕ/>
    #|	<LegalNameCharͮ/>
    #|	<LegalNameCharͯ/>
    #|	<LegalNameChar‿/>
    #|	<LegalNameChar⁀/>
    #|</LegalNameChar>
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("LegalNameChar"),
    Comment(
      " LegalNameChars ending with\n0x003A, 0x00C0, 0x00C1, 0x02FE, 0x00C2, 0x00C3, 0x02FD, 0x02FF, 0x0370, 0x0371, 0x037C, 0x037D, 0x037F, 0x0380, 0x1FFE, 0x1FFF, 0x200C, 0x200D, 0x2070, 0x2071, 0x218E, 0x218F, 0x2C00, 0x2C01, 0x2FEE, 0x2FEF, 0x3001, 0x3002, 0xD7FE, 0xD7FF, 0xF900, 0xF901, 0xFFFD, 0x002D, 0x002E, 0x0041, 0x007A, 0x0030, 0x00B7, 0x0300, 0x0301, 0x036E, 0x036F, 0x203F, 0x2040\n",
    ),
    Start(name="LegalNameChar", attributes=Map([])),
    Text("\t\n\t"),
    Start(name="LegalNameCharÀ", attributes=Map([])),
    End("LegalNameCharÀ"),
    Text("\n\t"),
    Start(name="LegalNameCharÁ", attributes=Map([])),
    End("LegalNameCharÁ"),
    Text("\n\t"),
    Start(name="LegalNameChar˾", attributes=Map([])),
    End("LegalNameChar˾"),
    Text("\n\t"),
    Start(name="LegalNameCharÂ", attributes=Map([])),
    End("LegalNameCharÂ"),
    Text("\n\t"),
    Start(name="LegalNameCharÃ", attributes=Map([])),
    End("LegalNameCharÃ"),
    Text("\n\t"),
    Start(name="LegalNameChar˽", attributes=Map([])),
    End("LegalNameChar˽"),
    Text("\n\t"),
    Start(name="LegalNameChar˿", attributes=Map([])),
    End("LegalNameChar˿"),
    Text("\n\t"),
    Start(name="LegalNameCharͰ", attributes=Map([])),
    End("LegalNameCharͰ"),
    Text("\n\t"),
    Start(name="LegalNameCharͱ", attributes=Map([])),
    End("LegalNameCharͱ"),
    Text("\n\t"),
    Start(name="LegalNameCharͼ", attributes=Map([])),
    End("LegalNameCharͼ"),
    Text("\n\t"),
    Start(name="LegalNameCharͽ", attributes=Map([])),
    End("LegalNameCharͽ"),
    Text("\n\t"),
    Start(name="LegalNameCharͿ", attributes=Map([])),
    End("LegalNameCharͿ"),
    Text("\n\t"),
    Start(name="LegalNameChar΀", attributes=Map([])),
    End("LegalNameChar΀"),
    Text("\n\t"),
    Start(name="LegalNameChar῾", attributes=Map([])),
    End("LegalNameChar῾"),
    Text("\n\t"),
    Start(name="LegalNameChar῿", attributes=Map([])),
    End("LegalNameChar῿"),
    Text("\n\t"),
    Start(name="LegalNameChar‌", attributes=Map([])),
    End("LegalNameChar‌"),
    Text("\n\t"),
    Start(name="LegalNameChar‍", attributes=Map([])),
    End("LegalNameChar‍"),
    Text("\n\t"),
    Start(name="LegalNameChar⁰", attributes=Map([])),
    End("LegalNameChar⁰"),
    Text("\n\t"),
    Start(name="LegalNameCharⁱ", attributes=Map([])),
    End("LegalNameCharⁱ"),
    Text("\n\t"),
    Start(name="LegalNameChar↎", attributes=Map([])),
    End("LegalNameChar↎"),
    Text("\n\t"),
    Start(name="LegalNameChar↏", attributes=Map([])),
    End("LegalNameChar↏"),
    Text("\n\t"),
    Start(name="LegalNameCharⰀ", attributes=Map([])),
    End("LegalNameCharⰀ"),
    Text("\n\t"),
    Start(name="LegalNameCharⰁ", attributes=Map([])),
    End("LegalNameCharⰁ"),
    Text("\n\t"),
    Start(name="LegalNameChar⿮", attributes=Map([])),
    End("LegalNameChar⿮"),
    Text("\n\t"),
    Start(name="LegalNameChar⿯", attributes=Map([])),
    End("LegalNameChar⿯"),
    Text("\n\t"),
    Start(name="LegalNameChar、", attributes=Map([])),
    End("LegalNameChar、"),
    Text("\n\t"),
    Start(name="LegalNameChar。", attributes=Map([])),
    End("LegalNameChar。"),
    Text("\n\t"),
    Start(name="LegalNameChar퟾", attributes=Map([])),
    End("LegalNameChar퟾"),
    Text("\n\t"),
    Start(name="LegalNameChar퟿", attributes=Map([])),
    End("LegalNameChar퟿"),
    Text("\n\t"),
    Start(name="LegalNameChar豈", attributes=Map([])),
    End("LegalNameChar豈"),
    Text("\n\t"),
    Start(name="LegalNameChar更", attributes=Map([])),
    End("LegalNameChar更"),
    Text("\n\t"),
    Start(name="LegalNameChar�", attributes=Map([])),
    End("LegalNameChar�"),
    Text("\n\t"),
    Start(name="LegalNameChar-", attributes=Map([])),
    End("LegalNameChar-"),
    Text("\n\t"),
    Start(name="LegalNameChar.", attributes=Map([])),
    End("LegalNameChar."),
    Text("\n\t"),
    Start(name="LegalNameCharA", attributes=Map([])),
    End("LegalNameCharA"),
    Text("\n\t"),
    Start(name="LegalNameCharz", attributes=Map([])),
    End("LegalNameCharz"),
    Text("\n\t"),
    Start(name="LegalNameChar0", attributes=Map([])),
    End("LegalNameChar0"),
    Text("\n\t"),
    Start(name="LegalNameChar·", attributes=Map([])),
    End("LegalNameChar·"),
    Text("\n\t"),
    Start(name="LegalNameChar̀", attributes=Map([])),
    End("LegalNameChar̀"),
    Text("\n\t"),
    Start(name="LegalNameChaŕ", attributes=Map([])),
    End("LegalNameChaŕ"),
    Text("\n\t"),
    Start(name="LegalNameCharͮ", attributes=Map([])),
    End("LegalNameCharͮ"),
    Text("\n\t"),
    Start(name="LegalNameCharͯ", attributes=Map([])),
    End("LegalNameCharͯ"),
    Text("\n\t"),
    Start(name="LegalNameChar‿", attributes=Map([])),
    End("LegalNameChar‿"),
    Text("\n\t"),
    Start(name="LegalNameChar⁀", attributes=Map([])),
    End("LegalNameChar⁀"),
    Text("\n"),
    End("LegalNameChar"),
  ])
}

///|
test "w3c/valid/x_ibm_1_0_5_valid_P05_ibm05v01_xml" {
  let xml_text =
    #|<!DOCTYPE LegalName [
    #|<!ELEMENT LegalName ANY>
    #|<!ELEMENT LegalName: ANY>
    #|<!ELEMENT LegalNameÀ ANY>
    #|<!ELEMENT LegalNameÁ ANY>
    #|<!ELEMENT LegalName˾ ANY>
    #|<!ELEMENT LegalNameÂ ANY>
    #|<!ELEMENT LegalNameÃ ANY>
    #|<!ELEMENT LegalName˽ ANY>
    #|<!ELEMENT LegalName˿ ANY>
    #|<!ELEMENT LegalNameͰ ANY>
    #|<!ELEMENT LegalNameͱ ANY>
    #|<!ELEMENT LegalNameͼͽ ANY>
    #|<!ELEMENT LegalNameͽͿ ANY>
    #|<!ELEMENT LegalNameͿ΀ ANY>
    #|<!ELEMENT LegalName΀῾ ANY>
    #|<!ELEMENT LegalName῾῿ ANY>
    #|<!ELEMENT LegalName῿‌ ANY>
    #|<!ELEMENT LegalName‌‍ ANY>
    #|<!ELEMENT LegalName‍⁰ ANY>
    #|<!ELEMENT LegalName⁰ⁱ ANY>
    #|<!ELEMENT LegalNameⁱ↎ ANY>
    #|<!ELEMENT LegalName↎↏Ⰰ ANY>
    #|<!ELEMENT LegalName↏ⰀⰁ ANY>
    #|<!ELEMENT LegalNameⰀⰁ⿮ ANY>
    #|<!ELEMENT LegalNameⰁ⿮⿯ ANY>
    #|<!ELEMENT LegalName⿮⿯、 ANY>
    #|<!ELEMENT LegalName⿯、。 ANY>
    #|<!ELEMENT LegalName、。퟾ ANY>
    #|<!ELEMENT LegalName。퟾퟿ ANY>
    #|<!ELEMENT LegalName퟾퟿豈 ANY>
    #|<!ELEMENT LegalName퟿豈更 ANY>
    #|<!ELEMENT LegalName豈퟿퟾。 ANY>
    #|<!ELEMENT LegalName更豈퟿퟾ ANY>
    #|<!ELEMENT LegalName�更豈퟿ ANY>
    #|<!ELEMENT LegalName-�更豈 ANY>
    #|<!ELEMENT LegalName.-�更 ANY>
    #|<!ELEMENT LegalNameA.-� ANY>
    #|<!ELEMENT LegalNamezA.- ANY>
    #|<!ELEMENT LegalName0zA. ANY>
    #|<!ELEMENT LegalName·0zA ANY>
    #|<!ELEMENT LegalNamè·0z ANY>
    #|<!ELEMENT LegalNamé̀·0 ANY>
    #|<!ELEMENT LegalNameͮ́̀· ANY>
    #|<!ELEMENT LegalNameͯͮ́̀ ANY>
    #|<!ELEMENT LegalName‿ͯͮ́ ANY>
    #|<!ELEMENT LegalName⁀‿ͯͮ ANY>
    #|<!ELEMENT LegalNamenull⁀‿ͯ ANY>
    #|<!ELEMENT LegalNamenullnull⁀‿ ANY>
    #|<!ELEMENT LegalNamenullnullnull⁀ ANY>
    #|]>
    #|<!-- LegalName  0x300,0x333,0x369,0x37E,0x2000,0x2001,0x2002,0x2005,0x200B,0x200E,x200F,0x2069,0x2190,0x23FF,0x280F,0x2A00,0x2EDC,0x2FED,0x2FFF,0x3000,0xD800,0xD801,0xDAFF,0xDFFF,0xEFFF,0xF1FF,0xF8FF,0xFFFFF,0x2D,0x2E, 0x41,0x7A ,0x30, 0xB7, 0x0300, 0x0301, 0xx036E, 0x036F, 0x203F, 0x203E, 0x2039, 0x2040; 
    #|in p02:   -->
    #|<LegalName>	<LegalName:/>
    #|	<LegalNameÀ/>
    #|	<LegalNameÁ/>
    #|	<LegalName˾/>
    #|	<LegalNameÂ/>
    #|	<LegalNameÃ/>
    #|	<LegalName˽/>
    #|	<LegalName˿/>
    #|	<LegalNameͰ/>
    #|	<LegalNameͱ/>
    #|	<LegalNameͼͽ/>
    #|	<LegalNameͽͿ/>
    #|	<LegalNameͿ΀/>
    #|	<LegalName΀῾/>
    #|	<LegalName῾῿/>
    #|	<LegalName῿‌/>
    #|	<LegalName‌‍/>
    #|	<LegalName‍⁰/>
    #|	<LegalName⁰ⁱ/>
    #|	<LegalNameⁱ↎/>
    #|	<LegalName↎↏Ⰰ/>
    #|	<LegalName↏ⰀⰁ/>
    #|	<LegalNameⰀⰁ⿮/>
    #|	<LegalNameⰁ⿮⿯/>
    #|	<LegalName⿮⿯、/>
    #|	<LegalName⿯、。/>
    #|	<LegalName、。퟾/>
    #|	<LegalName。퟾퟿/>
    #|	<LegalName퟾퟿豈/>
    #|	<LegalName퟿豈更/>
    #|	<LegalName豈퟿퟾。/>
    #|	<LegalName更豈퟿퟾/>
    #|	<LegalName�更豈퟿/>
    #|	<LegalName-�更豈/>
    #|	<LegalName.-�更/>
    #|	<LegalNameA.-�/>
    #|	<LegalNamezA.-/>
    #|	<LegalName0zA./>
    #|	<LegalName·0zA/>
    #|	<LegalNamè·0z/>
    #|	<LegalNamé̀·0/>
    #|	<LegalNameͮ́̀·/>
    #|	<LegalNameͯͮ́̀/>
    #|	<LegalName‿ͯͮ́/>
    #|	<LegalName⁀‿ͯͮ/>
    #|	<LegalNamenull⁀‿ͯ/>
    #|	<LegalNamenullnull⁀‿/>
    #|	<LegalNamenullnullnull⁀/>
    #|</LegalName>
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("LegalName"),
    Comment(
      " LegalName  0x300,0x333,0x369,0x37E,0x2000,0x2001,0x2002,0x2005,0x200B,0x200E,x200F,0x2069,0x2190,0x23FF,0x280F,0x2A00,0x2EDC,0x2FED,0x2FFF,0x3000,0xD800,0xD801,0xDAFF,0xDFFF,0xEFFF,0xF1FF,0xF8FF,0xFFFFF,0x2D,0x2E, 0x41,0x7A ,0x30, 0xB7, 0x0300, 0x0301, 0xx036E, 0x036F, 0x203F, 0x203E, 0x2039, 0x2040; \nin p02:   ",
    ),
    Start(name="LegalName", attributes=Map([])),
    Text("\t"),
    Start(name="LegalName:", attributes=Map([])),
    End("LegalName:"),
    Text("\n\t"),
    Start(name="LegalNameÀ", attributes=Map([])),
    End("LegalNameÀ"),
    Text("\n\t"),
    Start(name="LegalNameÁ", attributes=Map([])),
    End("LegalNameÁ"),
    Text("\n\t"),
    Start(name="LegalName˾", attributes=Map([])),
    End("LegalName˾"),
    Text("\n\t"),
    Start(name="LegalNameÂ", attributes=Map([])),
    End("LegalNameÂ"),
    Text("\n\t"),
    Start(name="LegalNameÃ", attributes=Map([])),
    End("LegalNameÃ"),
    Text("\n\t"),
    Start(name="LegalName˽", attributes=Map([])),
    End("LegalName˽"),
    Text("\n\t"),
    Start(name="LegalName˿", attributes=Map([])),
    End("LegalName˿"),
    Text("\n\t"),
    Start(name="LegalNameͰ", attributes=Map([])),
    End("LegalNameͰ"),
    Text("\n\t"),
    Start(name="LegalNameͱ", attributes=Map([])),
    End("LegalNameͱ"),
    Text("\n\t"),
    Start(name="LegalNameͼͽ", attributes=Map([])),
    End("LegalNameͼͽ"),
    Text("\n\t"),
    Start(name="LegalNameͽͿ", attributes=Map([])),
    End("LegalNameͽͿ"),
    Text("\n\t"),
    Start(name="LegalNameͿ΀", attributes=Map([])),
    End("LegalNameͿ΀"),
    Text("\n\t"),
    Start(name="LegalName΀῾", attributes=Map([])),
    End("LegalName΀῾"),
    Text("\n\t"),
    Start(name="LegalName῾῿", attributes=Map([])),
    End("LegalName῾῿"),
    Text("\n\t"),
    Start(name="LegalName῿‌", attributes=Map([])),
    End("LegalName῿‌"),
    Text("\n\t"),
    Start(name="LegalName‌‍", attributes=Map([])),
    End("LegalName‌‍"),
    Text("\n\t"),
    Start(name="LegalName‍⁰", attributes=Map([])),
    End("LegalName‍⁰"),
    Text("\n\t"),
    Start(name="LegalName⁰ⁱ", attributes=Map([])),
    End("LegalName⁰ⁱ"),
    Text("\n\t"),
    Start(name="LegalNameⁱ↎", attributes=Map([])),
    End("LegalNameⁱ↎"),
    Text("\n\t"),
    Start(name="LegalName↎↏Ⰰ", attributes=Map([])),
    End("LegalName↎↏Ⰰ"),
    Text("\n\t"),
    Start(name="LegalName↏ⰀⰁ", attributes=Map([])),
    End("LegalName↏ⰀⰁ"),
    Text("\n\t"),
    Start(name="LegalNameⰀⰁ⿮", attributes=Map([])),
    End("LegalNameⰀⰁ⿮"),
    Text("\n\t"),
    Start(name="LegalNameⰁ⿮⿯", attributes=Map([])),
    End("LegalNameⰁ⿮⿯"),
    Text("\n\t"),
    Start(name="LegalName⿮⿯、", attributes=Map([])),
    End("LegalName⿮⿯、"),
    Text("\n\t"),
    Start(name="LegalName⿯、。", attributes=Map([])),
    End("LegalName⿯、。"),
    Text("\n\t"),
    Start(name="LegalName、。퟾", attributes=Map([])),
    End("LegalName、。퟾"),
    Text("\n\t"),
    Start(name="LegalName。퟾퟿", attributes=Map([])),
    End("LegalName。퟾퟿"),
    Text("\n\t"),
    Start(name="LegalName퟾퟿豈", attributes=Map([])),
    End("LegalName퟾퟿豈"),
    Text("\n\t"),
    Start(name="LegalName퟿豈更", attributes=Map([])),
    End("LegalName퟿豈更"),
    Text("\n\t"),
    Start(name="LegalName豈퟿퟾。", attributes=Map([])),
    End("LegalName豈퟿퟾。"),
    Text("\n\t"),
    Start(name="LegalName更豈퟿퟾", attributes=Map([])),
    End("LegalName更豈퟿퟾"),
    Text("\n\t"),
    Start(name="LegalName�更豈퟿", attributes=Map([])),
    End("LegalName�更豈퟿"),
    Text("\n\t"),
    Start(name="LegalName-�更豈", attributes=Map([])),
    End("LegalName-�更豈"),
    Text("\n\t"),
    Start(name="LegalName.-�更", attributes=Map([])),
    End("LegalName.-�更"),
    Text("\n\t"),
    Start(name="LegalNameA.-�", attributes=Map([])),
    End("LegalNameA.-�"),
    Text("\n\t"),
    Start(name="LegalNamezA.-", attributes=Map([])),
    End("LegalNamezA.-"),
    Text("\n\t"),
    Start(name="LegalName0zA.", attributes=Map([])),
    End("LegalName0zA."),
    Text("\n\t"),
    Start(name="LegalName·0zA", attributes=Map([])),
    End("LegalName·0zA"),
    Text("\n\t"),
    Start(name="LegalNamè·0z", attributes=Map([])),
    End("LegalNamè·0z"),
    Text("\n\t"),
    Start(name="LegalNamé̀·0", attributes=Map([])),
    End("LegalNamé̀·0"),
    Text("\n\t"),
    Start(name="LegalNameͮ́̀·", attributes=Map([])),
    End("LegalNameͮ́̀·"),
    Text("\n\t"),
    Start(name="LegalNameͯͮ́̀", attributes=Map([])),
    End("LegalNameͯͮ́̀"),
    Text("\n\t"),
    Start(name="LegalName‿ͯͮ́", attributes=Map([])),
    End("LegalName‿ͯͮ́"),
    Text("\n\t"),
    Start(name="LegalName⁀‿ͯͮ", attributes=Map([])),
    End("LegalName⁀‿ͯͮ"),
    Text("\n\t"),
    Start(name="LegalNamenull⁀‿ͯ", attributes=Map([])),
    End("LegalNamenull⁀‿ͯ"),
    Text("\n\t"),
    Start(name="LegalNamenullnull⁀‿", attributes=Map([])),
    End("LegalNamenullnull⁀‿"),
    Text("\n\t"),
    Start(name="LegalNamenullnullnull⁀", attributes=Map([])),
    End("LegalNamenullnullnull⁀"),
    Text("\n"),
    End("LegalName"),
  ])
}

///|
test "w3c/valid/x_ibm_1_0_5_valid_P05_ibm05v02_xml" {
  let xml_text =
    #|<!DOCTYPE LegalName [
    #|<!ELEMENT LegalName ANY>
    #|]>
    #|<!-- Legal Names containing one to four characters in order from the list below  used in PI Target Names.  x003A, 0x00C0, 0x00C1, 0x02FE, 0x00C2, 0x00C3, 0x02FD, 0x02FF, 0x0370, 0x0371, 0x037C, 0x037D, 0x037F, 0x0380, 0x1FFE, 0x1FFF, 0x200C, 0x200D, 0x2070, 0x2071, 0x218E, 0x218F, 0x2C00, 0x2C01, 0x2FEE, 0x2FEF, 0x3001, 0x3002, 0xD7FE, 0xD7FF, 0xF900, 0xF901, 0xFFFD, 0x002D, 0x002E, 0x0041, 0x007A, 0x0030, 0x00B7, 0x0300, 0x0301, 0x036E, 0x036F, 0x203F, 0x2040 -->
    #|<LegalName>
    #|	<?PITarget: 	Test	 PIData?>
    #|	<?PITargetÀ 	Test	 PIData?>
    #|	<?PITargetÁ 	Test	 PIData?>
    #|	<?PITarget˾ 	Test	 PIData?>
    #|	<?PITargetÂ 	Test	 PIData?>
    #|	<?PITargetÃ 	Test	 PIData?>
    #|	<?PITarget˽ 	Test	 PIData?>
    #|	<?PITarget˿ 	Test	 PIData?>
    #|	<?PITargetͰ 	Test	 PIData?>
    #|	<?PITargetͱ 	Test	 PIData?>
    #|	<?PITargetͼͽ 	Test	 PIData?>
    #|	<?PITargetͽͿ 	Test	 PIData?>
    #|	<?PITargetͿ΀ 	Test	 PIData?>
    #|	<?PITarget΀῾ 	Test	 PIData?>
    #|	<?PITarget῾῿ 	Test	 PIData?>
    #|	<?PITarget῿‌ 	Test	 PIData?>
    #|	<?PITarget‌‍ 	Test	 PIData?>
    #|	<?PITarget‍⁰ 	Test	 PIData?>
    #|	<?PITarget⁰ⁱ 	Test	 PIData?>
    #|	<?PITargetⁱ↎ 	Test	 PIData?>
    #|	<?PITarget↎↏Ⰰ 	Test	 PIData?>
    #|	<?PITarget↏ⰀⰁ 	Test	 PIData?>
    #|	<?PITargetⰀⰁ⿮ 	Test	 PIData?>
    #|	<?PITargetⰁ⿮⿯ 	Test	 PIData?>
    #|	<?PITarget⿮⿯、 	Test	 PIData?>
    #|	<?PITarget⿯、。 	Test	 PIData?>
    #|	<?PITarget、。퟾ 	Test	 PIData?>
    #|	<?PITarget。퟾퟿ 	Test	 PIData?>
    #|	<?PITarget퟾퟿豈 	Test	 PIData?>
    #|	<?PITarget퟿豈更 	Test	 PIData?>
    #|	<?PITarget豈퟿퟾。 	Test	 PIData?>
    #|	<?PITarget更豈퟿퟾ 	Test	 PIData?>
    #|	<?PITarget�更豈퟿ 	Test	 PIData?>
    #|	<?PITarget-�更豈 	Test	 PIData?>
    #|	<?PITarget.-�更 	Test	 PIData?>
    #|	<?PITargetA.-� 	Test	 PIData?>
    #|	<?PITargetzA.- 	Test	 PIData?>
    #|	<?PITarget0zA. 	Test	 PIData?>
    #|	<?PITarget·0zA 	Test	 PIData?>
    #|	<?PITarget̀·0z 	Test	 PIData?>
    #|	<?PITarget́̀·0 	Test	 PIData?>
    #|	<?PITargetͮ́̀· 	Test	 PIData?>
    #|	<?PITargetͯͮ́̀ 	Test	 PIData?>
    #|	<?PITarget‿ͯͮ́ 	Test	 PIData?>
    #|	<?PITarget⁀‿ͯͮ 	Test	 PIData?>
    #|	<?PITargetnull⁀‿ͯ 	Test	 PIData?>
    #|	<?PITargetnullnull⁀‿ 	Test	 PIData?>
    #|	<?PITargetnullnullnull⁀ 	Test	 PIData?>
    #|</LegalName>
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("LegalName"),
    Comment(
      " Legal Names containing one to four characters in order from the list below  used in PI Target Names.  x003A, 0x00C0, 0x00C1, 0x02FE, 0x00C2, 0x00C3, 0x02FD, 0x02FF, 0x0370, 0x0371, 0x037C, 0x037D, 0x037F, 0x0380, 0x1FFE, 0x1FFF, 0x200C, 0x200D, 0x2070, 0x2071, 0x218E, 0x218F, 0x2C00, 0x2C01, 0x2FEE, 0x2FEF, 0x3001, 0x3002, 0xD7FE, 0xD7FF, 0xF900, 0xF901, 0xFFFD, 0x002D, 0x002E, 0x0041, 0x007A, 0x0030, 0x00B7, 0x0300, 0x0301, 0x036E, 0x036F, 0x203F, 0x2040 ",
    ),
    Start(name="LegalName", attributes=Map([])),
    Text("\n\t"),
    PI(target="PITarget:", data="Test\t PIData"),
    Text("\n\t"),
    PI(target="PITargetÀ", data="Test\t PIData"),
    Text("\n\t"),
    PI(target="PITargetÁ", data="Test\t PIData"),
    Text("\n\t"),
    PI(target="PITarget˾", data="Test\t PIData"),
    Text("\n\t"),
    PI(target="PITargetÂ", data="Test\t PIData"),
    Text("\n\t"),
    PI(target="PITargetÃ", data="Test\t PIData"),
    Text("\n\t"),
    PI(target="PITarget˽", data="Test\t PIData"),
    Text("\n\t"),
    PI(target="PITarget˿", data="Test\t PIData"),
    Text("\n\t"),
    PI(target="PITargetͰ", data="Test\t PIData"),
    Text("\n\t"),
    PI(target="PITargetͱ", data="Test\t PIData"),
    Text("\n\t"),
    PI(target="PITargetͼͽ", data="Test\t PIData"),
    Text("\n\t"),
    PI(target="PITargetͽͿ", data="Test\t PIData"),
    Text("\n\t"),
    PI(target="PITargetͿ΀", data="Test\t PIData"),
    Text("\n\t"),
    PI(target="PITarget΀῾", data="Test\t PIData"),
    Text("\n\t"),
    PI(target="PITarget῾῿", data="Test\t PIData"),
    Text("\n\t"),
    PI(target="PITarget῿‌", data="Test\t PIData"),
    Text("\n\t"),
    PI(target="PITarget‌‍", data="Test\t PIData"),
    Text("\n\t"),
    PI(target="PITarget‍⁰", data="Test\t PIData"),
    Text("\n\t"),
    PI(target="PITarget⁰ⁱ", data="Test\t PIData"),
    Text("\n\t"),
    PI(target="PITargetⁱ↎", data="Test\t PIData"),
    Text("\n\t"),
    PI(target="PITarget↎↏Ⰰ", data="Test\t PIData"),
    Text("\n\t"),
    PI(target="PITarget↏ⰀⰁ", data="Test\t PIData"),
    Text("\n\t"),
    PI(target="PITargetⰀⰁ⿮", data="Test\t PIData"),
    Text("\n\t"),
    PI(target="PITargetⰁ⿮⿯", data="Test\t PIData"),
    Text("\n\t"),
    PI(target="PITarget⿮⿯、", data="Test\t PIData"),
    Text("\n\t"),
    PI(target="PITarget⿯、。", data="Test\t PIData"),
    Text("\n\t"),
    PI(target="PITarget、。퟾", data="Test\t PIData"),
    Text("\n\t"),
    PI(target="PITarget。퟾퟿", data="Test\t PIData"),
    Text("\n\t"),
    PI(target="PITarget퟾퟿豈", data="Test\t PIData"),
    Text("\n\t"),
    PI(target="PITarget퟿豈更", data="Test\t PIData"),
    Text("\n\t"),
    PI(target="PITarget豈퟿퟾。", data="Test\t PIData"),
    Text("\n\t"),
    PI(target="PITarget更豈퟿퟾", data="Test\t PIData"),
    Text("\n\t"),
    PI(target="PITarget�更豈퟿", data="Test\t PIData"),
    Text("\n\t"),
    PI(target="PITarget-�更豈", data="Test\t PIData"),
    Text("\n\t"),
    PI(target="PITarget.-�更", data="Test\t PIData"),
    Text("\n\t"),
    PI(target="PITargetA.-�", data="Test\t PIData"),
    Text("\n\t"),
    PI(target="PITargetzA.-", data="Test\t PIData"),
    Text("\n\t"),
    PI(target="PITarget0zA.", data="Test\t PIData"),
    Text("\n\t"),
    PI(target="PITarget·0zA", data="Test\t PIData"),
    Text("\n\t"),
    PI(target="PITarget̀·0z", data="Test\t PIData"),
    Text("\n\t"),
    PI(target="PITarget́̀·0", data="Test\t PIData"),
    Text("\n\t"),
    PI(target="PITargetͮ́̀·", data="Test\t PIData"),
    Text("\n\t"),
    PI(target="PITargetͯͮ́̀", data="Test\t PIData"),
    Text("\n\t"),
    PI(target="PITarget‿ͯͮ́", data="Test\t PIData"),
    Text("\n\t"),
    PI(target="PITarget⁀‿ͯͮ", data="Test\t PIData"),
    Text("\n\t"),
    PI(target="PITargetnull⁀‿ͯ", data="Test\t PIData"),
    Text("\n\t"),
    PI(target="PITargetnullnull⁀‿", data="Test\t PIData"),
    Text("\n\t"),
    PI(target="PITargetnullnullnull⁀", data="Test\t PIData"),
    Text("\n"),
    End("LegalName"),
  ])
}

///|
test "w3c/valid/x_ibm_1_0_5_valid_P05_ibm05v03_xml" {
  let xml_text =
    #|<!DOCTYPE LegalName [
    #|<!ELEMENT LegalName ANY>
    #|<!ATTLIST LegalName :attr CDATA #IMPLIED>
    #|<!ATTLIST LegalName Àattr CDATA #IMPLIED>
    #|<!ATTLIST LegalName Áattr CDATA #IMPLIED>
    #|<!ATTLIST LegalName ˾attr CDATA #IMPLIED>
    #|<!ATTLIST LegalName Âattr CDATA #IMPLIED>
    #|<!ATTLIST LegalName Ãattr CDATA #IMPLIED>
    #|<!ATTLIST LegalName ˽attr CDATA #IMPLIED>
    #|<!ATTLIST LegalName ˿attr CDATA #IMPLIED>
    #|<!ATTLIST LegalName Ͱattr CDATA #IMPLIED>
    #|<!ATTLIST LegalName ͱattr CDATA #IMPLIED>
    #|<!ATTLIST LegalName ͼͽattr CDATA #IMPLIED>
    #|<!ATTLIST LegalName ͽͿattr CDATA #IMPLIED>
    #|<!ATTLIST LegalName Ϳ΀attr CDATA #IMPLIED>
    #|<!ATTLIST LegalName ΀῾attr CDATA #IMPLIED>
    #|<!ATTLIST LegalName ῾῿attr CDATA #IMPLIED>
    #|<!ATTLIST LegalName ῿‌attr CDATA #IMPLIED>
    #|<!ATTLIST LegalName ‌‍attr CDATA #IMPLIED>
    #|<!ATTLIST LegalName ‍⁰attr CDATA #IMPLIED>
    #|<!ATTLIST LegalName ⁰ⁱattr CDATA #IMPLIED>
    #|<!ATTLIST LegalName ⁱ↎attr CDATA #IMPLIED>
    #|<!ATTLIST LegalName ↎↏Ⰰattr CDATA #IMPLIED>
    #|<!ATTLIST LegalName ↏ⰀⰁattr CDATA #IMPLIED>
    #|<!ATTLIST LegalName ⰀⰁ⿮attr CDATA #IMPLIED>
    #|<!ATTLIST LegalName Ⰱ⿮⿯attr CDATA #IMPLIED>
    #|<!ATTLIST LegalName ⿮⿯、attr CDATA #IMPLIED>
    #|<!ATTLIST LegalName ⿯、。attr CDATA #IMPLIED>
    #|<!ATTLIST LegalName 、。퟾attr CDATA #IMPLIED>
    #|<!ATTLIST LegalName 。퟾퟿attr CDATA #IMPLIED>
    #|<!ATTLIST LegalName ퟾퟿豈attr CDATA #IMPLIED>
    #|<!ATTLIST LegalName ퟿豈更attr CDATA #IMPLIED>
    #|<!ATTLIST LegalName 豈퟿퟾。attr CDATA #IMPLIED>
    #|<!ATTLIST LegalName 更豈퟿퟾attr CDATA #IMPLIED>
    #|<!ATTLIST LegalName �更豈퟿attr CDATA #IMPLIED>
    #|<!ATTLIST LegalName attr-�更豈 CDATA #IMPLIED>
    #|<!ATTLIST LegalName attr.-�更 CDATA #IMPLIED>
    #|<!ATTLIST LegalName A.-�attr CDATA #IMPLIED>
    #|<!ATTLIST LegalName zA.-attr CDATA #IMPLIED>
    #|<!ATTLIST LegalName attr0zA. CDATA #IMPLIED>
    #|<!ATTLIST LegalName attr·0zA CDATA #IMPLIED>
    #|<!ATTLIST LegalName attr̀·0z CDATA #IMPLIED>
    #|<!ATTLIST LegalName attŕ̀·0 CDATA #IMPLIED>
    #|<!ATTLIST LegalName attrͮ́̀· CDATA #IMPLIED>
    #|<!ATTLIST LegalName attrͯͮ́̀ CDATA #IMPLIED>
    #|<!ATTLIST LegalName attr‿ͯͮ́ CDATA #IMPLIED>
    #|<!ATTLIST LegalName attr⁀‿ͯͮ CDATA #IMPLIED>
    #|<!ATTLIST LegalName null⁀‿ͯattr CDATA #IMPLIED>
    #|<!ATTLIST LegalName nullnull⁀‿attr CDATA #IMPLIED>
    #|<!ATTLIST LegalName nullnullnull⁀attr CDATA #IMPLIED>
    #|]>
    #|<!-- Legal Names containing one to four characters in order from the list below  used in Attr delcs and attributes.  x003A, 0x00C0, 0x00C1, 0x02FE, 0x00C2, 0x00C3, 0x02FD, 0x02FF, 0x0370, 0x0371, 0x037C, 0x037D, 0x037F, 0x0380, 0x1FFE, 0x1FFF, 0x200C, 0x200D, 0x2070, 0x2071, 0x218E, 0x218F, 0x2C00, 0x2C01, 0x2FEE, 0x2FEF, 0x3001, 0x3002, 0xD7FE, 0xD7FF, 0xF900, 0xF901, 0xFFFD, 0x002D, 0x002E, 0x0041, 0x007A, 0x0030, 0x00B7, 0x0300, 0x0301, 0x036E, 0x036F, 0x203F, 0x2040 -->
    #|<LegalName 
    #| 	:attr="attrValue"
    #| 	Àattr="attrValue"
    #| 	Áattr="attrValue"
    #| 	˾attr="attrValue"
    #| 	Âattr="attrValue"
    #| 	Ãattr="attrValue"
    #| 	˽attr="attrValue"
    #| 	˿attr="attrValue"
    #| 	Ͱattr="attrValue"
    #| 	ͱattr="attrValue"
    #| 	ͼͽattr="attrValue"
    #| 	ͽͿattr="attrValue"
    #| 	Ϳ΀attr="attrValue"
    #| 	΀῾attr="attrValue"
    #| 	῾῿attr="attrValue"
    #| 	῿‌attr="attrValue"
    #| 	‌‍attr="attrValue"
    #| 	‍⁰attr="attrValue"
    #| 	⁰ⁱattr="attrValue"
    #| 	ⁱ↎attr="attrValue"
    #| 	↎↏Ⰰattr="attrValue"
    #| 	↏ⰀⰁattr="attrValue"
    #| 	ⰀⰁ⿮attr="attrValue"
    #| 	Ⰱ⿮⿯attr="attrValue"
    #| 	⿮⿯、attr="attrValue"
    #| 	⿯、。attr="attrValue"
    #| 	、。퟾attr="attrValue"
    #| 	。퟾퟿attr="attrValue"
    #| 	퟾퟿豈attr="attrValue"
    #| 	퟿豈更attr="attrValue"
    #| 	豈퟿퟾。attr="attrValue"
    #| 	更豈퟿퟾attr="attrValue"
    #| 	�更豈퟿attr="attrValue"
    #| 	attr-�更豈="attrValue"
    #| 	attr.-�更="attrValue"
    #| 	A.-�attr="attrValue"
    #| 	zA.-attr="attrValue"
    #| 	attr0zA.="attrValue"
    #| 	attr·0zA="attrValue"
    #| 	attr̀·0z="attrValue"
    #| 	attŕ̀·0="attrValue"
    #| 	attrͮ́̀·="attrValue"
    #| 	attrͯͮ́̀="attrValue"
    #| 	attr‿ͯͮ́="attrValue"
    #| 	attr⁀‿ͯͮ="attrValue"
    #| 	null⁀‿ͯattr="attrValue"
    #| 	nullnull⁀‿attr="attrValue"
    #| 	nullnullnull⁀attr="attrValue"
    #| />
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("LegalName"),
    Comment(
      " Legal Names containing one to four characters in order from the list below  used in Attr delcs and attributes.  x003A, 0x00C0, 0x00C1, 0x02FE, 0x00C2, 0x00C3, 0x02FD, 0x02FF, 0x0370, 0x0371, 0x037C, 0x037D, 0x037F, 0x0380, 0x1FFE, 0x1FFF, 0x200C, 0x200D, 0x2070, 0x2071, 0x218E, 0x218F, 0x2C00, 0x2C01, 0x2FEE, 0x2FEF, 0x3001, 0x3002, 0xD7FE, 0xD7FF, 0xF900, 0xF901, 0xFFFD, 0x002D, 0x002E, 0x0041, 0x007A, 0x0030, 0x00B7, 0x0300, 0x0301, 0x036E, 0x036F, 0x203F, 0x2040 ",
    ),
    Start(name="LegalName", attributes={
      ":attr": "attrValue",
      "Àattr": "attrValue",
      "Áattr": "attrValue",
      "˾attr": "attrValue",
      "Âattr": "attrValue",
      "Ãattr": "attrValue",
      "˽attr": "attrValue",
      "˿attr": "attrValue",
      "Ͱattr": "attrValue",
      "ͱattr": "attrValue",
      "ͼͽattr": "attrValue",
      "ͽͿattr": "attrValue",
      "Ϳ΀attr": "attrValue",
      "΀῾attr": "attrValue",
      "῾῿attr": "attrValue",
      "῿‌attr": "attrValue",
      "‌‍attr": "attrValue",
      "‍⁰attr": "attrValue",
      "⁰ⁱattr": "attrValue",
      "ⁱ↎attr": "attrValue",
      "↎↏Ⰰattr": "attrValue",
      "↏ⰀⰁattr": "attrValue",
      "ⰀⰁ⿮attr": "attrValue",
      "Ⰱ⿮⿯attr": "attrValue",
      "⿮⿯、attr": "attrValue",
      "⿯、。attr": "attrValue",
      "、。퟾attr": "attrValue",
      "。퟾퟿attr": "attrValue",
      "퟾퟿豈attr": "attrValue",
      "퟿豈更attr": "attrValue",
      "豈퟿퟾。attr": "attrValue",
      "更豈퟿퟾attr": "attrValue",
      "�更豈퟿attr": "attrValue",
      "attr-�更豈": "attrValue",
      "attr.-�更": "attrValue",
      "A.-�attr": "attrValue",
      "zA.-attr": "attrValue",
      "attr0zA.": "attrValue",
      "attr·0zA": "attrValue",
      "attr̀·0z": "attrValue",
      "attŕ̀·0": "attrValue",
      "attrͮ́̀·": "attrValue",
      "attrͯͮ́̀": "attrValue",
      "attr‿ͯͮ́": "attrValue",
      "attr⁀‿ͯͮ": "attrValue",
      "null⁀‿ͯattr": "attrValue",
      "nullnull⁀‿attr": "attrValue",
      "nullnullnull⁀attr": "attrValue",
    }),
    End("LegalName"),
  ])
}

///|
test "w3c/valid/x_ibm_1_0_5_valid_P05_ibm05v04_xml" {
  let xml_text =
    #|<!DOCTYPE LegalName [
    #|<!ELEMENT LegalName ANY>
    #|<!ELEMENT LegalName0 ANY>
    #|<!ATTLIST LegalName0 attr0 ID #IMPLIED>
    #|<!ATTLIST LegalName0 attr00 IDREF #IMPLIED>
    #|<!ELEMENT LegalName1 ANY>
    #|<!ATTLIST LegalName1 attr1 ID #IMPLIED>
    #|<!ATTLIST LegalName1 attr10 IDREF #IMPLIED>
    #|<!ELEMENT LegalName2 ANY>
    #|<!ATTLIST LegalName2 attr2 ID #IMPLIED>
    #|<!ATTLIST LegalName2 attr20 IDREF #IMPLIED>
    #|<!ELEMENT LegalName3 ANY>
    #|<!ATTLIST LegalName3 attr3 ID #IMPLIED>
    #|<!ATTLIST LegalName3 attr30 IDREF #IMPLIED>
    #|<!ELEMENT LegalName4 ANY>
    #|<!ATTLIST LegalName4 attr4 ID #IMPLIED>
    #|<!ATTLIST LegalName4 attr40 IDREF #IMPLIED>
    #|<!ELEMENT LegalName5 ANY>
    #|<!ATTLIST LegalName5 attr5 ID #IMPLIED>
    #|<!ATTLIST LegalName5 attr50 IDREF #IMPLIED>
    #|<!ELEMENT LegalName6 ANY>
    #|<!ATTLIST LegalName6 attr6 ID #IMPLIED>
    #|<!ATTLIST LegalName6 attr60 IDREF #IMPLIED>
    #|<!ELEMENT LegalName7 ANY>
    #|<!ATTLIST LegalName7 attr7 ID #IMPLIED>
    #|<!ATTLIST LegalName7 attr70 IDREF #IMPLIED>
    #|<!ELEMENT LegalName8 ANY>
    #|<!ATTLIST LegalName8 attr8 ID #IMPLIED>
    #|<!ATTLIST LegalName8 attr80 IDREF #IMPLIED>
    #|<!ELEMENT LegalName9 ANY>
    #|<!ATTLIST LegalName9 attr9 ID #IMPLIED>
    #|<!ATTLIST LegalName9 attr90 IDREF #IMPLIED>
    #|<!ELEMENT LegalName10 ANY>
    #|<!ATTLIST LegalName10 attr10 ID #IMPLIED>
    #|<!ATTLIST LegalName10 attr100 IDREF #IMPLIED>
    #|<!ELEMENT LegalName11 ANY>
    #|<!ATTLIST LegalName11 attr11 ID #IMPLIED>
    #|<!ATTLIST LegalName11 attr110 IDREF #IMPLIED>
    #|<!ELEMENT LegalName12 ANY>
    #|<!ATTLIST LegalName12 attr12 ID #IMPLIED>
    #|<!ATTLIST LegalName12 attr120 IDREF #IMPLIED>
    #|<!ELEMENT LegalName13 ANY>
    #|<!ATTLIST LegalName13 attr13 ID #IMPLIED>
    #|<!ATTLIST LegalName13 attr130 IDREF #IMPLIED>
    #|<!ELEMENT LegalName14 ANY>
    #|<!ATTLIST LegalName14 attr14 ID #IMPLIED>
    #|<!ATTLIST LegalName14 attr140 IDREF #IMPLIED>
    #|<!ELEMENT LegalName15 ANY>
    #|<!ATTLIST LegalName15 attr15 ID #IMPLIED>
    #|<!ATTLIST LegalName15 attr150 IDREF #IMPLIED>
    #|<!ELEMENT LegalName16 ANY>
    #|<!ATTLIST LegalName16 attr16 ID #IMPLIED>
    #|<!ATTLIST LegalName16 attr160 IDREF #IMPLIED>
    #|<!ELEMENT LegalName17 ANY>
    #|<!ATTLIST LegalName17 attr17 ID #IMPLIED>
    #|<!ATTLIST LegalName17 attr170 IDREF #IMPLIED>
    #|<!ELEMENT LegalName18 ANY>
    #|<!ATTLIST LegalName18 attr18 ID #IMPLIED>
    #|<!ATTLIST LegalName18 attr180 IDREF #IMPLIED>
    #|<!ELEMENT LegalName19 ANY>
    #|<!ATTLIST LegalName19 attr19 ID #IMPLIED>
    #|<!ATTLIST LegalName19 attr190 IDREF #IMPLIED>
    #|<!ELEMENT LegalName20 ANY>
    #|<!ATTLIST LegalName20 attr20 ID #IMPLIED>
    #|<!ATTLIST LegalName20 attr200 IDREF #IMPLIED>
    #|<!ELEMENT LegalName21 ANY>
    #|<!ATTLIST LegalName21 attr21 ID #IMPLIED>
    #|<!ATTLIST LegalName21 attr210 IDREF #IMPLIED>
    #|<!ELEMENT LegalName22 ANY>
    #|<!ATTLIST LegalName22 attr22 ID #IMPLIED>
    #|<!ATTLIST LegalName22 attr220 IDREF #IMPLIED>
    #|<!ELEMENT LegalName23 ANY>
    #|<!ATTLIST LegalName23 attr23 ID #IMPLIED>
    #|<!ATTLIST LegalName23 attr230 IDREF #IMPLIED>
    #|<!ELEMENT LegalName24 ANY>
    #|<!ATTLIST LegalName24 attr24 ID #IMPLIED>
    #|<!ATTLIST LegalName24 attr240 IDREF #IMPLIED>
    #|<!ELEMENT LegalName25 ANY>
    #|<!ATTLIST LegalName25 attr25 ID #IMPLIED>
    #|<!ATTLIST LegalName25 attr250 IDREF #IMPLIED>
    #|<!ELEMENT LegalName26 ANY>
    #|<!ATTLIST LegalName26 attr26 ID #IMPLIED>
    #|<!ATTLIST LegalName26 attr260 IDREF #IMPLIED>
    #|<!ELEMENT LegalName27 ANY>
    #|<!ATTLIST LegalName27 attr27 ID #IMPLIED>
    #|<!ATTLIST LegalName27 attr270 IDREF #IMPLIED>
    #|<!ELEMENT LegalName28 ANY>
    #|<!ATTLIST LegalName28 attr28 ID #IMPLIED>
    #|<!ATTLIST LegalName28 attr280 IDREF #IMPLIED>
    #|<!ELEMENT LegalName29 ANY>
    #|<!ATTLIST LegalName29 attr29 ID #IMPLIED>
    #|<!ATTLIST LegalName29 attr290 IDREF #IMPLIED>
    #|<!ELEMENT LegalName30 ANY>
    #|<!ATTLIST LegalName30 attr30 ID #IMPLIED>
    #|<!ATTLIST LegalName30 attr300 IDREF #IMPLIED>
    #|<!ELEMENT LegalName31 ANY>
    #|<!ATTLIST LegalName31 attr31 ID #IMPLIED>
    #|<!ATTLIST LegalName31 attr310 IDREF #IMPLIED>
    #|<!ELEMENT LegalName32 ANY>
    #|<!ATTLIST LegalName32 attr32 ID #IMPLIED>
    #|<!ATTLIST LegalName32 attr320 IDREF #IMPLIED>
    #|<!ELEMENT LegalName33 ANY>
    #|<!ATTLIST LegalName33 attr33 ID #IMPLIED>
    #|<!ATTLIST LegalName33 attr330 IDREF #IMPLIED>
    #|<!ELEMENT LegalName34 ANY>
    #|<!ATTLIST LegalName34 attr34 ID #IMPLIED>
    #|<!ATTLIST LegalName34 attr340 IDREF #IMPLIED>
    #|<!ELEMENT LegalName35 ANY>
    #|<!ATTLIST LegalName35 attr35 ID #IMPLIED>
    #|<!ATTLIST LegalName35 attr350 IDREF #IMPLIED>
    #|<!ELEMENT LegalName36 ANY>
    #|<!ATTLIST LegalName36 attr36 ID #IMPLIED>
    #|<!ATTLIST LegalName36 attr360 IDREF #IMPLIED>
    #|<!ELEMENT LegalName37 ANY>
    #|<!ATTLIST LegalName37 attr37 ID #IMPLIED>
    #|<!ATTLIST LegalName37 attr370 IDREF #IMPLIED>
    #|<!ELEMENT LegalName38 ANY>
    #|<!ATTLIST LegalName38 attr38 ID #IMPLIED>
    #|<!ATTLIST LegalName38 attr380 IDREF #IMPLIED>
    #|<!ELEMENT LegalName39 ANY>
    #|<!ATTLIST LegalName39 attr39 ID #IMPLIED>
    #|<!ATTLIST LegalName39 attr390 IDREF #IMPLIED>
    #|<!ELEMENT LegalName40 ANY>
    #|<!ATTLIST LegalName40 attr40 ID #IMPLIED>
    #|<!ATTLIST LegalName40 attr400 IDREF #IMPLIED>
    #|<!ELEMENT LegalName41 ANY>
    #|<!ATTLIST LegalName41 attr41 ID #IMPLIED>
    #|<!ATTLIST LegalName41 attr410 IDREF #IMPLIED>
    #|<!ELEMENT LegalName42 ANY>
    #|<!ATTLIST LegalName42 attr42 ID #IMPLIED>
    #|<!ATTLIST LegalName42 attr420 IDREF #IMPLIED>
    #|<!ELEMENT LegalName43 ANY>
    #|<!ATTLIST LegalName43 attr43 ID #IMPLIED>
    #|<!ATTLIST LegalName43 attr430 IDREF #IMPLIED>
    #|<!ELEMENT LegalName44 ANY>
    #|<!ATTLIST LegalName44 attr44 ID #IMPLIED>
    #|<!ATTLIST LegalName44 attr440 IDREF #IMPLIED>
    #|<!ELEMENT LegalName45 ANY>
    #|<!ATTLIST LegalName45 attr45 ID #IMPLIED>
    #|<!ATTLIST LegalName45 attr450 IDREF #IMPLIED>
    #|<!ELEMENT LegalName46 ANY>
    #|<!ATTLIST LegalName46 attr46 ID #IMPLIED>
    #|<!ATTLIST LegalName46 attr460 IDREF #IMPLIED>
    #|<!ELEMENT LegalName47 ANY>
    #|<!ATTLIST LegalName47 attr47 ID #IMPLIED>
    #|<!ATTLIST LegalName47 attr470 IDREF #IMPLIED>
    #|]>
    #|<!-- Legal Names containing one to four characters in order from the list below  used in Attr delcs and attributes.  x003A, 0x00C0, 0x00C1, 0x02FE, 0x00C2, 0x00C3, 0x02FD, 0x02FF, 0x0370, 0x0371, 0x037C, 0x037D, 0x037F, 0x0380, 0x1FFE, 0x1FFF, 0x200C, 0x200D, 0x2070, 0x2071, 0x218E, 0x218F, 0x2C00, 0x2C01, 0x2FEE, 0x2FEF, 0x3001, 0x3002, 0xD7FE, 0xD7FF, 0xF900, 0xF901, 0xFFFD, 0x002D, 0x002E, 0x0041, 0x007A, 0x0030, 0x00B7, 0x0300, 0x0301, 0x036E, 0x036F, 0x203F, 0x2040 -->
    #|<LegalName>
    #| 	attr0=":" attr00=":"
    #| 	attr1="À" attr10="À"
    #| 	attr2="Á" attr20="Á"
    #| 	attr3="˾" attr30="˾"
    #| 	attr4="Â" attr40="Â"
    #| 	attr5="Ã" attr50="Ã"
    #| 	attr6="˽" attr60="˽"
    #| 	attr7="˿" attr70="˿"
    #| 	attr8="Ͱ" attr80="Ͱ"
    #| 	attr9="ͱ" attr90="ͱ"
    #| 	attr10="ͼͽ" attr100="ͼͽ"
    #| 	attr11="ͽͿ" attr110="ͽͿ"
    #| 	attr12="Ϳ΀" attr120="Ϳ΀"
    #| 	attr13="΀῾" attr130="΀῾"
    #| 	attr14="῾῿" attr140="῾῿"
    #| 	attr15="῿‌" attr150="῿‌"
    #| 	attr16="‌‍" attr160="‌‍"
    #| 	attr17="‍⁰" attr170="‍⁰"
    #| 	attr18="⁰ⁱ" attr180="⁰ⁱ"
    #| 	attr19="ⁱ↎" attr190="ⁱ↎"
    #| 	attr20="↎↏Ⰰ" attr200="↎↏Ⰰ"
    #| 	attr21="↏ⰀⰁ" attr210="↏ⰀⰁ"
    #| 	attr22="ⰀⰁ⿮" attr220="ⰀⰁ⿮"
    #| 	attr23="Ⰱ⿮⿯" attr230="Ⰱ⿮⿯"
    #| 	attr24="⿮⿯、" attr240="⿮⿯、"
    #| 	attr25="⿯、。" attr250="⿯、。"
    #| 	attr26="、。퟾" attr260="、。퟾"
    #| 	attr27="。퟾퟿" attr270="。퟾퟿"
    #| 	attr28="퟾퟿豈" attr280="퟾퟿豈"
    #| 	attr29="퟿豈更" attr290="퟿豈更"
    #| 	attr30="豈퟿퟾。" attr300="豈퟿퟾。"
    #| 	attr31="更豈퟿퟾" attr310="更豈퟿퟾"
    #| 	attr32="�更豈퟿" attr320="�更豈퟿"
    #| 	attr33="-�更豈" attr330="-�更豈"
    #| 	attr34=".-�更" attr340=".-�更"
    #| 	attr35="A.-�" attr350="A.-�"
    #| 	attr36="zA.-" attr360="zA.-"
    #| 	attr37="0zA." attr370="0zA."
    #| 	attr38="·0zA" attr380="·0zA"
    #| 	attr39="̀·0z" attr390="̀·0z"
    #| 	attr40="́̀·0" attr400="́̀·0"
    #| 	attr41="ͮ́̀·" attr410="ͮ́̀·"
    #| 	attr42="ͯͮ́̀" attr420="ͯͮ́̀"
    #| 	attr43="‿ͯͮ́" attr430="‿ͯͮ́"
    #| 	attr44="⁀‿ͯͮ" attr440="⁀‿ͯͮ"
    #| 	attr45="null⁀‿ͯ" attr450="null⁀‿ͯ"
    #| 	attr46="nullnull⁀‿" attr460="nullnull⁀‿"
    #| 	attr47="nullnullnull⁀" attr470="nullnullnull⁀"
    #|</LegalName>
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("LegalName"),
    Comment(
      " Legal Names containing one to four characters in order from the list below  used in Attr delcs and attributes.  x003A, 0x00C0, 0x00C1, 0x02FE, 0x00C2, 0x00C3, 0x02FD, 0x02FF, 0x0370, 0x0371, 0x037C, 0x037D, 0x037F, 0x0380, 0x1FFE, 0x1FFF, 0x200C, 0x200D, 0x2070, 0x2071, 0x218E, 0x218F, 0x2C00, 0x2C01, 0x2FEE, 0x2FEF, 0x3001, 0x3002, 0xD7FE, 0xD7FF, 0xF900, 0xF901, 0xFFFD, 0x002D, 0x002E, 0x0041, 0x007A, 0x0030, 0x00B7, 0x0300, 0x0301, 0x036E, 0x036F, 0x203F, 0x2040 ",
    ),
    Start(name="LegalName", attributes=Map([])),
    Text(
      "\n \tattr0=\":\" attr00=\":\"\n \tattr1=\"À\" attr10=\"À\"\n \tattr2=\"Á\" attr20=\"Á\"\n \tattr3=\"˾\" attr30=\"˾\"\n \tattr4=\"Â\" attr40=\"Â\"\n \tattr5=\"Ã\" attr50=\"Ã\"\n \tattr6=\"˽\" attr60=\"˽\"\n \tattr7=\"˿\" attr70=\"˿\"\n \tattr8=\"Ͱ\" attr80=\"Ͱ\"\n \tattr9=\"ͱ\" attr90=\"ͱ\"\n \tattr10=\"ͼͽ\" attr100=\"ͼͽ\"\n \tattr11=\"ͽͿ\" attr110=\"ͽͿ\"\n \tattr12=\"Ϳ΀\" attr120=\"Ϳ΀\"\n \tattr13=\"΀῾\" attr130=\"΀῾\"\n \tattr14=\"῾῿\" attr140=\"῾῿\"\n \tattr15=\"῿‌\" attr150=\"῿‌\"\n \tattr16=\"‌‍\" attr160=\"‌‍\"\n \tattr17=\"‍⁰\" attr170=\"‍⁰\"\n \tattr18=\"⁰ⁱ\" attr180=\"⁰ⁱ\"\n \tattr19=\"ⁱ↎\" attr190=\"ⁱ↎\"\n \tattr20=\"↎↏Ⰰ\" attr200=\"↎↏Ⰰ\"\n \tattr21=\"↏ⰀⰁ\" attr210=\"↏ⰀⰁ\"\n \tattr22=\"ⰀⰁ⿮\" attr220=\"ⰀⰁ⿮\"\n \tattr23=\"Ⰱ⿮⿯\" attr230=\"Ⰱ⿮⿯\"\n \tattr24=\"⿮⿯、\" attr240=\"⿮⿯、\"\n \tattr25=\"⿯、。\" attr250=\"⿯、。\"\n \tattr26=\"、。퟾\" attr260=\"、。퟾\"\n \tattr27=\"。퟾퟿\" attr270=\"。퟾퟿\"\n \tattr28=\"퟾퟿豈\" attr280=\"퟾퟿豈\"\n \tattr29=\"퟿豈更\" attr290=\"퟿豈更\"\n \tattr30=\"豈퟿퟾。\" attr300=\"豈퟿퟾。\"\n \tattr31=\"更豈퟿퟾\" attr310=\"更豈퟿퟾\"\n \tattr32=\"�更豈퟿\" attr320=\"�更豈퟿\"\n \tattr33=\"-�更豈\" attr330=\"-�更豈\"\n \tattr34=\".-�更\" attr340=\".-�更\"\n \tattr35=\"A.-�\" attr350=\"A.-�\"\n \tattr36=\"zA.-\" attr360=\"zA.-\"\n \tattr37=\"0zA.\" attr370=\"0zA.\"\n \tattr38=\"·0zA\" attr380=\"·0zA\"\n \tattr39=\"̀·0z\" attr390=\"̀·0z\"\n \tattr40=\"́̀·0\" attr400=\"́̀·0\"\n \tattr41=\"ͮ́̀·\" attr410=\"ͮ́̀·\"\n \tattr42=\"ͯͮ́̀\" attr420=\"ͯͮ́̀\"\n \tattr43=\"‿ͯͮ́\" attr430=\"‿ͯͮ́\"\n \tattr44=\"⁀‿ͯͮ\" attr440=\"⁀‿ͯͮ\"\n \tattr45=\"null⁀‿ͯ\" attr450=\"null⁀‿ͯ\"\n \tattr46=\"nullnull⁀‿\" attr460=\"nullnull⁀‿\"\n \tattr47=\"nullnullnull⁀\" attr470=\"nullnullnull⁀\"\n",
    ),
    End("LegalName"),
  ])
}

///|
test "w3c/valid/x_ibm_1_0_5_valid_P05_ibm05v05_xml" {
  let xml_text =
    #|<!DOCTYPE LegalName [
    #|<!ELEMENT LegalName ANY>
    #|<!ELEMENT LegalName0 ANY>
    #|<!ATTLIST LegalName0 attr0 CDATA #IMPLIED>
    #|<!ELEMENT LegalName1 ANY>
    #|<!ATTLIST LegalName1 attr1 CDATA #IMPLIED>
    #|<!ELEMENT LegalName2 ANY>
    #|<!ATTLIST LegalName2 attr2 CDATA #IMPLIED>
    #|<!ELEMENT LegalName3 ANY>
    #|<!ATTLIST LegalName3 attr3 CDATA #IMPLIED>
    #|<!ELEMENT LegalName4 ANY>
    #|<!ATTLIST LegalName4 attr4 CDATA #IMPLIED>
    #|<!ELEMENT LegalName5 ANY>
    #|<!ATTLIST LegalName5 attr5 CDATA #IMPLIED>
    #|<!ELEMENT LegalName6 ANY>
    #|<!ATTLIST LegalName6 attr6 CDATA #IMPLIED>
    #|<!ELEMENT LegalName7 ANY>
    #|<!ATTLIST LegalName7 attr7 CDATA #IMPLIED>
    #|<!ELEMENT LegalName8 ANY>
    #|<!ATTLIST LegalName8 attr8 CDATA #IMPLIED>
    #|<!ELEMENT LegalName9 ANY>
    #|<!ATTLIST LegalName9 attr9 CDATA #IMPLIED>
    #|<!ELEMENT LegalName10 ANY>
    #|<!ATTLIST LegalName10 attr10 CDATA #IMPLIED>
    #|<!ELEMENT LegalName11 ANY>
    #|<!ATTLIST LegalName11 attr11 CDATA #IMPLIED>
    #|<!ELEMENT LegalName12 ANY>
    #|<!ATTLIST LegalName12 attr12 CDATA #IMPLIED>
    #|<!ELEMENT LegalName13 ANY>
    #|<!ATTLIST LegalName13 attr13 CDATA #IMPLIED>
    #|<!ELEMENT LegalName14 ANY>
    #|<!ATTLIST LegalName14 attr14 CDATA #IMPLIED>
    #|<!ELEMENT LegalName15 ANY>
    #|<!ATTLIST LegalName15 attr15 CDATA #IMPLIED>
    #|<!ELEMENT LegalName16 ANY>
    #|<!ATTLIST LegalName16 attr16 CDATA #IMPLIED>
    #|<!ELEMENT LegalName17 ANY>
    #|<!ATTLIST LegalName17 attr17 CDATA #IMPLIED>
    #|<!ELEMENT LegalName18 ANY>
    #|<!ATTLIST LegalName18 attr18 CDATA #IMPLIED>
    #|<!ELEMENT LegalName19 ANY>
    #|<!ATTLIST LegalName19 attr19 CDATA #IMPLIED>
    #|<!ELEMENT LegalName20 ANY>
    #|<!ATTLIST LegalName20 attr20 CDATA #IMPLIED>
    #|<!ELEMENT LegalName21 ANY>
    #|<!ATTLIST LegalName21 attr21 CDATA #IMPLIED>
    #|<!ELEMENT LegalName22 ANY>
    #|<!ATTLIST LegalName22 attr22 CDATA #IMPLIED>
    #|<!ELEMENT LegalName23 ANY>
    #|<!ATTLIST LegalName23 attr23 CDATA #IMPLIED>
    #|<!ELEMENT LegalName24 ANY>
    #|<!ATTLIST LegalName24 attr24 CDATA #IMPLIED>
    #|<!ELEMENT LegalName25 ANY>
    #|<!ATTLIST LegalName25 attr25 CDATA #IMPLIED>
    #|<!ELEMENT LegalName26 ANY>
    #|<!ATTLIST LegalName26 attr26 CDATA #IMPLIED>
    #|<!ELEMENT LegalName27 ANY>
    #|<!ATTLIST LegalName27 attr27 CDATA #IMPLIED>
    #|<!ELEMENT LegalName28 ANY>
    #|<!ATTLIST LegalName28 attr28 CDATA #IMPLIED>
    #|<!ELEMENT LegalName29 ANY>
    #|<!ATTLIST LegalName29 attr29 CDATA #IMPLIED>
    #|<!ELEMENT LegalName30 ANY>
    #|<!ATTLIST LegalName30 attr30 CDATA #IMPLIED>
    #|<!ELEMENT LegalName31 ANY>
    #|<!ATTLIST LegalName31 attr31 CDATA #IMPLIED>
    #|<!ELEMENT LegalName32 ANY>
    #|<!ATTLIST LegalName32 attr32 CDATA #IMPLIED>
    #|<!ELEMENT LegalName33 ANY>
    #|<!ATTLIST LegalName33 attr33 CDATA #IMPLIED>
    #|<!ELEMENT LegalName34 ANY>
    #|<!ATTLIST LegalName34 attr34 CDATA #IMPLIED>
    #|<!ELEMENT LegalName35 ANY>
    #|<!ATTLIST LegalName35 attr35 CDATA #IMPLIED>
    #|<!ELEMENT LegalName36 ANY>
    #|<!ATTLIST LegalName36 attr36 CDATA #IMPLIED>
    #|<!ELEMENT LegalName37 ANY>
    #|<!ATTLIST LegalName37 attr37 CDATA #IMPLIED>
    #|<!ELEMENT LegalName38 ANY>
    #|<!ATTLIST LegalName38 attr38 CDATA #IMPLIED>
    #|<!ELEMENT LegalName39 ANY>
    #|<!ATTLIST LegalName39 attr39 CDATA #IMPLIED>
    #|<!ELEMENT LegalName40 ANY>
    #|<!ATTLIST LegalName40 attr40 CDATA #IMPLIED>
    #|<!ELEMENT LegalName41 ANY>
    #|<!ATTLIST LegalName41 attr41 CDATA #IMPLIED>
    #|<!ELEMENT LegalName42 ANY>
    #|<!ATTLIST LegalName42 attr42 CDATA #IMPLIED>
    #|<!ELEMENT LegalName43 ANY>
    #|<!ATTLIST LegalName43 attr43 CDATA #IMPLIED>
    #|<!ENTITY Name: "Test">
    #|<!ENTITY NameÀ "Test">
    #|<!ENTITY NameÁ "Test">
    #|<!ENTITY Name˾ "Test">
    #|<!ENTITY NameÂ "Test">
    #|<!ENTITY NameÃ "Test">
    #|<!ENTITY Name˽ "Test">
    #|<!ENTITY Name˿ "Test">
    #|<!ENTITY NameͰ "Test">
    #|<!ENTITY Nameͱ "Test">
    #|<!ENTITY Nameͼ "Test">
    #|<!ENTITY Nameͽ "Test">
    #|<!ENTITY NameͿ "Test">
    #|<!ENTITY Name΀ "Test">
    #|<!ENTITY Name῾ "Test">
    #|<!ENTITY Name῿ "Test">
    #|<!ENTITY Name‌ "Test">
    #|<!ENTITY Name‍ "Test">
    #|<!ENTITY Name⁰ "Test">
    #|<!ENTITY Nameⁱ "Test">
    #|<!ENTITY Name↎ "Test">
    #|<!ENTITY Name↏ "Test">
    #|<!ENTITY NameⰀ "Test">
    #|<!ENTITY NameⰁ "Test">
    #|<!ENTITY Name⿮ "Test">
    #|<!ENTITY Name⿯ "Test">
    #|<!ENTITY Name、 "Test">
    #|<!ENTITY Name。 "Test">
    #|<!ENTITY Name퟾ "Test">
    #|<!ENTITY Name퟿ "Test">
    #|<!ENTITY Name豈 "Test">
    #|<!ENTITY Name更 "Test">
    #|<!ENTITY Name� "Test">
    #|<!ENTITY Name- "Test">
    #|<!ENTITY Name. "Test">
    #|<!ENTITY NameA "Test">
    #|<!ENTITY Namez "Test">
    #|<!ENTITY Name0 "Test">
    #|<!ENTITY Name· "Test">
    #|<!ENTITY Namè "Test">
    #|<!ENTITY Namé "Test">
    #|<!ENTITY Nameͮ "Test">
    #|<!ENTITY Nameͯ "Test">
    #|<!ENTITY Name‿ "Test">
    #|]>
    #|<!-- Legal Names containing one to four characters in order from the list below  used in Attr delcs and attributes.  x003A, 0x00C0, 0x00C1, 0x02FE, 0x00C2, 0x00C3, 0x02FD, 0x02FF, 0x0370, 0x0371, 0x037C, 0x037D, 0x037F, 0x0380, 0x1FFE, 0x1FFF, 0x200C, 0x200D, 0x2070, 0x2071, 0x218E, 0x218F, 0x2C00, 0x2C01, 0x2FEE, 0x2FEF, 0x3001, 0x3002, 0xD7FE, 0xD7FF, 0xF900, 0xF901, 0xFFFD, 0x002D, 0x002E, 0x0041, 0x007A, 0x0030, 0x00B7, 0x0300, 0x0301, 0x036E, 0x036F, 0x203F, 0x2040 -->
    #|<LegalName>
    #|<LegalName0 attr0="Name:"	/>
    #|<LegalName1 attr1="NameÀ"	/>
    #|<LegalName2 attr2="NameÁ"	/>
    #|<LegalName3 attr3="Name˾"	/>
    #|<LegalName4 attr4="NameÂ"	/>
    #|<LegalName5 attr5="NameÃ"	/>
    #|<LegalName6 attr6="Name˽"	/>
    #|<LegalName7 attr7="Name˿"	/>
    #|<LegalName8 attr8="NameͰ"	/>
    #|<LegalName9 attr9="Nameͱ"	/>
    #|<LegalName10 attr10="Nameͼ"	/>
    #|<LegalName11 attr11="Nameͽ"	/>
    #|<LegalName12 attr12="NameͿ"	/>
    #|<LegalName13 attr13="Name΀"	/>
    #|<LegalName14 attr14="Name῾"	/>
    #|<LegalName15 attr15="Name῿"	/>
    #|<LegalName16 attr16="Name‌"	/>
    #|<LegalName17 attr17="Name‍"	/>
    #|<LegalName18 attr18="Name⁰"	/>
    #|<LegalName19 attr19="Nameⁱ"	/>
    #|<LegalName20 attr20="Name↎"	/>
    #|<LegalName21 attr21="Name↏"	/>
    #|<LegalName22 attr22="NameⰀ"	/>
    #|<LegalName23 attr23="NameⰁ"	/>
    #|<LegalName24 attr24="Name⿮"	/>
    #|<LegalName25 attr25="Name⿯"	/>
    #|<LegalName26 attr26="Name、"	/>
    #|<LegalName27 attr27="Name。"	/>
    #|<LegalName28 attr28="Name퟾"	/>
    #|<LegalName29 attr29="Name퟿"	/>
    #|<LegalName30 attr30="Name豈"	/>
    #|<LegalName31 attr31="Name更"	/>
    #|<LegalName32 attr32="Name�"	/>
    #|<LegalName33 attr33="Name-"	/>
    #|<LegalName34 attr34="Name."	/>
    #|<LegalName35 attr35="NameA"	/>
    #|<LegalName36 attr36="Namez"	/>
    #|<LegalName37 attr37="Name0"	/>
    #|<LegalName38 attr38="Name·"	/>
    #|<LegalName39 attr39="Namè"	/>
    #|<LegalName40 attr40="Namé"	/>
    #|<LegalName41 attr41="Nameͮ"	/>
    #|<LegalName42 attr42="Nameͯ"	/>
    #|<LegalName43 attr43="Name‿"	/>
    #|</LegalName>
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("LegalName"),
    Comment(
      " Legal Names containing one to four characters in order from the list below  used in Attr delcs and attributes.  x003A, 0x00C0, 0x00C1, 0x02FE, 0x00C2, 0x00C3, 0x02FD, 0x02FF, 0x0370, 0x0371, 0x037C, 0x037D, 0x037F, 0x0380, 0x1FFE, 0x1FFF, 0x200C, 0x200D, 0x2070, 0x2071, 0x218E, 0x218F, 0x2C00, 0x2C01, 0x2FEE, 0x2FEF, 0x3001, 0x3002, 0xD7FE, 0xD7FF, 0xF900, 0xF901, 0xFFFD, 0x002D, 0x002E, 0x0041, 0x007A, 0x0030, 0x00B7, 0x0300, 0x0301, 0x036E, 0x036F, 0x203F, 0x2040 ",
    ),
    Start(name="LegalName", attributes=Map([])),
    Text("\n"),
    Start(name="LegalName0", attributes={ "attr0": "Name:" }),
    End("LegalName0"),
    Text("\n"),
    Start(name="LegalName1", attributes={ "attr1": "NameÀ" }),
    End("LegalName1"),
    Text("\n"),
    Start(name="LegalName2", attributes={ "attr2": "NameÁ" }),
    End("LegalName2"),
    Text("\n"),
    Start(name="LegalName3", attributes={ "attr3": "Name˾" }),
    End("LegalName3"),
    Text("\n"),
    Start(name="LegalName4", attributes={ "attr4": "NameÂ" }),
    End("LegalName4"),
    Text("\n"),
    Start(name="LegalName5", attributes={ "attr5": "NameÃ" }),
    End("LegalName5"),
    Text("\n"),
    Start(name="LegalName6", attributes={ "attr6": "Name˽" }),
    End("LegalName6"),
    Text("\n"),
    Start(name="LegalName7", attributes={ "attr7": "Name˿" }),
    End("LegalName7"),
    Text("\n"),
    Start(name="LegalName8", attributes={ "attr8": "NameͰ" }),
    End("LegalName8"),
    Text("\n"),
    Start(name="LegalName9", attributes={ "attr9": "Nameͱ" }),
    End("LegalName9"),
    Text("\n"),
    Start(name="LegalName10", attributes={ "attr10": "Nameͼ" }),
    End("LegalName10"),
    Text("\n"),
    Start(name="LegalName11", attributes={ "attr11": "Nameͽ" }),
    End("LegalName11"),
    Text("\n"),
    Start(name="LegalName12", attributes={ "attr12": "NameͿ" }),
    End("LegalName12"),
    Text("\n"),
    Start(name="LegalName13", attributes={ "attr13": "Name΀" }),
    End("LegalName13"),
    Text("\n"),
    Start(name="LegalName14", attributes={ "attr14": "Name῾" }),
    End("LegalName14"),
    Text("\n"),
    Start(name="LegalName15", attributes={ "attr15": "Name῿" }),
    End("LegalName15"),
    Text("\n"),
    Start(name="LegalName16", attributes={ "attr16": "Name‌" }),
    End("LegalName16"),
    Text("\n"),
    Start(name="LegalName17", attributes={ "attr17": "Name‍" }),
    End("LegalName17"),
    Text("\n"),
    Start(name="LegalName18", attributes={ "attr18": "Name⁰" }),
    End("LegalName18"),
    Text("\n"),
    Start(name="LegalName19", attributes={ "attr19": "Nameⁱ" }),
    End("LegalName19"),
    Text("\n"),
    Start(name="LegalName20", attributes={ "attr20": "Name↎" }),
    End("LegalName20"),
    Text("\n"),
    Start(name="LegalName21", attributes={ "attr21": "Name↏" }),
    End("LegalName21"),
    Text("\n"),
    Start(name="LegalName22", attributes={ "attr22": "NameⰀ" }),
    End("LegalName22"),
    Text("\n"),
    Start(name="LegalName23", attributes={ "attr23": "NameⰁ" }),
    End("LegalName23"),
    Text("\n"),
    Start(name="LegalName24", attributes={ "attr24": "Name⿮" }),
    End("LegalName24"),
    Text("\n"),
    Start(name="LegalName25", attributes={ "attr25": "Name⿯" }),
    End("LegalName25"),
    Text("\n"),
    Start(name="LegalName26", attributes={ "attr26": "Name、" }),
    End("LegalName26"),
    Text("\n"),
    Start(name="LegalName27", attributes={ "attr27": "Name。" }),
    End("LegalName27"),
    Text("\n"),
    Start(name="LegalName28", attributes={ "attr28": "Name퟾" }),
    End("LegalName28"),
    Text("\n"),
    Start(name="LegalName29", attributes={ "attr29": "Name퟿" }),
    End("LegalName29"),
    Text("\n"),
    Start(name="LegalName30", attributes={ "attr30": "Name豈" }),
    End("LegalName30"),
    Text("\n"),
    Start(name="LegalName31", attributes={ "attr31": "Name更" }),
    End("LegalName31"),
    Text("\n"),
    Start(name="LegalName32", attributes={ "attr32": "Name�" }),
    End("LegalName32"),
    Text("\n"),
    Start(name="LegalName33", attributes={ "attr33": "Name-" }),
    End("LegalName33"),
    Text("\n"),
    Start(name="LegalName34", attributes={ "attr34": "Name." }),
    End("LegalName34"),
    Text("\n"),
    Start(name="LegalName35", attributes={ "attr35": "NameA" }),
    End("LegalName35"),
    Text("\n"),
    Start(name="LegalName36", attributes={ "attr36": "Namez" }),
    End("LegalName36"),
    Text("\n"),
    Start(name="LegalName37", attributes={ "attr37": "Name0" }),
    End("LegalName37"),
    Text("\n"),
    Start(name="LegalName38", attributes={ "attr38": "Name·" }),
    End("LegalName38"),
    Text("\n"),
    Start(name="LegalName39", attributes={ "attr39": "Namè" }),
    End("LegalName39"),
    Text("\n"),
    Start(name="LegalName40", attributes={ "attr40": "Namé" }),
    End("LegalName40"),
    Text("\n"),
    Start(name="LegalName41", attributes={ "attr41": "Nameͮ" }),
    End("LegalName41"),
    Text("\n"),
    Start(name="LegalName42", attributes={ "attr42": "Nameͯ" }),
    End("LegalName42"),
    Text("\n"),
    Start(name="LegalName43", attributes={ "attr43": "Name‿" }),
    End("LegalName43"),
    Text("\n"),
    End("LegalName"),
  ])
}

///|
test "w3c/valid/x_ibm_1_0_5_valid_P047_ibm07v01_xml" {
  let xml_text =
    #|<!DOCTYPE NMtokenName [
    #|<!ELEMENT NMtokenName ANY>
    #|<!ATTLIST NMtokenName thistoken0 NMTOKEN #IMPLIED>
    #|<!ATTLIST NMtokenName thistoken1 NMTOKEN #IMPLIED>
    #|<!ATTLIST NMtokenName thistoken2 NMTOKEN #IMPLIED>
    #|<!ATTLIST NMtokenName thistoken3 NMTOKEN #IMPLIED>
    #|<!ATTLIST NMtokenName thistoken4 NMTOKEN #IMPLIED>
    #|<!ATTLIST NMtokenName thistoken5 NMTOKEN #IMPLIED>
    #|<!ATTLIST NMtokenName thistoken6 NMTOKEN #IMPLIED>
    #|<!ATTLIST NMtokenName thistoken7 NMTOKEN #IMPLIED>
    #|<!ATTLIST NMtokenName thistoken8 NMTOKEN #IMPLIED>
    #|<!ATTLIST NMtokenName thistoken9 NMTOKEN #IMPLIED>
    #|<!ATTLIST NMtokenName thistoken10 NMTOKEN #IMPLIED>
    #|<!ATTLIST NMtokenName thistoken11 NMTOKEN #IMPLIED>
    #|<!ATTLIST NMtokenName thistoken12 NMTOKEN #IMPLIED>
    #|<!ATTLIST NMtokenName thistoken13 NMTOKEN #IMPLIED>
    #|<!ATTLIST NMtokenName thistoken14 NMTOKEN #IMPLIED>
    #|<!ATTLIST NMtokenName thistoken15 NMTOKEN #IMPLIED>
    #|<!ATTLIST NMtokenName thistoken16 NMTOKEN #IMPLIED>
    #|<!ATTLIST NMtokenName thistoken17 NMTOKEN #IMPLIED>
    #|<!ATTLIST NMtokenName thistoken18 NMTOKEN #IMPLIED>
    #|<!ATTLIST NMtokenName thistoken19 NMTOKEN #IMPLIED>
    #|<!ATTLIST NMtokenName thistoken20 NMTOKEN #IMPLIED>
    #|<!ATTLIST NMtokenName thistoken21 NMTOKEN #IMPLIED>
    #|<!ATTLIST NMtokenName thistoken22 NMTOKEN #IMPLIED>
    #|<!ATTLIST NMtokenName thistoken23 NMTOKEN #IMPLIED>
    #|<!ATTLIST NMtokenName thistoken24 NMTOKEN #IMPLIED>
    #|<!ATTLIST NMtokenName thistoken25 NMTOKEN #IMPLIED>
    #|<!ATTLIST NMtokenName thistoken26 NMTOKEN #IMPLIED>
    #|<!ATTLIST NMtokenName thistoken27 NMTOKEN #IMPLIED>
    #|<!ATTLIST NMtokenName thistoken28 NMTOKEN #IMPLIED>
    #|<!ATTLIST NMtokenName thistoken29 NMTOKEN #IMPLIED>
    #|<!ATTLIST NMtokenName thistoken30 NMTOKEN #IMPLIED>
    #|<!ATTLIST NMtokenName thistoken31 NMTOKEN #IMPLIED>
    #|<!ATTLIST NMtokenName thistoken32 NMTOKEN #IMPLIED>
    #|<!ATTLIST NMtokenName thistoken33 NMTOKEN #IMPLIED>
    #|<!ATTLIST NMtokenName thistoken34 NMTOKEN #IMPLIED>
    #|<!ATTLIST NMtokenName thistoken35 NMTOKEN #IMPLIED>
    #|<!ATTLIST NMtokenName thistoken36 NMTOKEN #IMPLIED>
    #|<!ATTLIST NMtokenName thistoken37 NMTOKEN #IMPLIED>
    #|]>
    #|<!-- LegalNameChar  0x300,0x333,0x369,0x37E,0x2000,0x2001,0x2002,0x2005,0x200B,0x200E,x200F,0x2069,0x2190,0x23FF,0x280F,0x2A00,0x2EDC,0x2FED,0x2FFF,0x3000,0xD800,0xD801,0xDAFF,0xDFFF,0xEFFF,0xF1FF,0xF8FF,0xFFFFF; _, ., 0, B7, C0, 2FFF in P07 -->
    #|<NMtokenName  thistoken0=":"
    #| thistoken1="À"
    #| thistoken2="Á"
    #| thistoken3="˾"
    #| thistoken4="À"
    #| thistoken5="Á"
    #| thistoken6="˾"
    #| thistoken7="˿"
    #| thistoken8="Ͱ"
    #| thistoken9="ͱ"
    #| thistoken10="ͼ"
    #| thistoken11="ͽ"
    #| thistoken12="Ϳ"
    #| thistoken13="΀"
    #| thistoken14="῾"
    #| thistoken15="῿"
    #| thistoken16="‌"
    #| thistoken17="‍"
    #| thistoken18="⁰"
    #| thistoken19="ⁱ"
    #| thistoken20="↎"
    #| thistoken21="↏"
    #| thistoken22="Ⰰ"
    #| thistoken23="Ⰱ"
    #| thistoken24="⿮"
    #| thistoken25="⿯"
    #| thistoken26="、"
    #| thistoken27="。"
    #| thistoken28="퟾"
    #| thistoken29="퟿"
    #| thistoken30="豈"
    #| thistoken31="更"
    #| thistoken32="_"
    #| thistoken33="."
    #| thistoken34="0"
    #| thistoken35="·"
    #| thistoken36="À"
    #| thistoken37="ͼ"
    #| />
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("NMtokenName"),
    Comment(
      " LegalNameChar  0x300,0x333,0x369,0x37E,0x2000,0x2001,0x2002,0x2005,0x200B,0x200E,x200F,0x2069,0x2190,0x23FF,0x280F,0x2A00,0x2EDC,0x2FED,0x2FFF,0x3000,0xD800,0xD801,0xDAFF,0xDFFF,0xEFFF,0xF1FF,0xF8FF,0xFFFFF; _, ., 0, B7, C0, 2FFF in P07 ",
    ),
    Start(name="NMtokenName", attributes={
      "thistoken0": ":",
      "thistoken1": "À",
      "thistoken2": "Á",
      "thistoken3": "˾",
      "thistoken4": "À",
      "thistoken5": "Á",
      "thistoken6": "˾",
      "thistoken7": "˿",
      "thistoken8": "Ͱ",
      "thistoken9": "ͱ",
      "thistoken10": "ͼ",
      "thistoken11": "ͽ",
      "thistoken12": "Ϳ",
      "thistoken13": "΀",
      "thistoken14": "῾",
      "thistoken15": "῿",
      "thistoken16": "‌",
      "thistoken17": "‍",
      "thistoken18": "⁰",
      "thistoken19": "ⁱ",
      "thistoken20": "↎",
      "thistoken21": "↏",
      "thistoken22": "Ⰰ",
      "thistoken23": "Ⰱ",
      "thistoken24": "⿮",
      "thistoken25": "⿯",
      "thistoken26": "、",
      "thistoken27": "。",
      "thistoken28": "퟾",
      "thistoken29": "퟿",
      "thistoken30": "豈",
      "thistoken31": "更",
      "thistoken32": "_",
      "thistoken33": ".",
      "thistoken34": "0",
      "thistoken35": "·",
      "thistoken36": "À",
      "thistoken37": "ͼ",
    }),
    End("NMtokenName"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n03_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?Ĳ an only legal per 5th edition char #x132
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="Ĳ",
      data="an only legal per 5th edition char #x132\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n04_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?ĳ an only legal per 5th edition char #x133
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="ĳ",
      data="an only legal per 5th edition char #x133\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n05_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?Ŀ an only legal per 5th edition char #x13f
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="Ŀ",
      data="an only legal per 5th edition char #x13f\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n06_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?ŀ an only legal per 5th edition char #x140
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="ŀ",
      data="an only legal per 5th edition char #x140\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n07_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?ŉ an only legal per 5th edition char #x149
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="ŉ",
      data="an only legal per 5th edition char #x149\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n08_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?ſ an only legal per 5th edition char #x17f
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="ſ",
      data="an only legal per 5th edition char #x17f\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n09_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?Ǆ an only legal per 5th edition char #x1c4
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="Ǆ",
      data="an only legal per 5th edition char #x1c4\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n10_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?ǌ an only legal per 5th edition char #x1cc
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="ǌ",
      data="an only legal per 5th edition char #x1cc\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n100_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?ஶ an only legal per 5th edition char #x0bb6
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="ஶ",
      data="an only legal per 5th edition char #x0bb6\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n101_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?஺ an only legal per 5th edition char #x0bba
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="஺",
      data="an only legal per 5th edition char #x0bba\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n102_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?఍ an only legal per 5th edition char #x0c0d
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="఍",
      data="an only legal per 5th edition char #x0c0d\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n103_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?఑ an only legal per 5th edition char #x0c11
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="఑",
      data="an only legal per 5th edition char #x0c11\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n104_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?఩ an only legal per 5th edition char #x0c29
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="఩",
      data="an only legal per 5th edition char #x0c29\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n105_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?ఴ an only legal per 5th edition char #x0c34
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="ఴ",
      data="an only legal per 5th edition char #x0c34\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n106_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?౟ an only legal per 5th edition char #x0c5f
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="౟",
      data="an only legal per 5th edition char #x0c5f\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n107_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?ౢ an only legal per 5th edition char #x0c62
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="ౢ",
      data="an only legal per 5th edition char #x0c62\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n108_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?಍ an only legal per 5th edition char #x0c8d
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="಍",
      data="an only legal per 5th edition char #x0c8d\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n109_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?಑ an only legal per 5th edition char #x0c91
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="಑",
      data="an only legal per 5th edition char #x0c91\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n11_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?Ǳ an only legal per 5th edition char #x1f1
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="Ǳ",
      data="an only legal per 5th edition char #x1f1\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n110_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?಩ an only legal per 5th edition char #x0ca9
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="಩",
      data="an only legal per 5th edition char #x0ca9\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n111_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?಴ an only legal per 5th edition char #x0cb4
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="಴",
      data="an only legal per 5th edition char #x0cb4\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n112_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?಺ an only legal per 5th edition char #x0cba
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="಺",
      data="an only legal per 5th edition char #x0cba\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n113_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?೟ an only legal per 5th edition char #x0cdf
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="೟",
      data="an only legal per 5th edition char #x0cdf\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n114_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?ೢ an only legal per 5th edition char #x0ce2
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="ೢ",
      data="an only legal per 5th edition char #x0ce2\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n115_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?഍ an only legal per 5th edition char #x0d0d
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="഍",
      data="an only legal per 5th edition char #x0d0d\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n116_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?഑ an only legal per 5th edition char #x0d11
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="഑",
      data="an only legal per 5th edition char #x0d11\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n117_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?ഩ an only legal per 5th edition char #x0d29
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="ഩ",
      data="an only legal per 5th edition char #x0d29\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n118_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?ഺ an only legal per 5th edition char #x0d3a
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="ഺ",
      data="an only legal per 5th edition char #x0d3a\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n119_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?ൢ an only legal per 5th edition char #x0d62
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="ൢ",
      data="an only legal per 5th edition char #x0d62\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n12_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?ǳ an only legal per 5th edition char #x1f3
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="ǳ",
      data="an only legal per 5th edition char #x1f3\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n120_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?ฯ an only legal per 5th edition char #x0e2f
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="ฯ",
      data="an only legal per 5th edition char #x0e2f\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n121_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?ั an only legal per 5th edition char #x0e31
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="ั",
      data="an only legal per 5th edition char #x0e31\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n122_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?ิ an only legal per 5th edition char #x0e34
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="ิ",
      data="an only legal per 5th edition char #x0e34\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n123_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?ๆ an only legal per 5th edition char #x0e46
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="ๆ",
      data="an only legal per 5th edition char #x0e46\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n124_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?຃ an only legal per 5th edition char #x0e83
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="຃",
      data="an only legal per 5th edition char #x0e83\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n125_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?຅ an only legal per 5th edition char #x0e85
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="຅",
      data="an only legal per 5th edition char #x0e85\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n126_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?ຉ an only legal per 5th edition char #x0e89
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="ຉ",
      data="an only legal per 5th edition char #x0e89\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n127_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?຋ an only legal per 5th edition char #x0e8b
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="຋",
      data="an only legal per 5th edition char #x0e8b\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n128_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?ຎ an only legal per 5th edition char #x0e8e
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="ຎ",
      data="an only legal per 5th edition char #x0e8e\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n129_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?ຘ an only legal per 5th edition char #x0e98
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="ຘ",
      data="an only legal per 5th edition char #x0e98\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n13_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?Ƕ an only legal per 5th edition char #x1f6
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="Ƕ",
      data="an only legal per 5th edition char #x1f6\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n130_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?ຠ an only legal per 5th edition char #x0ea0
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="ຠ",
      data="an only legal per 5th edition char #x0ea0\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n131_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?຤ an only legal per 5th edition char #x0ea4
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="຤",
      data="an only legal per 5th edition char #x0ea4\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n132_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?຦ an only legal per 5th edition char #x0ea6
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="຦",
      data="an only legal per 5th edition char #x0ea6\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n133_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?ຨ an only legal per 5th edition char #x0ea8
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="ຨ",
      data="an only legal per 5th edition char #x0ea8\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n134_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?ຬ an only legal per 5th edition char #x0eac
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="ຬ",
      data="an only legal per 5th edition char #x0eac\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n135_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?ຯ an only legal per 5th edition char #x0eaf
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="ຯ",
      data="an only legal per 5th edition char #x0eaf\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n136_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?ັ an only legal per 5th edition char #x0eb1
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="ັ",
      data="an only legal per 5th edition char #x0eb1\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n137_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?ິ an only legal per 5th edition char #x0eb4
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="ິ",
      data="an only legal per 5th edition char #x0eb4\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n138_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?຾ an only legal per 5th edition char #x0ebe
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="຾",
      data="an only legal per 5th edition char #x0ebe\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n139_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?໅ an only legal per 5th edition char #x0ec5
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="໅",
      data="an only legal per 5th edition char #x0ec5\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n14_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?ǹ an only legal per 5th edition char #x1f9
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="ǹ",
      data="an only legal per 5th edition char #x1f9\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n140_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?཈ an only legal per 5th edition char #x0f48
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="཈",
      data="an only legal per 5th edition char #x0f48\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n141_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?ཪ an only legal per 5th edition char #x0f6a
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="ཪ",
      data="an only legal per 5th edition char #x0f6a\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n142_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?჆ an only legal per 5th edition char #x10c6
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="჆",
      data="an only legal per 5th edition char #x10c6\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n143_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?ჷ an only legal per 5th edition char #x10f7
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="ჷ",
      data="an only legal per 5th edition char #x10f7\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n144_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?ᄁ an only legal per 5th edition char #x1101
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="ᄁ",
      data="an only legal per 5th edition char #x1101\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n145_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?ᄄ an only legal per 5th edition char #x1104
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="ᄄ",
      data="an only legal per 5th edition char #x1104\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n146_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?ᄈ an only legal per 5th edition char #x1108
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="ᄈ",
      data="an only legal per 5th edition char #x1108\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n147_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?ᄊ an only legal per 5th edition char #x110a
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="ᄊ",
      data="an only legal per 5th edition char #x110a\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n148_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?ᄍ an only legal per 5th edition char #x110d
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="ᄍ",
      data="an only legal per 5th edition char #x110d\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n149_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?ᄻ an only legal per 5th edition char #x113b
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="ᄻ",
      data="an only legal per 5th edition char #x113b\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n15_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?ǹ an only legal per 5th edition char #x1f9
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="ǹ",
      data="an only legal per 5th edition char #x1f9\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n150_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?ᄿ an only legal per 5th edition char #x113f
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="ᄿ",
      data="an only legal per 5th edition char #x113f\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n151_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?ᅁ an only legal per 5th edition char #x1141
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="ᅁ",
      data="an only legal per 5th edition char #x1141\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n152_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?ᅍ an only legal per 5th edition char #x114d
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="ᅍ",
      data="an only legal per 5th edition char #x114d\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n153_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?ᅏ an only legal per 5th edition char #x114f
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="ᅏ",
      data="an only legal per 5th edition char #x114f\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n154_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?ᅑ an only legal per 5th edition char #x1151
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="ᅑ",
      data="an only legal per 5th edition char #x1151\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n155_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?ᅖ an only legal per 5th edition char #x1156
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="ᅖ",
      data="an only legal per 5th edition char #x1156\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n156_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?ᅚ an only legal per 5th edition char #x115a
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="ᅚ",
      data="an only legal per 5th edition char #x115a\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n157_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?ᅢ an only legal per 5th edition char #x1162
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="ᅢ",
      data="an only legal per 5th edition char #x1162\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n158_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?ᅤ an only legal per 5th edition char #x1164
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="ᅤ",
      data="an only legal per 5th edition char #x1164\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n159_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?ᅦ an only legal per 5th edition char #x1166
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="ᅦ",
      data="an only legal per 5th edition char #x1166\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n16_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?Ȱ an only legal per 5th edition char #x230
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="Ȱ",
      data="an only legal per 5th edition char #x230\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n160_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?ᅫ an only legal per 5th edition char #x116b
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="ᅫ",
      data="an only legal per 5th edition char #x116b\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n161_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?ᅯ an only legal per 5th edition char #x116f
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="ᅯ",
      data="an only legal per 5th edition char #x116f\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n162_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?ᅴ an only legal per 5th edition char #x1174
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="ᅴ",
      data="an only legal per 5th edition char #x1174\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n163_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?ᆟ an only legal per 5th edition char #x119f
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="ᆟ",
      data="an only legal per 5th edition char #x119f\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n164_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?ᆬ an only legal per 5th edition char #x11ac
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="ᆬ",
      data="an only legal per 5th edition char #x11ac\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n165_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?ᆶ an only legal per 5th edition char #x11b6
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="ᆶ",
      data="an only legal per 5th edition char #x11b6\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n166_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?ᆹ an only legal per 5th edition char #x11b9
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="ᆹ",
      data="an only legal per 5th edition char #x11b9\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n167_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?ᆻ an only legal per 5th edition char #x11bb
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="ᆻ",
      data="an only legal per 5th edition char #x11bb\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n168_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?ᇃ an only legal per 5th edition char #x11c3
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="ᇃ",
      data="an only legal per 5th edition char #x11c3\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n169_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?ᇱ an only legal per 5th edition char #x11f1
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="ᇱ",
      data="an only legal per 5th edition char #x11f1\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n17_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?ʯ an only legal per 5th edition char #x2af
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="ʯ",
      data="an only legal per 5th edition char #x2af\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n170_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?ᇺ an only legal per 5th edition char #x11fa
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="ᇺ",
      data="an only legal per 5th edition char #x11fa\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n171_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?ẜ an only legal per 5th edition char #x1e9c
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="ẜ",
      data="an only legal per 5th edition char #x1e9c\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n172_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?Ỻ an only legal per 5th edition char #x1efa
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="Ỻ",
      data="an only legal per 5th edition char #x1efa\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n173_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?἖ an only legal per 5th edition char #x1f16
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="἖",
      data="an only legal per 5th edition char #x1f16\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n174_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?἞ an only legal per 5th edition char #x1f1e
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="἞",
      data="an only legal per 5th edition char #x1f1e\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n175_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?὆ an only legal per 5th edition char #x1f46
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="὆",
      data="an only legal per 5th edition char #x1f46\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n176_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?὏ an only legal per 5th edition char #x1f4f
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="὏",
      data="an only legal per 5th edition char #x1f4f\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n177_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?὘ an only legal per 5th edition char #x1f58
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="὘",
      data="an only legal per 5th edition char #x1f58\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n178_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?὚ an only legal per 5th edition char #x1f5a
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="὚",
      data="an only legal per 5th edition char #x1f5a\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n179_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?὜ an only legal per 5th edition char #x1f5c
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="὜",
      data="an only legal per 5th edition char #x1f5c\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n18_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?ˏ an only legal per 5th edition char #x2cf
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="ˏ",
      data="an only legal per 5th edition char #x2cf\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n180_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?὞ an only legal per 5th edition char #x1f5e
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="὞",
      data="an only legal per 5th edition char #x1f5e\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n181_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?὾ an only legal per 5th edition char #x1f7e
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="὾",
      data="an only legal per 5th edition char #x1f7e\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n182_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?᾵ an only legal per 5th edition char #x1fb5
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="᾵",
      data="an only legal per 5th edition char #x1fb5\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n183_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?᾽ an only legal per 5th edition char #x1fbd
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="᾽",
      data="an only legal per 5th edition char #x1fbd\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n184_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?᾿ an only legal per 5th edition char #x1fbf
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="᾿",
      data="an only legal per 5th edition char #x1fbf\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n185_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?῅ an only legal per 5th edition char #x1fc5
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="῅",
      data="an only legal per 5th edition char #x1fc5\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n186_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?῍ an only legal per 5th edition char #x1fcd
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="῍",
      data="an only legal per 5th edition char #x1fcd\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n187_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?῕ an only legal per 5th edition char #x1fd5
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="῕",
      data="an only legal per 5th edition char #x1fd5\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n188_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?῜ an only legal per 5th edition char #x1fdc
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="῜",
      data="an only legal per 5th edition char #x1fdc\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n189_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?῭ an only legal per 5th edition char #x1fed
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="῭",
      data="an only legal per 5th edition char #x1fed\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n19_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?· an only legal per 5th edition char #x387
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="·",
      data="an only legal per 5th edition char #x387\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n190_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?῵ an only legal per 5th edition char #x1ff5
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="῵",
      data="an only legal per 5th edition char #x1ff5\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n191_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?´ an only legal per 5th edition char #x1ffd
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="´",
      data="an only legal per 5th edition char #x1ffd\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n192_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?℧ an only legal per 5th edition char #x2127
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="℧",
      data="an only legal per 5th edition char #x2127\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n193_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?ℯ an only legal per 5th edition char #x212f
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="ℯ",
      data="an only legal per 5th edition char #x212f\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n194_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?Ↄ an only legal per 5th edition char #x2183
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="Ↄ",
      data="an only legal per 5th edition char #x2183\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n195_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?ゕ an only legal per 5th edition char #x3095
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="ゕ",
      data="an only legal per 5th edition char #x3095\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n196_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?・ an only legal per 5th edition char #x30fb
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="・",
      data="an only legal per 5th edition char #x30fb\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n197_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?ㄭ an only legal per 5th edition char #x312d
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="ㄭ",
      data="an only legal per 5th edition char #x312d\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n198_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?힤 an only legal per 5th edition char #xd7a4
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="힤",
      data="an only legal per 5th edition char #xd7a4\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n20_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?΋ an only legal per 5th edition char #x38b
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="΋",
      data="an only legal per 5th edition char #x38b\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n21_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?΢ an only legal per 5th edition char #x3a2
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="΢",
      data="an only legal per 5th edition char #x3a2\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n22_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?Ϗ an only legal per 5th edition char #x3cf
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="Ϗ",
      data="an only legal per 5th edition char #x3cf\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n23_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?ϗ an only legal per 5th edition char #x3d7
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="ϗ",
      data="an only legal per 5th edition char #x3d7\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n24_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?ϝ an only legal per 5th edition char #x3dd
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="ϝ",
      data="an only legal per 5th edition char #x3dd\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n25_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?ϡ an only legal per 5th edition char #x3e1
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="ϡ",
      data="an only legal per 5th edition char #x3e1\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n26_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?ϴ an only legal per 5th edition char #x3f4
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="ϴ",
      data="an only legal per 5th edition char #x3f4\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n27_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?Ѝ an only legal per 5th edition char #x40d
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="Ѝ",
      data="an only legal per 5th edition char #x40d\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n28_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?ѐ an only legal per 5th edition char #x450
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="ѐ",
      data="an only legal per 5th edition char #x450\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n29_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?ѝ an only legal per 5th edition char #x45d
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="ѝ",
      data="an only legal per 5th edition char #x45d\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n30_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?҂ an only legal per 5th edition char #x482
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="҂",
      data="an only legal per 5th edition char #x482\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n31_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?Ӆ an only legal per 5th edition char #x4c5
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="Ӆ",
      data="an only legal per 5th edition char #x4c5\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n32_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?ӆ an only legal per 5th edition char #x4c6
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="ӆ",
      data="an only legal per 5th edition char #x4c6\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n33_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?Ӊ an only legal per 5th edition char #x4c9
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="Ӊ",
      data="an only legal per 5th edition char #x4c9\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n34_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?Ӭ an only legal per 5th edition char #x4ec
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="Ӭ",
      data="an only legal per 5th edition char #x4ec\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n35_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?ӭ an only legal per 5th edition char #x4ed
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="ӭ",
      data="an only legal per 5th edition char #x4ed\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n36_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?Ӷ an only legal per 5th edition char #x4f6
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="Ӷ",
      data="an only legal per 5th edition char #x4f6\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n37_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?Ӻ an only legal per 5th edition char #x4fa
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="Ӻ",
      data="an only legal per 5th edition char #x4fa\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n38_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?՗ an only legal per 5th edition char #x557
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="՗",
      data="an only legal per 5th edition char #x557\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n39_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?՘ an only legal per 5th edition char #x558
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="՘",
      data="an only legal per 5th edition char #x558\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n40_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?և an only legal per 5th edition char #x587
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="և",
      data="an only legal per 5th edition char #x587\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n41_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?׫ an only legal per 5th edition char #x5eb
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="׫",
      data="an only legal per 5th edition char #x5eb\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n42_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?׳ an only legal per 5th edition char #x5f3
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="׳",
      data="an only legal per 5th edition char #x5f3\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n43_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?ؠ an only legal per 5th edition char #x620
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="ؠ",
      data="an only legal per 5th edition char #x620\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n44_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?ػ an only legal per 5th edition char #x63b
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="ػ",
      data="an only legal per 5th edition char #x63b\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n45_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?ً an only legal per 5th edition char #x64b
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="ً",
      data="an only legal per 5th edition char #x64b\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n46_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?ڸ an only legal per 5th edition char #x6b8
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="ڸ",
      data="an only legal per 5th edition char #x6b8\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n47_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?ڿ an only legal per 5th edition char #x6bf
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="ڿ",
      data="an only legal per 5th edition char #x6bf\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n48_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?ۏ an only legal per 5th edition char #x6cf
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="ۏ",
      data="an only legal per 5th edition char #x6cf\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n49_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?۔ an only legal per 5th edition char #x6d4
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="۔",
      data="an only legal per 5th edition char #x6d4\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n50_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?ۖ an only legal per 5th edition char #x6d6
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="ۖ",
      data="an only legal per 5th edition char #x6d6\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n51_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?ۧ an only legal per 5th edition char #x6e7
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="ۧ",
      data="an only legal per 5th edition char #x6e7\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n52_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?ऺ an only legal per 5th edition char #x093a
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="ऺ",
      data="an only legal per 5th edition char #x093a\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n53_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?ा an only legal per 5th edition char #x093e
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="ा",
      data="an only legal per 5th edition char #x093e\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n54_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?ॢ an only legal per 5th edition char #x0962
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="ॢ",
      data="an only legal per 5th edition char #x0962\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n55_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?঍ an only legal per 5th edition char #x098d
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="঍",
      data="an only legal per 5th edition char #x098d\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n56_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?঑ an only legal per 5th edition char #x0991
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="঑",
      data="an only legal per 5th edition char #x0991\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n57_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?঒ an only legal per 5th edition char #x0992
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="঒",
      data="an only legal per 5th edition char #x0992\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n58_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?঩ an only legal per 5th edition char #x09a9
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="঩",
      data="an only legal per 5th edition char #x09a9\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n59_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?঱ an only legal per 5th edition char #x09b1
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="঱",
      data="an only legal per 5th edition char #x09b1\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n60_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?঵ an only legal per 5th edition char #x09b5
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="঵",
      data="an only legal per 5th edition char #x09b5\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n61_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?঺ an only legal per 5th edition char #x09ba
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="঺",
      data="an only legal per 5th edition char #x09ba\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n62_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?৞ an only legal per 5th edition char #x09de
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="৞",
      data="an only legal per 5th edition char #x09de\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n63_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?ৢ an only legal per 5th edition char #x09e2
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="ৢ",
      data="an only legal per 5th edition char #x09e2\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n64_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?৲ an only legal per 5th edition char #x09f2
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="৲",
      data="an only legal per 5th edition char #x09f2\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n65_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?਋ an only legal per 5th edition char #x0a0b
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="਋",
      data="an only legal per 5th edition char #x0a0b\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n66_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?਑ an only legal per 5th edition char #x0a11
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="਑",
      data="an only legal per 5th edition char #x0a11\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n67_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?਩ an only legal per 5th edition char #x0a29
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="਩",
      data="an only legal per 5th edition char #x0a29\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n68_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?਱ an only legal per 5th edition char #x0a31
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="਱",
      data="an only legal per 5th edition char #x0a31\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n69_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?਴ an only legal per 5th edition char #x0a34
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="਴",
      data="an only legal per 5th edition char #x0a34\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n70_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?਷ an only legal per 5th edition char #x0a37
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="਷",
      data="an only legal per 5th edition char #x0a37\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n71_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?਺ an only legal per 5th edition char #x0a3a
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="਺",
      data="an only legal per 5th edition char #x0a3a\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n72_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?੝ an only legal per 5th edition char #x0a5d
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="੝",
      data="an only legal per 5th edition char #x0a5d\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n73_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?ੰ an only legal per 5th edition char #x0a70
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="ੰ",
      data="an only legal per 5th edition char #x0a70\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n74_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?ੵ an only legal per 5th edition char #x0a75
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="ੵ",
      data="an only legal per 5th edition char #x0a75\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n75_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?઄ an only legal per 5th edition char #x0a84
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="઄",
      data="an only legal per 5th edition char #x0a84\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n76_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?઼ an only legal per 5th edition char #x0abc
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="઼",
      data="an only legal per 5th edition char #x0abc\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n77_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?઒ an only legal per 5th edition char #x0a92
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="઒",
      data="an only legal per 5th edition char #x0a92\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n78_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?઩ an only legal per 5th edition char #x0aa9
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="઩",
      data="an only legal per 5th edition char #x0aa9\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n79_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?઱ an only legal per 5th edition char #x0ab1
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="઱",
      data="an only legal per 5th edition char #x0ab1\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n80_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?઴ an only legal per 5th edition char #x0ab4
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="઴",
      data="an only legal per 5th edition char #x0ab4\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n81_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?઺ an only legal per 5th edition char #x0aba
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="઺",
      data="an only legal per 5th edition char #x0aba\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n82_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?଄ an only legal per 5th edition char #x0b04
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="଄",
      data="an only legal per 5th edition char #x0b04\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n83_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?଍ an only legal per 5th edition char #x0b0d
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="଍",
      data="an only legal per 5th edition char #x0b0d\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n84_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?଑ an only legal per 5th edition char #x0b11
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="଑",
      data="an only legal per 5th edition char #x0b11\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n85_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?଩ an only legal per 5th edition char #x0b29
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="଩",
      data="an only legal per 5th edition char #x0b29\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n86_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?଱ an only legal per 5th edition char #x0b31
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="଱",
      data="an only legal per 5th edition char #x0b31\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n87_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?଴ an only legal per 5th edition char #x0b34
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="଴",
      data="an only legal per 5th edition char #x0b34\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n88_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?଺ an only legal per 5th edition char #x0b3a
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="଺",
      data="an only legal per 5th edition char #x0b3a\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n89_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?ା an only legal per 5th edition char #x0b3e
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="ା",
      data="an only legal per 5th edition char #x0b3e\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n90_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?୞ an only legal per 5th edition char #x0b5e
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="୞",
      data="an only legal per 5th edition char #x0b5e\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n91_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?ୢ an only legal per 5th edition char #x0b62
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="ୢ",
      data="an only legal per 5th edition char #x0b62\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n92_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?஋ an only legal per 5th edition char #x0b8b
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="஋",
      data="an only legal per 5th edition char #x0b8b\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n93_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?஑ an only legal per 5th edition char #x0b91
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="஑",
      data="an only legal per 5th edition char #x0b91\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n94_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?஘ an only legal per 5th edition char #x0b98
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="஘",
      data="an only legal per 5th edition char #x0b98\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n95_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?஛ an only legal per 5th edition char #x0b9b
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="஛",
      data="an only legal per 5th edition char #x0b9b\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n96_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?஝ an only legal per 5th edition char #x0b9d
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="஝",
      data="an only legal per 5th edition char #x0b9d\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n97_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?஠ an only legal per 5th edition char #x0ba0
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="஠",
      data="an only legal per 5th edition char #x0ba0\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n98_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?஧ an only legal per 5th edition char #x0ba7
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="஧",
      data="an only legal per 5th edition char #x0ba7\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P85_ibm85n99_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?஫ an only legal per 5th edition char #x0bab
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="஫",
      data="an only legal per 5th edition char #x0bab\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P86_ibm86n01_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?䳿 an only legal per 5th edition char #x4cff
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="䳿",
      data="an only legal per 5th edition char #x4cff\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P86_ibm86n02_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?龦 an only legal per 5th edition char #x9fa6
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="龦",
      data="an only legal per 5th edition char #x9fa6\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P86_ibm86n03_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?〈 an only legal per 5th edition char #x3008
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="〈",
      data="an only legal per 5th edition char #x3008\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P86_ibm86n04_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?〪 an only legal per 5th edition char #x302a
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="〪",
      data="an only legal per 5th edition char #x302a\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P87_ibm87n01_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_˿ an only legal per 5th edition char #x2ff
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_˿",
      data="an only legal per 5th edition char #x2ff\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P87_ibm87n02_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_͆ an only legal per 5th edition char #x346
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_͆",
      data="an only legal per 5th edition char #x346\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P87_ibm87n03_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_͢ an only legal per 5th edition char #x362
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_͢",
      data="an only legal per 5th edition char #x362\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P87_ibm87n04_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_҇ an only legal per 5th edition char #x487
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_҇",
      data="an only legal per 5th edition char #x487\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P87_ibm87n05_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_֢ an only legal per 5th edition char #x5a2
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_֢",
      data="an only legal per 5th edition char #x5a2\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P87_ibm87n06_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_ֺ an only legal per 5th edition char #x5ba
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_ֺ",
      data="an only legal per 5th edition char #x5ba\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P87_ibm87n07_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_־ an only legal per 5th edition char #x5be
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_־",
      data="an only legal per 5th edition char #x5be\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P87_ibm87n08_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_׀ an only legal per 5th edition char #x5c0
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_׀",
      data="an only legal per 5th edition char #x5c0\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P87_ibm87n09_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_׃ an only legal per 5th edition char #x5c3
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_׃",
      data="an only legal per 5th edition char #x5c3\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P87_ibm87n10_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_ٓ an only legal per 5th edition char #x653
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_ٓ",
      data="an only legal per 5th edition char #x653\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P87_ibm87n11_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_ڸ an only legal per 5th edition char #x6b8
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_ڸ",
      data="an only legal per 5th edition char #x6b8\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P87_ibm87n12_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_ڹ an only legal per 5th edition char #x6b9
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_ڹ",
      data="an only legal per 5th edition char #x6b9\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P87_ibm87n13_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_۩ an only legal per 5th edition char #x6e9
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_۩",
      data="an only legal per 5th edition char #x6e9\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P87_ibm87n14_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_ۮ an only legal per 5th edition char #x6ee
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_ۮ",
      data="an only legal per 5th edition char #x6ee\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P87_ibm87n15_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_ऄ an only legal per 5th edition char #x0904
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_ऄ",
      data="an only legal per 5th edition char #x0904\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P87_ibm87n16_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_ऻ an only legal per 5th edition char #x093b
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_ऻ",
      data="an only legal per 5th edition char #x093b\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P87_ibm87n17_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_ॎ an only legal per 5th edition char #x094e
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_ॎ",
      data="an only legal per 5th edition char #x094e\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P87_ibm87n18_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_ॕ an only legal per 5th edition char #x0955
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_ॕ",
      data="an only legal per 5th edition char #x0955\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P87_ibm87n19_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_। an only legal per 5th edition char #x0964
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_।",
      data="an only legal per 5th edition char #x0964\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P87_ibm87n20_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_঄ an only legal per 5th edition char #x0984
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_঄",
      data="an only legal per 5th edition char #x0984\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P87_ibm87n21_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_৅ an only legal per 5th edition char #x09c5
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_৅",
      data="an only legal per 5th edition char #x09c5\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P87_ibm87n22_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_৉ an only legal per 5th edition char #x09c9
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_৉",
      data="an only legal per 5th edition char #x09c9\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P87_ibm87n23_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_ৎ an only legal per 5th edition char #x09ce
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_ৎ",
      data="an only legal per 5th edition char #x09ce\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P87_ibm87n24_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_৘ an only legal per 5th edition char #x09d8
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_৘",
      data="an only legal per 5th edition char #x09d8\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P87_ibm87n25_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_৤ an only legal per 5th edition char #x09e4
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_৤",
      data="an only legal per 5th edition char #x09e4\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P87_ibm87n26_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_ਃ an only legal per 5th edition char #x0a03
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_ਃ",
      data="an only legal per 5th edition char #x0a03\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P87_ibm87n27_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_਽ an only legal per 5th edition char #x0a3d
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_਽",
      data="an only legal per 5th edition char #x0a3d\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P87_ibm87n28_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_੆ an only legal per 5th edition char #x0a46
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_੆",
      data="an only legal per 5th edition char #x0a46\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P87_ibm87n29_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_੉ an only legal per 5th edition char #x0a49
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_੉",
      data="an only legal per 5th edition char #x0a49\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P87_ibm87n30_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_੎ an only legal per 5th edition char #x0a4e
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_੎",
      data="an only legal per 5th edition char #x0a4e\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P87_ibm87n31_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_઀ an only legal per 5th edition char #x0a80
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_઀",
      data="an only legal per 5th edition char #x0a80\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P87_ibm87n32_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_઄ an only legal per 5th edition char #x0a84
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_઄",
      data="an only legal per 5th edition char #x0a84\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P87_ibm87n33_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_઻ an only legal per 5th edition char #x0abb
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_઻",
      data="an only legal per 5th edition char #x0abb\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P87_ibm87n34_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_૆ an only legal per 5th edition char #x0ac6
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_૆",
      data="an only legal per 5th edition char #x0ac6\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P87_ibm87n35_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_૊ an only legal per 5th edition char #x0aca
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_૊",
      data="an only legal per 5th edition char #x0aca\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P87_ibm87n36_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_૎ an only legal per 5th edition char #x0ace
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_૎",
      data="an only legal per 5th edition char #x0ace\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P87_ibm87n37_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_଄ an only legal per 5th edition char #x0b04
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_଄",
      data="an only legal per 5th edition char #x0b04\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P87_ibm87n38_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_଻ an only legal per 5th edition char #x0b3b
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_଻",
      data="an only legal per 5th edition char #x0b3b\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P87_ibm87n39_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_ୄ an only legal per 5th edition char #x0b44
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_ୄ",
      data="an only legal per 5th edition char #x0b44\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P87_ibm87n40_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_୊ an only legal per 5th edition char #x0b4a
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_୊",
      data="an only legal per 5th edition char #x0b4a\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P87_ibm87n41_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_୎ an only legal per 5th edition char #x0b4e
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_୎",
      data="an only legal per 5th edition char #x0b4e\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P87_ibm87n42_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_୘ an only legal per 5th edition char #x0b58
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_୘",
      data="an only legal per 5th edition char #x0b58\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P87_ibm87n43_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_஄ an only legal per 5th edition char #x0b84
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_஄",
      data="an only legal per 5th edition char #x0b84\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P87_ibm87n44_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_௃ an only legal per 5th edition char #x0bc3
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_௃",
      data="an only legal per 5th edition char #x0bc3\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P87_ibm87n45_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_௉ an only legal per 5th edition char #x0bc9
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_௉",
      data="an only legal per 5th edition char #x0bc9\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P87_ibm87n46_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_௖ an only legal per 5th edition char #x0bd6
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_௖",
      data="an only legal per 5th edition char #x0bd6\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P87_ibm87n47_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_఍ an only legal per 5th edition char #x0c0d
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_఍",
      data="an only legal per 5th edition char #x0c0d\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P87_ibm87n48_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_౅ an only legal per 5th edition char #x0c45
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_౅",
      data="an only legal per 5th edition char #x0c45\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P87_ibm87n49_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_౉ an only legal per 5th edition char #x0c49
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_౉",
      data="an only legal per 5th edition char #x0c49\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P87_ibm87n50_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_౔ an only legal per 5th edition char #x0c54
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_౔",
      data="an only legal per 5th edition char #x0c54\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P87_ibm87n51_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_ಁ an only legal per 5th edition char #x0c81
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_ಁ",
      data="an only legal per 5th edition char #x0c81\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P87_ibm87n52_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_಄ an only legal per 5th edition char #x0c84
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_಄",
      data="an only legal per 5th edition char #x0c84\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P87_ibm87n53_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_೅ an only legal per 5th edition char #x0cc5
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_೅",
      data="an only legal per 5th edition char #x0cc5\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P87_ibm87n54_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_೉ an only legal per 5th edition char #x0cc9
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_೉",
      data="an only legal per 5th edition char #x0cc9\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P87_ibm87n55_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_೔ an only legal per 5th edition char #x0cd4
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_೔",
      data="an only legal per 5th edition char #x0cd4\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P87_ibm87n56_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_೗ an only legal per 5th edition char #x0cd7
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_೗",
      data="an only legal per 5th edition char #x0cd7\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P87_ibm87n57_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_ഄ an only legal per 5th edition char #x0d04
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_ഄ",
      data="an only legal per 5th edition char #x0d04\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P87_ibm87n58_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_൅ an only legal per 5th edition char #x0d45
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_൅",
      data="an only legal per 5th edition char #x0d45\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P87_ibm87n59_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_൉ an only legal per 5th edition char #x0d49
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_൉",
      data="an only legal per 5th edition char #x0d49\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P87_ibm87n60_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_ൎ an only legal per 5th edition char #x0d4e
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_ൎ",
      data="an only legal per 5th edition char #x0d4e\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P87_ibm87n61_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_൘ an only legal per 5th edition char #x0d58
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_൘",
      data="an only legal per 5th edition char #x0d58\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P87_ibm87n62_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_฿ an only legal per 5th edition char #x0e3f
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_฿",
      data="an only legal per 5th edition char #x0e3f\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P87_ibm87n63_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_฻ an only legal per 5th edition char #x0e3b
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_฻",
      data="an only legal per 5th edition char #x0e3b\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P87_ibm87n64_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_๏ an only legal per 5th edition char #x0e4f
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_๏",
      data="an only legal per 5th edition char #x0e4f\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P87_ibm87n66_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_຺ an only legal per 5th edition char #x0eba
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_຺",
      data="an only legal per 5th edition char #x0eba\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P87_ibm87n67_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_຾ an only legal per 5th edition char #x0ebe
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_຾",
      data="an only legal per 5th edition char #x0ebe\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P87_ibm87n68_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_໎ an only legal per 5th edition char #x0ece
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_໎",
      data="an only legal per 5th edition char #x0ece\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P87_ibm87n69_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_༚ an only legal per 5th edition char #x0f1a
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_༚",
      data="an only legal per 5th edition char #x0f1a\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P87_ibm87n70_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_༶ an only legal per 5th edition char #x0f36
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_༶",
      data="an only legal per 5th edition char #x0f36\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P87_ibm87n71_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_༸ an only legal per 5th edition char #x0f38
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_༸",
      data="an only legal per 5th edition char #x0f38\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P87_ibm87n72_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_༻ an only legal per 5th edition char #x0f3b
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_༻",
      data="an only legal per 5th edition char #x0f3b\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P87_ibm87n73_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_༺ an only legal per 5th edition char #x0f3a
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_༺",
      data="an only legal per 5th edition char #x0f3a\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P87_ibm87n74_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_཰ an only legal per 5th edition char #x0f70
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_཰",
      data="an only legal per 5th edition char #x0f70\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P87_ibm87n75_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_྅ an only legal per 5th edition char #x0f85
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_྅",
      data="an only legal per 5th edition char #x0f85\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P87_ibm87n76_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_ྌ an only legal per 5th edition char #x0f8c
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_ྌ",
      data="an only legal per 5th edition char #x0f8c\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P87_ibm87n77_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_ྖ an only legal per 5th edition char #x0f96
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_ྖ",
      data="an only legal per 5th edition char #x0f96\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P87_ibm87n78_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_྘ an only legal per 5th edition char #x0f98
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_྘",
      data="an only legal per 5th edition char #x0f98\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P87_ibm87n79_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_ྰ an only legal per 5th edition char #x0fb0
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_ྰ",
      data="an only legal per 5th edition char #x0fb0\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P87_ibm87n80_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_ྸ an only legal per 5th edition char #x0fb8
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_ྸ",
      data="an only legal per 5th edition char #x0fb8\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P87_ibm87n81_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_ྺ an only legal per 5th edition char #x0fba
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_ྺ",
      data="an only legal per 5th edition char #x0fba\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P87_ibm87n82_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_⃝ an only legal per 5th edition char #x20dd
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_⃝",
      data="an only legal per 5th edition char #x20dd\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P87_ibm87n83_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_⃢ an only legal per 5th edition char #x20e2
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_⃢",
      data="an only legal per 5th edition char #x20e2\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P87_ibm87n84_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_〰 an only legal per 5th edition char #x3030
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_〰",
      data="an only legal per 5th edition char #x3030\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P87_ibm87n85_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_゛ an only legal per 5th edition char #x309b
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_゛",
      data="an only legal per 5th edition char #x309b\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P88_ibm88n03_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_٪ an only legal per 5th edition char #x66a
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_٪",
      data="an only legal per 5th edition char #x66a\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P88_ibm88n04_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_ۺ an only legal per 5th edition char #x6fa
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_ۺ",
      data="an only legal per 5th edition char #x6fa\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P88_ibm88n05_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_॰ an only legal per 5th edition char #x0970
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_॰",
      data="an only legal per 5th edition char #x0970\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P88_ibm88n06_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_৲ an only legal per 5th edition char #x09f2
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_৲",
      data="an only legal per 5th edition char #x09f2\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P88_ibm88n08_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_૰ an only legal per 5th edition char #x0af0
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_૰",
      data="an only legal per 5th edition char #x0af0\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P88_ibm88n09_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_୰ an only legal per 5th edition char #x0b70
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_୰",
      data="an only legal per 5th edition char #x0b70\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P88_ibm88n10_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_౥ an only legal per 5th edition char #x0c65
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_౥",
      data="an only legal per 5th edition char #x0c65\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P88_ibm88n11_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_೥ an only legal per 5th edition char #x0ce5
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_೥",
      data="an only legal per 5th edition char #x0ce5\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P88_ibm88n12_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_೰ an only legal per 5th edition char #x0cf0
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_೰",
      data="an only legal per 5th edition char #x0cf0\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P88_ibm88n13_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_൰ an only legal per 5th edition char #x0d70
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_൰",
      data="an only legal per 5th edition char #x0d70\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P88_ibm88n14_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_๚ an only legal per 5th edition char #x0e5a
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_๚",
      data="an only legal per 5th edition char #x0e5a\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P88_ibm88n15_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_໚ an only legal per 5th edition char #x0eda
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_໚",
      data="an only legal per 5th edition char #x0eda\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P88_ibm88n16_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_༪ an only legal per 5th edition char #x0f2a
    #| in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_༪",
      data="an only legal per 5th edition char #x0f2a\n in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P89_ibm89n03_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_˒ an only legal per 5th edition extender #x2d2 in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_˒",
      data="an only legal per 5th edition extender #x2d2 in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P89_ibm89n04_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_Ͼ an only legal per 5th edition extender #x3fe in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_Ͼ",
      data="an only legal per 5th edition extender #x3fe in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "w3c/valid/ibm_valid_P89_ibm89n05_xml" {
  let xml_text =
    #|<!DOCTYPE animal [
    #|<!ELEMENT animal ANY>
    #|<?_ٟ an only legal per 5th edition extender #x65f in PITarget ?>
    #|]>
    #|<animal/>
    #|
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("animal"),
    PI(
      target="_ٟ",
      data="an only legal per 5th edition extender #x65f in PITarget ",
    ),
    Start(name="animal", attributes=Map([])),
    End("animal"),
  ])
}

///|
test "parse/line-ends/crlf-in-text" {
  // Section 2.11: CRLF in the input is normalized to a single LF before parsing.
  let xml_text = "<a>x\r\ny</a>"
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    Start(name="a", attributes=Map([])),
    Text("x\ny"),
    End("a"),
  ])
}

///|
test "parse/line-ends/cr-in-text" {
  // Section 2.11: a lone CR in the input is normalized to LF.
  let xml_text = "<a>x\ry\rz</a>"
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    Start(name="a", attributes=Map([])),
    Text("x\ny\nz"),
    End("a"),
  ])
}

///|
test "parse/line-ends/crlf-in-attribute" {
  // Sections 2.11 and 3.3.3: CRLF becomes one LF on input, then one space in the attribute value.
  let xml_text = "<a b=\"x\r\ny\"/>"
  let events = @xml.parse(xml_text)
  assert_eq(events, [Start(name="a", attributes={ "b": "x y" }), End("a")])
}

///|
test "parse/line-ends/cr-in-comment-and-pi" {
  // Section 2.11 applies to the whole input, comments and PI data included.
  let xml_text = "<!--a\rb--><a/><?p c\r\nd?>"
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    Comment("a\nb"),
    Start(name="a", attributes=Map([])),
    End("a"),
    PI(target="p", data="c\nd"),
  ])
}

///|
test "parse/line-ends/charref-cr-in-attribute" {
  // Section 3.3.3: a character reference to CR contributes the CR itself; only literal white space becomes a space.
  let xml_text =
    #|<a b="x&#13;y&#xD;z"/>
  let events = @xml.parse(xml_text)
  assert_eq(events, [Start(name="a", attributes={ "b": "x\ry\rz" }), End("a")])
}

///|
test "parse/line-ends/charref-cr-in-text" {
  // Sections 2.11 and 4.4.2: character references are included after line-end normalization, so &#13; yields a CR.
  let xml_text =
    #|<a>&#13;&#10;</a>
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    Start(name="a", attributes=Map([])),
    Text("\r\n"),
    End("a"),
  ])
}

///|
test "parse/attributes/cdata-not-collapsed" {
  // Section 3.3.3: a CDATA-type attribute keeps every space (only tokenized types are trimmed and collapsed).
  let xml_text =
    #|<!DOCTYPE a [<!ATTLIST a x CDATA #IMPLIED>]><a x="  p  q  "/>
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("a"),
    Start(name="a", attributes={ "x": "  p  q  " }),
    End("a"),
  ])
}

///|
test "parse/attributes/undeclared-is-cdata" {
  // Section 3.3.3: an attribute for which no declaration has been read is treated as CDATA.
  let xml_text =
    #|<a x="  p 	 q  "/>
  let events = @xml.parse(xml_text)
  assert_eq(events, [Start(name="a", attributes={ "x": "  p   q  " }), End("a")])
}

///|
test "parse/attributes/tokenized-specified-collapsed" {
  // Section 3.3.3: a specified value of a tokenized type is trimmed and its space runs collapsed.
  let xml_text =
    #|<!DOCTYPE a [<!ATTLIST a x NMTOKENS #IMPLIED y ID #IMPLIED>]><a x="  p  q  " y=" i "/>
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("a"),
    Start(name="a", attributes={ "x": "p q", "y": "i" }),
    End("a"),
  ])
}

///|
test "parse/attributes/tokenized-charref-not-collapsed" {
  // Section 3.3.3: only #x20 characters are collapsed; a line feed from a character reference survives in a tokenized value.
  let xml_text =
    #|<!DOCTYPE a [<!ATTLIST a x NMTOKENS #IMPLIED>]><a x=" p&#10;q "/>
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("a"),
    Start(name="a", attributes={ "x": "p\nq" }),
    End("a"),
  ])
}

///|
test "parse/attributes/entity-whitespace-normalized" {
  // Section 3.3.3: white space inside an entity's replacement text is a character, so it becomes a space; the same line feed written as a character reference is kept.
  let xml_text =
    #|<!DOCTYPE a [<!ENTITY e "&#10;">]><a x="&e;" y="&#10;"/>
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("a"),
    Start(name="a", attributes={ "x": " ", "y": "\n" }),
    End("a"),
  ])
}

///|
test "parse/dtd/declarations-before-pe-reference-used" {
  // Section 5.1: declarations up to the first parameter-entity reference are used, whatever follows.
  let xml_text =
    #|<!DOCTYPE d [<!ENTITY e "v"><!ATTLIST d a CDATA "x"> %p; ]><d>&e;</d>
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("d"),
    Start(name="d", attributes={ "a": "x" }),
    Text("v"),
    End("d"),
  ])
}

///|
test "parse/dtd/declarations-after-pe-reference-unused" {
  // Section 5.1: a non-validating processor is only required to use declarations up to the first reference to a parameter entity it does not read (this parser reads none); a later entity declaration is not used, and since the document has a PE reference and is not standalone the reference is not a well-formedness error (4.1) but an unexpanded EntityRef.
  let xml_text =
    #|<!DOCTYPE d [%p; <!ENTITY e "v">]><d>&e;</d>
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("d"),
    Start(name="d", attributes=Map([])),
    EntityRef("e"),
    End("d"),
  ])
}

///|
test "parse/dtd/attlist-after-pe-reference-unused" {
  // Section 5.1: an attribute-list declaration after the first parameter-entity reference is not used either.
  let xml_text =
    #|<!DOCTYPE d [%p; <!ATTLIST d a CDATA "x" b NMTOKENS #IMPLIED>]><d b=" m  n "/>
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("d"),
    Start(name="d", attributes={ "b": " m  n " }),
    End("d"),
  ])
}

///|
test "parse/dtd/declarations-after-pe-reference-standalone" {
  // Sections 2.9 and 5.1: with standalone='yes' no external markup declaration can affect the document, so declarations after a parameter-entity reference are used.
  let xml_text =
    #|<?xml version="1.0" standalone="yes"?><!DOCTYPE d [%p; <!ENTITY e "v">]><d>&e;</d>
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    Decl(version="1.0", encoding=None, standalone=Some(true)),
    DocType("d"),
    Start(name="d", attributes=Map([])),
    Text("v"),
    End("d"),
  ])
}

///|
test "parse/dtd/declarations-after-pe-reference-checked" {
  // Section 5.1: the entire internal subset is checked for well-formedness, including declarations after a parameter-entity reference.
  let xml_text =
    #|<!DOCTYPE d [%p; <!ELEMENT d (>]><d/>
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "parse/dtd/undeclared-pe-reference-accepted" {
  // Section 4.1: for parameter entities 'Entity Declared' is a validity constraint only; a reference to an undeclared parameter entity between declarations is well-formed.
  let xml_text =
    #|<!DOCTYPE d [%nope;]><d/>
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("d"),
    Start(name="d", attributes=Map([])),
    End("d"),
  ])
}

///|
test "parse/dtd/pe-declaration-not-read" {
  // Section 5.1: parameter entities are never read, even internal ones; the declaration inside %p; is unknown and, after the reference, the entity declaration written out is not used.
  let xml_text =
    #|<!DOCTYPE d [<!ENTITY % p "<!ENTITY e 'v'>"> %p; ]><d>&e;</d>
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("d"),
    Start(name="d", attributes=Map([])),
    EntityRef("e"),
    End("d"),
  ])
}

///|
test "parse/dtd/internal-subset-used-with-external-subset" {
  // Section 2.8: the internal subset is processed even though the external subset is not read.
  let xml_text =
    #|<!DOCTYPE d SYSTEM "d.dtd" [<!ENTITY e "v"><!ATTLIST d a CDATA "x">]><d>&e;</d>
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("d"),
    Start(name="d", attributes={ "a": "x" }),
    Text("v"),
    End("d"),
  ])
}

///|
test "parse/entity/external-parsed-entity-in-content" {
  // Section 4.4.3: a non-validating processor need not include an external parsed entity, but must report that it recognized and did not read it: EntityRef, with the surrounding character data intact.
  let xml_text =
    #|<!DOCTYPE d [<!ENTITY x SYSTEM "x.ent">]><d>a&x;b</d>
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("d"),
    Start(name="d", attributes=Map([])),
    Text("a"),
    EntityRef("x"),
    Text("b"),
    End("d"),
  ])
}

///|
test "parse/entity/external-entity-in-attribute" {
  // Section 4.4.4: a reference to an external entity in an attribute value is forbidden.
  let xml_text =
    #|<!DOCTYPE d [<!ENTITY x SYSTEM "x.ent">]><d a="&x;"/>
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "parse/entity/unparsed-entity-in-content" {
  // Section 4.4.4: a reference to an unparsed entity is forbidden in content.
  let xml_text =
    #|<!DOCTYPE d [<!NOTATION n SYSTEM "n"><!ENTITY x SYSTEM "x.gif" NDATA n>]><d>&x;</d>
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "parse/entity/unparsed-entity-in-attribute" {
  // Section 4.4.4: a reference to an unparsed entity is forbidden in an attribute value.
  let xml_text =
    #|<!DOCTYPE d [<!NOTATION n SYSTEM "n"><!ENTITY x SYSTEM "x.gif" NDATA n>]><d a="&x;"/>
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "parse/entity/undeclared-with-external-subset" {
  // Section 4.1: with an external subset (which is not read) and no standalone='yes', 'Entity Declared' is only a validity constraint; the reference is reported unexpanded.
  let xml_text =
    #|<!DOCTYPE d SYSTEM "d.dtd"><d>&u;</d>
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("d"),
    Start(name="d", attributes=Map([])),
    EntityRef("u"),
    End("d"),
  ])
}

///|
test "parse/entity/undeclared-with-external-subset-standalone" {
  // Section 4.1, WFC: Entity Declared: with standalone='yes' the entity must be declared even when there is an external subset.
  let xml_text =
    #|<?xml version="1.0" standalone="yes"?><!DOCTYPE d SYSTEM "d.dtd"><d>&u;</d>
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "parse/entity/undeclared-with-external-subset-standalone-no" {
  // Section 4.1: standalone='no' is the same as no standalone declaration.
  let xml_text =
    #|<?xml version="1.0" standalone="no"?><!DOCTYPE d SYSTEM "d.dtd"><d>&u;</d>
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    Decl(version="1.0", encoding=None, standalone=Some(false)),
    DocType("d"),
    Start(name="d", attributes=Map([])),
    EntityRef("u"),
    End("d"),
  ])
}

///|
test "parse/entity/undeclared-after-pe-reference" {
  // Section 4.1: an internal subset containing a parameter-entity reference is enough to make 'Entity Declared' a validity constraint only.
  let xml_text =
    #|<!DOCTYPE d [%p;]><d>&u;</d>
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("d"),
    Start(name="d", attributes=Map([])),
    EntityRef("u"),
    End("d"),
  ])
}

///|
test "parse/entity/undeclared-internal-subset-only" {
  // Section 4.1, WFC: Entity Declared: with only an internal subset and no parameter-entity references, an undeclared entity is a well-formedness error.
  let xml_text =
    #|<!DOCTYPE d [<!ELEMENT d ANY>]><d>&u;</d>
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "parse/entity/undeclared-pe-declared-but-not-referenced" {
  // Section 4.1: declaring a parameter entity is not a parameter-entity reference; the well-formedness constraint still applies.
  let xml_text =
    #|<!DOCTYPE d [<!ENTITY % p SYSTEM "p.ent">]><d>&u;</d>
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "parse/entity/undeclared-in-attribute-with-external-subset" {
  // Section 3.3.3: it is an error if an attribute value contains a reference to an entity for which no declaration has been read; the parser reports it even where content would get an EntityRef.
  let xml_text =
    #|<!DOCTYPE d SYSTEM "d.dtd"><d a="&u;"/>
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "parse/entity/replacement-text-must-be-content" {
  // Section 4.3.2: an internal general entity is well-formed only if its replacement text matches 'content'; an end tag for an element opened outside the entity is not.
  let xml_text =
    #|<!DOCTYPE a [<!ENTITY e "</a><a>">]><a>&e;</a>
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "parse/entity/replacement-text-elements" {
  // Section 4.4.2: elements inside replacement text are parsed and their character data merges with the surrounding text.
  let xml_text =
    #|<!DOCTYPE a [<!ENTITY e "x<b>y</b>z">]><a>p&e;q</a>
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("a"),
    Start(name="a", attributes=Map([])),
    Text("px"),
    Start(name="b", attributes=Map([])),
    Text("y"),
    End("b"),
    Text("zq"),
    End("a"),
  ])
}

///|
test "parse/decl/encoding-name-reported-verbatim" {
  // Section 4.3.3: the input is already decoded, so the encoding declaration is only checked against EncName and reported as written.
  let xml_text =
    #|<?xml version="1.0" encoding="ISO-8859-1"?><a/>
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    Decl(version="1.0", encoding=Some("ISO-8859-1"), standalone=None),
    Start(name="a", attributes=Map([])),
    End("a"),
  ])
}

///|
test "parse/decl/encoding-utf-16-name-accepted" {
  // Section 4.3.3: a UTF-16 declaration on decoded input has nothing to contradict; the name is valid and reported.
  let xml_text =
    #|<?xml version="1.0" encoding="UTF-16"?><a/>
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    Decl(version="1.0", encoding=Some("UTF-16"), standalone=None),
    Start(name="a", attributes=Map([])),
    End("a"),
  ])
}

///|
test "parse/decl/pseudo-attribute-order" {
  // Section 2.8 [23]: standalone may not precede encoding.
  let xml_text =
    #|<?xml version="1.0" standalone="yes" encoding="UTF-8"?><a/>
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "parse/names/undeclared-prefix-is-a-name" {
  // Section 2.3 [4]: the colon is an ordinary name character; without namespace processing an undeclared prefix is not an error.
  let xml_text =
    #|<a:b c:d="1"><:e/></a:b>
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    Start(name="a:b", attributes={ "c:d": "1" }),
    Start(name=":e", attributes=Map([])),
    End(":e"),
    End("a:b"),
  ])
}

///|
test "parse/names/xmlns-is-an-ordinary-attribute" {
  // No namespace processing: xmlns and xmlns:p are attributes like any other and prefixes stay in names.
  let xml_text =
    #|<a xmlns="u" xmlns:p="v"><p:b p:c="w"/></a>
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    Start(name="a", attributes={ "xmlns": "u", "xmlns:p": "v" }),
    Start(name="p:b", attributes={ "p:c": "w" }),
    End("p:b"),
    End("a"),
  ])
}

///|
test "parse/names/5e-supplementary-name-start" {
  // Section 2.3 [4]: NameStartChar includes [#x10000-#xEFFFF] (Fifth Edition).
  let xml_text =
    #|<𐀀 𐀁="1"/>
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    Start(name="𐀀", attributes={ "𐀁": "1" }),
    End("𐀀"),
  ])
}

///|
test "parse/names/5e-bmp-name-start" {
  // Section 2.3 [4]: U+0132 is a NameStartChar in the Fifth Edition (it was not a BaseChar before).
  let xml_text =
    #|<Ĳ Ĳ="1">Ĳ</Ĳ>
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    Start(name="Ĳ", attributes={ "Ĳ": "1" }),
    Text("Ĳ"),
    End("Ĳ"),
  ])
}

///|
test "parse/names/excluded-name-chars" {
  // Section 2.3 [4a]: U+00D7 (multiplication sign) is excluded from NameChar.
  let xml_text =
    #|<a×/>
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "parse/names/ascii-punctuation-not-name-chars" {
  // Section 2.3 [4a]: ASCII punctuation other than '-', '.', ':' and '_' is not a NameChar.
  let xml_text =
    #|<a@b/>
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "parse/attributes/lt-via-entity-forbidden" {
  // Section 3.1, WFC: No < in Attribute Values: the replacement text of an entity referenced in an attribute value may not contain '<' (here produced by the character reference when the replacement text was built, section 4.5).
  let xml_text =
    #|<!DOCTYPE a [<!ENTITY e "&#60;">]><a x="&e;"/>
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "parse/attributes/lt-via-entity-reference-allowed" {
  // Section 4.4.7: &lt; in an entity value is bypassed, so the replacement text holds a reference, not '<'; expanding it in the attribute value is fine (contrast lt-via-entity-forbidden).
  let xml_text =
    #|<!DOCTYPE a [<!ENTITY e "&lt;">]><a x="&e;"/>
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("a"),
    Start(name="a", attributes={ "x": "<" }),
    End("a"),
  ])
}

///|
test "parse/dtd/mixed-content-requires-star" {
  // Section 3.2.2 [51]: mixed content with element names must end in ')*'.
  let xml_text =
    #|<!DOCTYPE a [<!ELEMENT a (#PCDATA|b)>]><a/>
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "parse/dtd/mixed-content-forms" {
  // Section 3.2.2 [51]: the accepted mixed-content forms, with optional white space.
  let xml_text =
    #|<!DOCTYPE a [<!ELEMENT a (#PCDATA|b)*><!ELEMENT b (#PCDATA)><!ELEMENT c ( #PCDATA | b | d )*><!ELEMENT d (#PCDATA)*>]><a/>
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("a"),
    Start(name="a", attributes=Map([])),
    End("a"),
  ])
}

///|
test "parse/entity/predefined-declared-per-4.6" {
  // Section 4.6: the predefined entities may be declared, as internal entities whose replacement text is a character reference to the character; they still expand.
  let xml_text =
    #|<!DOCTYPE a [<!ENTITY lt "&#38;#60;"><!ENTITY amp "&#38;#38;"><!ENTITY gt "&#62;">]><a>&lt;&amp;&gt;</a>
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("a"),
    Start(name="a", attributes=Map([])),
    Text("<&>"),
    End("a"),
  ])
}

///|
test "parse/pi/reserved-target-any-case" {
  // Section 2.6 [17]: a PI target matching xml in any letter case is reserved.
  let xml_text =
    #|<a><?XmL x?></a>
  @test.assert_raise(() => @xml.parse(xml_text))
}

///|
test "parse/validity/root-name-mismatch-accepted" {
  // Section 2.8, VC: Root Element Type is a validity constraint only.
  let xml_text =
    #|<!DOCTYPE a><b/>
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("a"),
    Start(name="b", attributes=Map([])),
    End("b"),
  ])
}

///|
test "parse/validity/content-model-not-enforced" {
  // Section 3, VC: Element Valid is a validity constraint only; an element declared EMPTY may have content.
  let xml_text =
    #|<!DOCTYPE a [<!ELEMENT a EMPTY><!ELEMENT b (c)>]><a>x<b/></a>
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("a"),
    Start(name="a", attributes=Map([])),
    Text("x"),
    Start(name="b", attributes=Map([])),
    End("b"),
    End("a"),
  ])
}

///|
test "parse/validity/undeclared-element-and-attribute-accepted" {
  // Sections 3 and 3.1: undeclared elements and attributes are validity errors only.
  let xml_text =
    #|<!DOCTYPE a [<!ELEMENT a (b)><!ATTLIST a x CDATA #IMPLIED>]><a y="1"><c/></a>
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("a"),
    Start(name="a", attributes={ "y": "1" }),
    Start(name="c", attributes=Map([])),
    End("c"),
    End("a"),
  ])
}

///|
test "parse/validity/required-attribute-not-enforced" {
  // Section 3.3.2, VC: Required Attribute is a validity constraint only.
  let xml_text =
    #|<!DOCTYPE a [<!ATTLIST a x CDATA #REQUIRED>]><a/>
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    DocType("a"),
    Start(name="a", attributes=Map([])),
    End("a"),
  ])
}

///|
test "parse/text/cdata-merges-with-text" {
  // CDATA sections contribute character data that merges with adjacent text into one event.
  let xml_text =
    #|<a>x<![CDATA[<y>&z;]]>w<![CDATA[]]]]><![CDATA[>]]></a>
  let events = @xml.parse(xml_text)
  assert_eq(events, [
    Start(name="a", attributes=Map([])),
    Text("x<y>&z;w]]>"),
    End("a"),
  ])
}

///|
test "print/escape-text" {
  // Every character data value a printer must escape (`<`, `&`, `]]>`, and a carriage return that
  // line-end normalization would otherwise turn into a line feed), plus text that looks like markup.
  for
    s in [
      "<", "&", ">", "]]>", "\r", "\r\n", "\"", "'", "a&b<c>d", "&lt;", "&#60;",
      "<![CDATA[x]]>", "<!-- c -->", "]]]]>", "\n  ", "\u{FEFF}",
    ] {
    let events : Array[@xml.Event] = [
      Start(name="a", attributes=Map([])),
      Text(s),
      End("a"),
    ]
    assert_eq(@xml.parse(@xml.print(events)), events)
  }
}

///|
test "print/escape-attribute" {
  // Every attribute value a printer must escape: markup characters, both quote characters, and the
  // white space characters that attribute-value normalization would turn into spaces.
  for
    s in [
      "<", "&", "\"", "'", "\t", "\n", "\r", "\r\n", "]]>", "  x  ", "&lt;", "&#60;",
      "\"'\"", "a\tb\nc\rd",
    ] {
    let events : Array[@xml.Event] = [
      Start(name="a", attributes={ "b": s, "c": "x" + s + "y" }),
      End("a"),
    ]
    assert_eq(@xml.parse(@xml.print(events)), events)
  }
}

///|
test "print/document-shape" {
  // A document with every event kind in every position the document grammar allows: declaration,
  // comments and PIs before and after the doctype and after the root, nested elements, mixed content.
  let events : Array[@xml.Event] = [
    Decl(version="1.0", encoding=Some("UTF-8"), standalone=Some(true)),
    Comment(" c "),
    PI(target="p", data="d = \"e\" ?"),
    DocType("r"),
    PI(target="q", data=""),
    Start(name="r", attributes=Map([])),
    Text("x"),
    Start(name="s", attributes={ "a": "1", "b": "" }),
    End("s"),
    Comment("-y"),
    PI(target="p", data="?"),
    Text(" z "),
    Start(name="t", attributes=Map([])),
    Start(name="u", attributes=Map([])),
    Text("v"),
    End("u"),
    End("t"),
    End("r"),
    Comment(""),
    PI(target="last", data=""),
  ]
  assert_eq(@xml.parse(@xml.print(events)), events)
}

///|
test "print/declaration-variants" {
  // Every combination of the optional declaration parts, and a 1.x version (section 2.8 [26]).
  let decls : Array[@xml.Event] = [
    Decl(version="1.0", encoding=None, standalone=None),
    Decl(version="1.0", encoding=Some("utf-8"), standalone=None),
    Decl(version="1.0", encoding=None, standalone=Some(false)),
    Decl(version="1.1", encoding=Some("ISO-8859-1"), standalone=Some(true)),
  ]
  for decl in decls {
    let events : Array[@xml.Event] = [
      decl,
      Start(name="a", attributes=Map([])),
      End("a"),
    ]
    assert_eq(@xml.parse(@xml.print(events)), events)
  }
}

///|
test "print/names" {
  // Names using every NameChar class: colon, dot, hyphen, middle dot, digits, and non-ASCII letters.
  let events : Array[@xml.Event] = [
    DocType(":r.1-2\u{B7}x"),
    Start(name=":r.1-2\u{B7}x", attributes={
      "\u{E9}:a.b": "",
      "xml:lang": "en",
    }),
    Start(name="\u{4E2D}\u{6587}", attributes=Map([])),
    End("\u{4E2D}\u{6587}"),
    PI(target="xml-stylesheet", data="href='s.css'"),
    End(":r.1-2\u{B7}x"),
  ]
  assert_eq(@xml.parse(@xml.print(events)), events)
}

///|
test "print/whitespace-only-text" {
  // White space inside an element is character data and must survive printing.
  let events : Array[@xml.Event] = [
    Start(name="a", attributes=Map([])),
    Text("\n  "),
    Start(name="b", attributes=Map([])),
    End("b"),
    Text("\t"),
    End("a"),
  ]
  assert_eq(@xml.parse(@xml.print(events)), events)
}
