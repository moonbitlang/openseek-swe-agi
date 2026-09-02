# YAML 1.2.2 — parser-oriented specification for this repo

This document is a **practical, test-oriented spec** for the `yaml`
package. It summarizes the required behavior of **YAML 1.2.2** loaded
under the **core schema**, and the conventions used by this repository's
MoonBit API and test suite.

It is **not** a verbatim copy of the YAML specification; the authoritative
text is vendored at `specs/1.2.2/spec.md`.

## Objectives (what the implementation must do)

The `yaml` package expects an implementation that can:

1. Parse a YAML 1.2.2 stream into the value defined by `yaml_spec.mbt`:
   an `Array[Yaml]` holding one `Yaml` node per document, loaded under
   the core schema (spec §10.3).
2. Reject every stream that is not well-formed YAML 1.2.2, or that cannot
   be loaded (undefined aliases, duplicate keys, invalid tagged content),
   by raising an error (any error type works; tests only assert that
   `parse` raises).
3. Print a stream back to YAML text with `print`, such that
   `parse(print(docs)) == docs` for every well-formed stream (checked by a
   property-based test over generated streams; the generators are shipped
   in `yaml_qc.mbt`).

## Primary references

- YAML 1.2.2 (local copy): `specs/1.2.2/spec.md`
- YAML 1.2.2 (online): https://yaml.org/spec/1.2.2/
- The YAML test suite, whose cases make up most of the tests:
  https://github.com/yaml/yaml-test-suite

## Dialect

The dialect is **YAML 1.2.2 with the core schema** (spec §10.3), applied
to the **whole stream**:

- every document of a stream is loaded and returned, in order (§9.2);
- a `%YAML 1.1` document is processed as 1.2 (§6.8.1): `yes`, `1_000`
  and `0o17` are a string, a string and the integer 15;
