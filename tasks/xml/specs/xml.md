# XML 1.0 (Fifth Edition) — parser-oriented specification for this repo

This document is a **practical, test-oriented spec** for the `xml`
package. It summarizes the required behavior of an **XML 1.0 (Fifth
Edition) non-validating processor** and the conventions used by this
repository's MoonBit API and test suite.

It is **not** a verbatim copy of the XML specification; the authoritative
text is vendored verbatim at `specs/REC-xml-20081126.html` (the W3C
Recommendation of 26 November 2008; the section and production numbers
used below are those of the Recommendation).

## Objectives (what the implementation must do)

The `xml` package expects an implementation that can:

1. Parse an XML 1.0 document, given as a decoded character sequence, into
   the sequence of `Event`s defined in `xml_spec.mbt`, in document order.
2. Reject every input that is not a well-formed XML 1.0 document by
   raising an error (any error type works; tests only assert that `parse`
   raises).
3. Process the internal DTD subset the way section 5.1 requires of a
   non-validating processor: expand internal entities, normalize attribute
   values according to their declared types, and supply declared default
   attribute values.
4. Print an event sequence back to XML text with `print`, such that
   `parse(print(events)) == events` for every well-formed sequence
   (checked by a property-based test over generated documents; the
   generators are shipped in `xml_qc_test.mbt`).

## Primary references

- XML 1.0 (Fifth Edition), local copy: `specs/REC-xml-20081126.html`
- XML 1.0 (Fifth Edition), online: https://www.w3.org/TR/2008/REC-xml-20081126/
- The W3C XML Conformance Test Suite (the source of the `w3c/...` fixtures):
  https://www.w3.org/XML/Test/
