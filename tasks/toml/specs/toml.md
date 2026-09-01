# TOML v1.0.0 — parser-oriented specification for this repo

This document is a **practical, test-oriented spec** for the `toml`
package. It summarizes the required behavior of **TOML v1.0.0** and the
conventions used by this repository's MoonBit API and test suite.

It is **not** a verbatim copy of the TOML specification; the authoritative
text is vendored at `specs/v1.0.0.md`.

## Objectives (what the implementation must do)

The `toml` package expects an implementation that can:

1. Parse TOML v1.0.0 text into the document value defined by
   `toml_spec.mbt`: a `Map[String, Toml]` for the root table, with `Toml`
   values for everything below it.
2. Reject every input that is not a valid TOML v1.0.0 document by raising
   an error (any error type works; tests only assert that `parse` raises).
3. Print a document back to TOML text with `print`, such that
   `parse(print(doc)) == doc` for every well-formed document (checked by
   a property-based test over generated documents; the generators are
   shipped in `toml_qc.mbt`).

## Primary references

- TOML v1.0.0 (local copy): `specs/v1.0.0.md`
- TOML (online): https://toml.io/en/v1.0.0
- RFC 3339 for datetime lexical forms:
  https://www.rfc-editor.org/rfc/rfc3339

## Dialect

The dialect is **TOML v1.0.0 exactly** — the released standard, no more,
no less. In particular, features from the unreleased TOML 1.1 drafts are
**invalid** here and must be rejected:

- newlines and trailing commas in inline tables,
- `\x..` and `\e` string escapes,
- omitted seconds in times and date-times (`07:32` / `1979-05-27T07:32`).

## Data model (from `toml_spec.mbt`)

```
parse(input : StringView) -> Map[String, Toml] raise
print(doc : Map[String, Toml]) -> String

enum Toml {
  String(String)
  Integer(Int64)
  Float(Double)
  Bool(Bool)
  Datetime(Date, Time, offset~ : Int)
  LocalDatetime(Date, Time)
  LocalDate(Date)
  LocalTime(Time)
  Array(Array[Toml])
  Table(Map[String, Toml])
}

struct Date { year : Int; month : Int; day : Int }
struct Time { hour : Int; minute : Int; second : Int; nanosecond : Int }
```

Mapping rules:

- **Tables are maps.** The root table and every nested table (standard
  `[table]`, dotted keys, inline tables) become `Map[String, Toml]`. Key
  order is irrelevant: document equality is map equality. Keys are
  case-sensitive and stored exactly as written (after unescaping, for
  quoted keys).
- **Integer** is a signed 64-bit value. Decimal, hex (`0x`), octal
  (`0o`), and binary (`0b`) forms all map to the same `Int64`; an integer
  that does not fit in 64 signed bits is a parse error.
- **Float** is an IEEE 754 binary64 value: `1e6`, `1000000.0`, and
  `1_000_000.0` are all `Float(1.0e6)`. `inf`/`+inf`, `-inf`, and
  `nan`/`+nan`/`-nan` map to the corresponding double values (NaN sign is
  not observable — see equality below).
- **Datetime** (offset date-time) stores the *wall-clock* date and time
  as written, plus the UTC offset in minutes east: `Z` and `+00:00` both
  give `offset=0`, `-07:00` gives `offset=-420`. The `T` separator may be
  a space or lowercase `t`; `Z` may be lowercase `z`; neither choice is
  observable in the value.
- **Fractional seconds** map to `Time::nanosecond` (`.6` is
  600_000_000). Digits beyond nanosecond precision are truncated, not
  rounded.
- **Array** preserves element order. TOML v1.0.0 arrays may mix value
  types.

## Equality

`Toml` ships a fixed `Eq` implementation in `toml_spec.mbt` (do not modify
it): structural equality, except floats compare by IEEE 754 equality with
NaN == NaN. Tests compare whole documents with `assert_eq`.

## Syntax summary (TOML v1.0.0)

The vendored spec is authoritative; highlights the tests lean on:

### Document structure