- YAML 1.1 type-repository tags (`!!set`, `!!omap`, `!!binary`,
  `!!timestamp`, ...) are not core tags: such nodes are loaded by their
  kind (a scalar's content as a string, a sequence, a mapping);
- everything is checked: an error in the third document is an error.

## Data model (from `yaml_spec.mbt`)

```
parse(input : StringView) -> Array[Yaml] raise
print(docs : Array[Yaml]) -> String

enum Yaml {
  Null
  Bool(Bool)
  Integer(BigInt)
  Float(Double)
  String(String)
  Sequence(Array[Yaml])
  Mapping(Map[Yaml, Yaml])
}
```

Mapping rules:

- **A stream is a list of documents.** The empty stream, a stream holding
  only comments, and a lone `...` all give `[]`. `---` starts a document
  (so `a\n---\n` is `[String("a"), Null]`) and `...` ends one. A document
  whose root node is empty (`---` alone, `--- # comment`) is `Null`.
- **Plain scalars resolve by the core-schema table** (§10.3.2, first match
  wins): `null`/`Null`/`NULL`/`~`/empty → `Null`;
  `true`/`True`/`TRUE`/`false`/`False`/`FALSE` → `Bool`;
  `[-+]?[0-9]+`, `0o[0-7]+`, `0x[0-9a-fA-F]+` → `Integer`;
  `[-+]?(\.[0-9]+|[0-9]+(\.[0-9]*)?)([eE][-+]?[0-9]+)?`,
  `[-+]?(\.inf|\.Inf|\.INF)`, `\.nan|\.NaN|\.NAN` → `Float`; anything
  else → `String`. So `1e3` and `5.` are floats, `007` and `0123` are the
  integers 7 and 123, and `yes`, `1_000`, `0b101`, `-.nan`, `12:30` and
  `2001-12-14` are strings.
- **Integer is a mathematical integer** (`BigInt`): the schema puts no
  bound on it, so `18446744073709551616` and `0x10000000000000000` load
  exactly.
- **Quoted and block scalars are always strings**: `'12'`, `"true"`,
  `| ...` and `> ...` never resolve.
- **Explicit standard tags** force a resolution on a scalar of any style:
  `!!str 12` is `String("12")`, `!!int "12"` is `Integer(12)`, `!!float 1`
  is `Float(1.0)`, `!!bool "TRUE"` is `Bool(true)`, `!!null ""` is `Null`.
  The tag's content rule still applies: `!!int abc`, `!!float 1_000`,
  `!!bool yes` and `!!null x` are errors (§3.3.3: content must satisfy the
  tag's constraints). Each tag applies to one kind: `!!str`, `!!int`, ...
  on a collection, `!!seq` on a mapping or a scalar, `!!map` on a sequence
  or a scalar, are errors. `!!seq` on a sequence and `!!map` on a mapping
  are fine. The `tag:yaml.org,2002:` forms reached through `%TAG` or a
  verbatim `!<tag:yaml.org,2002:int>` are the same tags.
- **Any other tag loads the node by its kind** (§3.3.2 / §10.1 failsafe
  kinds): the `!` non-specific tag, local tags (`!foo`), verbatim tags,
  named-handle tags and the 1.1 type-repository tags. A scalar's content
  becomes a `String` whatever it looks like (`!foo 12` is `String("12")`),
  a sequence stays a `Sequence`, a mapping a `Mapping` (`!!set` is a
  mapping with `Null` values, `!!omap` a sequence of one-pair mappings).
- **`%TAG` directives are honoured** when expanding shorthands: `%TAG !!
  tag:example.com,2000:app/` makes `!!int 12` a `String("12")`, `%TAG !e!
  tag:yaml.org,2002:` makes `!e!int "7"` an `Integer(7)`. A named handle
  used without a `%TAG` directive in the same document is an error; a
  `%TAG` directive scopes to the document it precedes (§6.8.2).
- **Anchors and aliases are resolved**: an alias is a copy of the most
  recent preceding node carrying that anchor (§7.1), as a value or as a
  key. An alias to an undefined anchor, an alias to an anchor from a
  previous document, an alias into a node still being loaded (`&a [*a]`),
  and properties on an alias are errors.
- **Mappings are maps with node keys.** Keys may be scalars of any type,
  sequences or mappings (§3.2.1.3). Two keys are the same key exactly
  when they are equal nodes: `1`, `0x1` and `!!int "1"` collide, while
  `1`, `1.0` and `"1"` are three distinct keys. A mapping with two equal
  keys, anywhere in the stream (block, flow, nested), is an error. Key
  order is not part of the value: mapping equality is map equality.
- **Sequences** preserve element order.
- **`Float` is an IEEE 754 binary64 value.** `-0.0` and `0.0` compare
  equal (IEEE), and the shipped `Eq` treats any `.nan` as equal to any
  other `.nan`.

## Equality

`Yaml` ships a fixed `Eq` implementation in `yaml_spec.mbt` (do not modify
it): structural equality, except floats compare by IEEE 754 equality with
NaN == NaN. It also ships a `Hash` consistent with that `Eq` (so `Yaml`
values can be `Map` keys). Tests compare whole streams with `assert_eq`.

## Syntax summary (YAML 1.2.2)

The vendored spec is authoritative; highlights the tests lean on:

### Characters and encoding

- The stream uses the printable character set of §5.1. A C0 control
  character other than tab, line feed and carriage return is an error
  anywhere (inside a double-quoted scalar they are written as escapes).
  DEL, the C1 controls other than U+0085, U+FFFE and U+FFFF are errors in
  node content outside quoted scalars; quoted scalars allow every non-C0
  character (JSON compatibility).
- Line breaks are LF, CRLF and a lone CR (§5.4).
- A byte order mark may start the stream or a document, and may appear
  inside quoted scalars; anywhere else in a document it is an error
  (§5.2).

### Documents and directives

- A stream holds zero or more documents. `---` (directives end marker)
  starts an explicit document; `...` (document end marker) ends one. A
  bare document needs neither.
- Directives (`%YAML`, `%TAG`, reserved `%FOO ...` which are ignored) are
  legal only at the start of the stream or after a `...` line, and must
  be followed by `---`. `%YAML` must name a `1.x` version (`1.1` is
  accepted and processed as 1.2); a repeated `%YAML`, or a repeated
  `%TAG` for the same handle in one document, is an error. Note that
  `foo\n%YAML 1.2` is a two-line plain scalar, not a directive.
- A block collection cannot start on the `---` line (`--- a: b` is an
  error); a flow node or block scalar can (`--- |`, `--- [a]`, `--- text`).

### Block structure

- Indentation is spaces only; a tab used as indentation is an error. Tabs
  are fine as separation white space (`key:<TAB>value`).
- Block sequences (`- a`), block mappings (`a: b`), explicit keys
  (`? key` / `: value`), compact nested collections (`- - a`, `- a: b`,
  `? - a`), and the indentation rules of §6.1 / §8.2. Explicit block keys
  may be collections.
- Block scalars: literal `|` and folded `>`, with the indentation
  indicator, chomping indicators (`-`, `+`, clip), the folding rules of
  §8.1.3, and more-indented lines.

### Flow structure

- Flow sequences `[a, b]` and flow mappings `{a: b}` may span lines and
  contain comments; trailing commas are allowed; `[a: b]` is a sequence
  holding a single-pair mapping; `{? k : v}` and `{? }` are explicit
  entries; keys may be quoted scalars or flow collections (`{[1, 2]: x}`).
- Plain scalars end at `: ` (or `:` followed by a flow indicator inside
  flow collections), ` #`, and — inside flow collections — at `,`, `[`,
  `]`, `{`, `}`; they cannot start with an indicator character (`%`, `@`,
  `` ` ``, ...).
- Single-quoted scalars have no escapes (`''` is a quote). Double-quoted
  scalars support exactly the escapes of §5.7 (`\0 \a \b \t \n \v \f \r
  \e \  \" \/ \\ \N \_ \L \P \xXX \uXXXX \UXXXXXXXX`); any other `\`
  sequence is an error. Multi-line flow scalars fold line breaks.

## Printing

`print` may choose any layout — only the round-trip contract matters.
The simplest sufficient strategy is one flow-style document per `--- `
line (`--- {"a": 1, "b": [true, null]}`), with every string double-quoted
and escaped. Things to get right:

- Quote every string, so that `"null"`, `"12"`, `".inf"`, `"- item"`,
  `"# comment"` and `""` come back as strings; escape `"`, `\`, line
  breaks and the C0 controls — a raw one is a parse error (escaping DEL,
  C1 controls and other non-printables too is the readable choice).
- Integers print in full (`BigInt::to_string`); floats must round-trip
  exactly (shortest-representation printing is sufficient), with an
  integral value keeping a `.` or exponent (`100.0`, not `100`) so it is
  still a `Float`, and `.inf`, `-.inf`, `.nan` for the non-finite values.
- Mapping keys of every kind must print: `null`, booleans, numbers and
  strings as flow scalars, sequences and mappings as flow collections (or
  as `? ` explicit entries).
- Every document of the stream is printed; `print([])` gives a stream
  with no documents (`""` is fine).

The well-formedness contract (which streams `print` must round-trip) is
documented on the `print` declaration in `yaml_spec.mbt`: no unpaired
surrogate code units in strings or keys; everything else is printable as
it is.

## Error handling

Any invalid input must raise from `parse`. The tests never inspect the
error message or type, so any raise-based error design works. They do,
however, cover a wide range of invalid inputs — lexical, structural,
directive placement, tag/content mismatches, duplicate keys, alias
problems — so precise validation matters much more than the shape of the
error value.