- Namespaces in XML 1.0 — *not* implemented; see "Dialect".
- Canonical XML 1.0 (https://www.w3.org/TR/xml-c14n) — the precedent for
  representing every element as a start/end pair.

## Dialect

The dialect is **XML 1.0 Fifth Edition, well-formedness only**:

- **Non-validating.** Validity constraints (content models, ID/IDREF
  rules, `#REQUIRED` attributes, the DOCTYPE name matching the root, and
  so on) are not enforced. Well-formedness constraints are.
- **Only the document entity is read.** The external subset, external
  parsed entities and parameter entities are never fetched or expanded
  (section 5.1 permits this). What this implies for entity references is
  spelled out below.
- **Decoded input.** `parse` receives characters, not bytes, so the
  byte-level rules of section 4.3.3 (encoding detection, encoding/byte
  mismatches) cannot arise. The encoding declaration is checked for
  syntax (`EncName`, [81]) and reported as written; a leading U+FEFF is
  the byte order mark and is skipped.
- **No namespace processing.** Namespaces in XML is a separate
  Recommendation. Here `a:b` is an ordinary Name (the colon is a
  NameChar, [4]), `xmlns` and `xmlns:p` are ordinary attributes, an
  undeclared prefix is not an error, and names beginning with `xml` are
  allowed (section 2.3 reserves them without making them errors).
- **Fifth Edition names.** The `NameStartChar`/`NameChar` productions are
  the Fifth Edition's character ranges ([4], [4a]), including
  `[#x10000-#xEFFFF]`; U+00D7, U+00F7, U+037E and the like are excluded.
- **Any `1.x` version** is accepted (`VersionNum ::= '1.' [0-9]+`, [26]).

## Data model (from `xml_spec.mbt`)

```
parse(input : StringView) -> Array[Event] raise
print(events : Array[Event]) -> String

enum Event {
  Decl(version~ : String, encoding~ : String?, standalone~ : Bool?)
  DocType(String)
  Start(name~ : String, attributes~ : Map[String, String])
  End(String)
  Text(String)
  Comment(String)
  PI(target~ : String, data~ : String)
  EntityRef(String)
}
```

Mapping rules:

- **Document order.** Events appear in the order their markup appears in
  the document, including comments and processing instructions inside the
  internal DTD subset.
- **`Decl`** reports the XML declaration exactly as written: `encoding`
  and `standalone` are `None` when omitted; `standalone="yes"` is
  `Some(true)`, `"no"` is `Some(false)`.
- **`DocType`** carries the document type name only. External identifiers
  and the declarations of the internal subset are not part of the model;
  the declarations still affect parsing (see below).
- **`Start`/`End`** delimit every element. `<a/>` and `<a></a>` are the
  same element and both parse to `Start` followed by `End` (as in
  Canonical XML, where empty elements are written as start/end pairs).
- **Attributes are a map.** Section 3.1: the order of attribute
  specifications is not significant; a duplicate is a well-formedness
  error, so a map is exact. Keys are the attribute names as written
  (prefixes included). Values are the *normalized* values (section 3.3.3)
  after reference expansion and type-dependent white-space processing,
  and include attributes defaulted from the internal subset.
- **`Text`** is character data: literal text, CDATA-section content,
  characters produced by character references, and the character data of
  expanded entities, merged into one event per maximal run. Empty
  character data produces no event. Outside the root element only `Misc`
  (comments, PIs, white space) may appear, so there is never a `Text`
  event there.
- **`Comment`** is the text between `<!--` and `-->`, verbatim.
- **`PI`** is the target and the data after the white space that follows
  the target (`""` when there is none). Trailing white space is data.
- **`EntityRef`** is a reference in content that the parser recognized
  but did not expand (see "Entity references").

## Equality

`Event` derives `Eq`; `Map` equality ignores insertion order. Tests compare
whole event sequences with `assert_eq`.

## Syntax summary (XML 1.0 Fifth Edition)

The vendored Recommendation is authoritative; highlights the tests lean on:

### Document structure

- `document ::= prolog element Misc*` — exactly one root element; nothing
  but comments, PIs and white space before and after it.
- The XML declaration may appear only at the very start (after the byte
  order mark, if any): `<?xml` followed by white space, then `version`,
  optionally `encoding`, optionally `standalone`, in that order, each with
  `Eq ::= S? '=' S?` and a matching pair of quotes, then `S? '?>'`. A
  `<?xml ...?>` anywhere else, or a PI whose target matches `xml` in any
  letter case, is an error ([17]).
- A document type declaration may appear once, before the root element.
- Comments: `--` may not occur inside a comment, so `<!-- a -- b -->` and
  `<!-- a --->` are errors.
- PIs: `<?target?>` or `<?target S data?>`; data ends at the first `?>`.
- CDATA sections `<![CDATA[ ... ]]>` may appear only in content; `]]>`
  may not appear literally in character data ([14]).
- Every character of the document must match `Char` [2]: U+0000–U+0008,
  U+000B, U+000C, U+000E–U+001F, U+FFFE, U+FFFF and unpaired surrogates
  are errors anywhere, even inside comments or CDATA.

### Line ends (section 2.11)

Before parsing, every CRLF and every lone CR in the input is normalized to
a single LF. This applies to character data, attribute values, comments
and PI data alike. Characters produced by character references are never
normalized: `&#13;` yields a carriage return.

### Elements and attributes

- Tags nest properly (WFC: Element Type Match); `</a >` is allowed, `< a>`
  and `<a / >` are not.
- Attributes: `Name Eq AttValue`, quoted with `"` or `'`, separated by
  white space, unique within a tag (WFC: Unique Att Spec).
- An attribute value may not contain a literal `<` — not even through the
  replacement text of an entity it references (WFC: No < in Attribute
  Values). `&lt;` is fine, and so is an entity whose value is written as
  `&lt;` (the reference is bypassed when the replacement text is built,
  section 4.4.7), while an entity whose value is written as `&#60;` has a
  real `<` in its replacement text and is an error in an attribute value.
- Attribute-value normalization (section 3.3.3): literal white space
  characters (space, tab, LF — CR has already become LF) become spaces;
  character references contribute the referenced character; an entity
  reference contributes its replacement text processed by the same rules
  (so white space inside it becomes spaces). For an attribute declared
  with a tokenized type (`ID`, `IDREF`, `IDREFS`, `ENTITY`, `ENTITIES`,
  `NMTOKEN`, `NMTOKENS`, `NOTATION (...)`, or an enumeration) leading and
  trailing spaces are then discarded and runs of spaces (U+0020 only)
  collapse to one. `CDATA` and undeclared attributes keep their value.

### References

- Character references `&#N;` / `&#xH;` must denote a `Char` (WFC: Legal
  Character); values above U+10FFFF, however many digits, are errors —
  implementations must not overflow.
- Entity references `&Name;`: the five predefined entities always
  expand; other names resolve through the declarations of the internal
  subset (see "Entity references"). `&name` without `;`, `& `, and
  `&.x;` are errors.
- An entity may not contain a reference to itself, directly or
  indirectly (WFC: No Recursion).
- When an internal entity is referenced in content its replacement text
  is parsed as `content` and must be well-formed by itself: markup inside
  it produces events, an element opened inside it must be closed inside
  it, and it cannot close an element opened outside it (section 4.3.2).

### The internal DTD subset (section 2.8)

`<!DOCTYPE Name (S ExternalID)? S? ('[' intSubset ']' S?)? '>'`. The
internal subset is a sequence of markup declarations, comments, PIs, white
space and parameter-entity references `%Name;`, all checked for
well-formedness:

- `<!ELEMENT Name S contentspec S? '>'` with `EMPTY`, `ANY`, mixed content
  (`(#PCDATA)`, `(#PCDATA)*`, or `(#PCDATA|a|b)*` — with names the
  trailing `*` is required), or a children model of `,`/`|` groups with
  optional `?`, `*`, `+` (connectors in one group must agree).
- `<!ATTLIST Name (S Name S AttType S DefaultDecl)* S? '>'` with the
  types listed above and `#REQUIRED`, `#IMPLIED`, `#FIXED S AttValue`, or
  `AttValue`. Default values are attribute values: no `<`, references
  resolved, normalized per the declared type.
- `<!ENTITY Name S (EntityValue | ExternalID NDataDecl?) S? '>'` and
  `<!ENTITY % Name S (EntityValue | ExternalID) S? '>'`. In an entity
  value, character references are replaced when the replacement text is
  constructed and general-entity references are kept as written (section
  4.5). Parameter-entity references are forbidden within internal-subset
  markup declarations (WFC: PEs in Internal Subset), including inside an
  `EntityValue`, where `%Name;` is recognized. This is not a ban on the
  percent character: in attribute defaults, system/public literals,
  comments and PIs, `%Name;` is ordinary text. For example,
  `<!ATTLIST doc a1 CDATA "%e;">` supplies the literal default `%e;`.
  The `%` marker in `<!ENTITY % Name ...>` declares a parameter entity;
  it is not a reference and is allowed.
- `<!NOTATION Name S (ExternalID | PublicID) S? '>'`; public identifiers
  may only contain `PubidChar`s ([13]); system literals are free text.
- Conditional sections are not allowed in the internal subset.
- Comments and PIs inside the subset are reported as events; a `<?xml`
  text declaration is not allowed there.

## What the parser does with the declarations (section 5.1)

A non-validating processor must use the declarations it reads to
normalize attribute values, include the replacement text of internal
entities, and supply default attribute values — "up to the first reference
to a parameter entity that it does not read". This parser reads no
parameter entities, so:

- every declaration before the first `%name;` between declarations is
  used (the first declaration of an entity, and the first declaration of
  an attribute of an element, are the binding ones — sections 4.2, 3.3);
- declarations after that reference are still checked for well-formedness
  but are **not used** — unless the document says `standalone="yes"`,
  which asserts that no external markup declaration affects the document
  (section 2.9), in which case all declarations of the internal subset are
  used;
- an undeclared parameter entity, or a `%name;` whose entity was declared
  earlier, is not an error (for parameter entities "Entity Declared" is a
  validity constraint only).

The internal subset is used even when the DOCTYPE also names an external
subset (the internal subset is processed first, section 2.8).

## Entity references

How a reference `&name;` resolves depends on where it occurs and on what
the internal subset declared:

| the entity is ...                 | in content                    | in an attribute value |
|-----------------------------------|-------------------------------|-----------------------|
| `lt gt amp apos quot`             | the character                 | the character         |
| declared internal (`"..."`)       | replacement text, parsed      | replacement text, normalized |
| declared external (`SYSTEM`/`PUBLIC`) | `EntityRef(name)` (4.4.3)  | error (4.4.4)         |
| declared unparsed (`NDATA`)       | error (4.4.4)                 | error (4.4.4)         |
| undeclared, WFC applies           | error (WFC: Entity Declared)  | error                 |
| undeclared, WFC does not apply    | `EntityRef(name)`             | error (3.3.3)         |

"WFC applies" is the condition of section 4.1: the document has no DTD,
or it has only an internal subset containing no parameter-entity
reference, or it declares `standalone="yes"`. Otherwise the parser cannot
know whether the unread external subset or parameter entity declared the
name, so the reference is reported unexpanded, as an XML processor must
"inform the application that it recognized, but did not read, the
entity". In an attribute value there is nothing sensible to report — the
normalized value cannot be computed — and section 3.3.3 calls such a
reference an error, so the parser raises.

## Printing

`print` may choose any layout — only the round-trip contract matters. The
simplest sufficient strategy writes each event back as markup:
`<?xml ...?>`, `<!DOCTYPE name>`, `<name a="v">`, `</name>`, text,
`<!--text-->`, `<?target data?>`. Things to get right:

- Escape `<` and `&` in character data and attribute values, `"` in
  attribute values, and `>` in character data (or at least `]]>`).
- Write a carriage return as `&#13;` everywhere, and tab and line feed as
  `&#9;` / `&#10;` in attribute values, so that line-end normalization and
  attribute-value normalization cannot change them on re-parsing.
- Write the declaration parts that are present (`encoding`,
  `standalone`) and nothing else.
- `<?target?>` for a PI without data.
- No DTD is ever needed: the event model carries fully normalized
  attribute values and expanded entities.

The well-formedness contract (which event sequences `print` must
round-trip) is documented on the `print` declaration in `xml_spec.mbt`:
the document shape, non-empty non-adjacent `Text`, valid names, no `--`
or trailing `-` or carriage return in comments, no `?>` or carriage return
or leading white space in PI data, a `1.x` version and a valid encoding
name in the declaration, no `EntityRef`. `EntityRef` is excluded because
printing one requires a DTD with an external subset, which the model does
not carry; `print` may write it as `&name;`.

## Error handling

Any input that is not a well-formed XML 1.0 document must raise from
`parse`. The tests never inspect the error message or type, so any
raise-based error design works. They do, however, cover a wide range of
not-well-formed inputs — every well-formedness constraint, the grammar of
every declaration kind, illegal characters and names, reference syntax,
nesting — so precise checking matters much more than the shape of the
error value.