- A document is a sequence of key/value pairs, `[table]` headers,
  `[[array-of-tables]]` headers, comments, and blank lines.
- Newlines are LF or CRLF. A bare CR is invalid anywhere.
- Comments run from `#` to end of line and may not contain control
  characters (U+0000–U+0008, U+000A–U+001F, U+007F).
- Control characters (other than tab) are invalid outside strings.

### Keys

- Bare keys: `A-Za-z0-9_-` (non-empty). Quoted keys: basic (`"..."`) or
  literal (`'...'`) single-line strings, including the empty key `""`.
- Dotted keys (`a.b.c = 1`) define sub-tables along the way. Whitespace
  around the dots is ignored.
- Defining the same key twice in the same table is an error, including a
  bare/quoted spelling of the same key (`a = 1` then `"a" = 2`).

### Tables and arrays of tables

- `[a.b]` defines table `b` inside `a`, creating intermediate tables
  implicitly. Defining the *same* table twice with headers is an error;
  a header may name a table previously created only implicitly by a
  deeper header, once.
- Dotted keys cannot extend a table that was defined by its own `[table]`
  header elsewhere, and a `[table]` header cannot re-open a table created
  by dotted keys.
- `[[arr]]` appends a table to the array `arr`, creating it if needed.
  Appending to (or stepping through) a *static* array (one written as a
  value, even an array of inline tables) is an error, as is redefining a
  table as an array or vice versa.
- Inline tables are immutable once closed: they cannot be extended by
  dotted keys or headers.

### Values

- **Strings**: basic `"..."` (escapes `\b \t \n \f \r \" \\ \uXXXX
  \UXXXXXXXX`; unknown escapes and out-of-range/surrogate code points are
  errors), literal `'...'` (no escapes), and the `"""..."""`/`'''...'''`
  multiline forms with the v1.0.0 rules (leading-newline trimming, line
  continuation `\` in multiline basic strings, up to two unescaped
  quotes inside, control-character restrictions).
- **Integers**: optional sign for decimal; `0x`/`0o`/`0b` (lowercase
  prefix, unsigned); `_` separators only between digits; no leading
  zeros in decimal.
- **Floats**: decimal with a dot (digits required on both sides) and/or
  exponent; `_` between digits; no leading zeros in the integer part
  (exponents may have them); `inf`/`nan` with optional sign.
- **Booleans**: `true` / `false` (lowercase only).
- **Datetimes**: RFC 3339 forms with real calendar validation (month
  1–12, day valid for the month/leap year, hour ≤ 23, minute ≤ 59,
  second ≤ 60, offset hour ≤ 23 and minute ≤ 59). Seconds are required.
  Year is exactly four digits.
- **Arrays**: `[ ... ]` — may span lines, allow comments between
  elements and a trailing comma.
- **Inline tables**: `{ k = v, ... }` — single line, no trailing comma,
  no newlines between the braces (values inside may still be multiline
  strings).

## Printing

`print` may choose any layout — only the round-trip contract matters.
The simplest sufficient strategy is one `key = value` line per root
entry, with nested tables as inline tables and strings as basic strings
with escapes. Things to get right:

- Quote keys that are not bare keys (any string — including `""` — is
  representable as a quoted key).
- Escape control characters, quotes, and backslashes in basic strings.
- Floats must round-trip exactly; shortest-representation printing (the
  usual `Double::to_string`) is sufficient, with `nan`/`inf`/`-inf`
  spelled as TOML keywords, and a `.0` appended when the representation
  has neither a dot nor an exponent.
- Datetimes print in RFC 3339 form (zero-padded fields, `Z` for offset
  0, fractional seconds only when nonzero).

The well-formedness contract (which documents `print` must round-trip)
is documented on the `print` declaration in `toml_spec.mbt`: no unpaired
surrogates in strings or keys, and date/time components within their
TOML ranges.

## Error handling

Any invalid input must raise from `parse`. The tests never inspect the
error message or type, so any raise-based error design works. They do,
however, cover a wide range of invalid inputs — lexical, numeric,
datetime, structural — so precise validation matters much more than the
shape of the error value.
