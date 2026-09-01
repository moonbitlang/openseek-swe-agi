# INI — parser-oriented specification for this repo

This document is a **practical, test-oriented spec** for the `ini`
package. INI does not have a single authoritative standard; this repo defines a
clear dialect via its API contract and tests.

It is intended to cover the behaviors exercised by `ini_pub_test.mbt` and
`ini_priv_test.mbt`.

## Objectives (what the implementation must do)

The `ini` package expects an implementation that can:

1. Parse INI text into the `Doc` representation used as the test oracle.
2. Reject malformed inputs by raising a parse error.
3. Print a document back to INI text such that parsing round-trips.

## Primary references (informative)

These are useful context for common INI dialects (non-normative for this repo):

- Python `configparser` behavior: https://docs.python.org/3/library/configparser.html
- systemd unit files: https://www.freedesktop.org/software/systemd/man/latest/systemd.syntax.html
- Git config format: https://git-scm.com/docs/git-config

The normative definition for this repository is the test suite plus `ini_spec.mbt`.

## API contract (from `ini_spec.mbt`)

- `parse(input : StringView) -> Doc raise`
- `print(doc : Doc) -> String`

### Document encoding (test oracle)

`Doc` separates the global entries from the named sections:

```
global_key=global_value     {
[section]                     global: { "global_key": "global_value" },
k=v                           sections: { "section": { "k": "v" } },
                            }
```

Rules:

- `global` holds the entries that appear before any section header; it is
  empty when there are none.
- `sections` maps each section name to its key/value entries (both strings);
  a duplicate key takes the value of its last occurrence.
- Empty sections are represented as empty maps.
- Document equality is map equality; it does not depend on iteration order.
- `print` must produce text that parses back to an equal document
  (`parse(print(doc)) == doc` for well-formed documents; see `ini_spec.mbt`).
  This is checked by a property-based test with generated documents.

## File structure and parsing rules

### Lines and whitespace

- Input is treated as lines separated by LF or CRLF (tests include CRLF).
- Blank lines are allowed anywhere and ignored.
- Leading whitespace before a key is allowed (tests: `edge/leading-whitespace`).
- Trailing whitespace after a value is allowed (tests: `edge/trailing-whitespace`).

### Comments

- Full-line comments begin with `;` or `#` (after optional leading whitespace).
- Inline comments are supported:
  - `key=value ; comment`
  - `key=value # comment`
- Comment characters inside **quoted** values are not treated as comments (tests
  include quoted values containing `;` and `#`).

### Sections

Section headers have the form:

```
[section name]
```

Rules required by the tests:

- Section names may include spaces and many punctuation characters.
- Empty section name `[]` is invalid.
- Section syntax must be exact:
  - Missing `[` or `]` is invalid.
  - Nested/double brackets like `[[nested]]` are invalid.
  - Certain bracket/angle-bracket forms in invalid tests must be rejected.
- A `[` appearing inside a value is not a section start; section recognition
  is line-based and must not trigger inside a value (tests include `invalid/section-in-value`).

If the same section header appears multiple times, it **overwrites** the prior
section map (“last one wins”) per `valid/section-overwrite`.

### Key/value entries

Key/value lines take one of these separator forms:

- `key=value`
- `key: value` (tests: `valid/colon-separator`)

Rules:

- Keys must be non-empty and must not be only whitespace (tests: `invalid/empty-key`,
  `invalid/key-only-spaces`).
- A line without a separator is invalid (`invalid/no-equals-sign`).
- Values may be empty (`key=` is valid).
- Keys are case-sensitive (tests: `edge/case-sensitivity`).
- Duplicate keys within the same section: **last one wins** (tests: `valid/duplicate-keys-last-wins`).

### Quoted values

Values may be quoted with either:

- Double quotes: `"..."` with escape support for embedded quotes as exercised by tests.
- Single quotes: `'...'` (tests include “complex quoted strings”).

Rules required by invalid tests:

- Unterminated quotes are invalid.
- Mismatched quote pairs are invalid.
- Multiple separators like `key=value=extra` are invalid unless the extra `=`
  appears inside quotes (tests include “value with equals” and “multiple equals
  without quotes”).
- This rule applies to the line as it is read, before any continuation is
  joined. A continuation line contributes text, not syntax: its `=`, `:`,
  quotes and comment markers are ordinary characters of the joined value.
  `path=C:\Program Files\` followed by `nextkey=value` is one entry whose
  value is `C:\Program Filesnextkey=value`, not a rejected double separator.

### Multiline values (backslash continuation)

- A line whose value ends in an **odd**-length run of trailing backslashes
  ends in a continuation marker: the marker is removed and the next line is
  joined on directly. An **even**-length run is escaped literals and the
  value ends there. "Multiline continuation: concatenation details" below
  gives the run-length table.
- A marker with no line after it is invalid
  (`invalid/backslash-continuation-no-newline`).
- A line that is not a continuation and carries no separator is invalid
  (`invalid/multiline-without-backslash`).

## Error conditions (must reject)

At minimum, the invalid test suite expects rejection for:

- Malformed section headers (unclosed, empty, missing bracket, nested brackets,
  quotes in section name, etc.).
- Missing separator in a key/value line.
- Empty or whitespace-only keys.
- Unterminated or mismatched quoted values.
- Multiple separators without quotes.
- Unpermitted multi-line forms (no trailing backslash continuation, dangling `\\`).
- Control characters in keys (tests include `invalid/control-characters-in-key`).

## Conformance checklist (high value test coverage)

- Global section `""` behavior
- `=` and `:` separators
- `;` and `#` comments (full-line and inline)
- Quoted values and escaped quotes
- Duplicate keys: last-wins
- Section redefinition: last-wins
- Backslash-based multiline values
- Unicode content in keys/values/sections
- CRLF line endings

## Formal-ish grammar (this repo’s dialect)

This is an implementation-oriented grammar; it is not meant to capture all
whitespace/comment subtleties:

```text
ini         := { line }*
line        := ws* ( comment | section | kv | empty ) ws* newline?
comment     := (';' | '#') { any }*
section     := '[' section_name ']'  (no extra '[' or ']' nesting)
kv          := key ws* sep ws* value
sep         := '=' | ':'
key         := nonempty, not all-whitespace, no control chars
value       := quoted | unquoted
quoted      := dq | sq
dq          := '\"' { dq_char } '\"'
sq          := '\\'' { sq_char } '\\''
unquoted    := { any }* (subject to inline comment stripping)
```

Newline:

- The tests include both LF and CRLF; treat CRLF as a single line break.

## Whitespace trimming vs preservation

The policy is:

- Around separators (`=`/`:`): surrounding whitespace is ignored for parsing.
- In unquoted values:
  - trailing inline comments are stripped
  - internal whitespace is preserved
  - leading and trailing whitespace is trimmed (`key=value  ` is `value`);
    quote the value to keep it. The one exception is a line ending in a
    continuation marker, where the whitespace before the marker belongs to
    the joined value — that is where the space in `a \` + `b` comes from.
- In quoted values:
  - preserve all characters inside quotes (including leading/trailing spaces)
  - comment markers `;` and `#` are literal characters

If you need an explicit rule: preserve value bytes exactly, except for (1)
removing the surrounding quotes in quoted values, (2) stripping inline
comments in unquoted values, (3) decoding escapes, and (4) removing a
continuation marker and joining the next line.

### Escape decoding

`"..."` and unquoted values decode `\"`, `\\`, `\n`, `\r` and `\t`. `'...'`
decodes only `\'`, which is the one way to put an apostrophe inside single
quotes; everything else between single quotes is raw.

Any sequence that is not one of those is left exactly as written, backslash
and all — `path=C:\Program Files` is itself, because `\P` decodes to nothing
else. This is what lets Windows paths be written plainly, and it is why the
trailing-backslash rule above has to count the run rather than ask whether a
backslash is "an escape".

## Inline comment stripping rules

The suite covers both `;` and `#` inline comments. A conservative rule that
matches common INI dialects and the test expectations is:

- For unquoted values, if a `;` or `#` appears after at least one whitespace
  separator, treat it as the start of an inline comment.
- Otherwise (no separating whitespace), treat it as part of the value.

Quoted values disable inline comment parsing entirely.

## Multiline continuation: concatenation details

A logical value continued over several lines is stored as a single string.
The lines are joined **directly**, with no separator: the trailing backslash
is removed and the next line is appended where it left off. `a\` + `b` is
`ab`, and the space in `a \` + `b` comes from the value, not the join — the
whitespace before a continuation marker is kept, so that line yields `a b`.

Continuation is decided on the raw line, **before** escape processing:

- Count the backslashes at the end of the line. An **odd**-length run ends in
  a continuation marker; an **even**-length run is escaped literals and the
  value ends there.
- So `path=C:\Program Files\` continues onto the next line — the marker does
  not care what the value holds or what the next line looks like — while
  `path=C:\Program Files\\` is the value `C:\Program Files\` and ends.
- A marker with no line after it has nothing to join to and is an error.

Writing `k=a` with N trailing backslashes, followed by a line `b=1`:

| N | line          | result                                    |
|---|---------------|-------------------------------------------|
| 1 | `k=a\`        | `k` = `ab=1` — joined, the line break gone |
| 2 | `k=a\\`       | `k` = `a\`, `b` = `1`                      |
| 3 | `k=a\\\`      | `k` = `a\b=1` — one literal, then joined   |
| 4 | `k=a\\\\`     | `k` = `a\\`, `b` = `1`                     |

A line break that ends a continued line is consumed. A line break *in* the
value is a different thing and is written with the `\n` escape: `k=a\\\n` is
`a\` followed by a newline, because its last character is `n`, leaving no
trailing backslash to act as a marker.

Order matters here. Deciding continuation *after* escapes have collapsed
`\\` into `\` makes an escaped trailing backslash indistinguishable from a
marker, and no rule recovers the difference.

## Keys and sections: validation details

Keys:

- Must not be empty after trimming outer whitespace.
- Must not contain control characters (tests include a `\\n` case).
- Are case-sensitive.
- May contain dots and dashes (tests cover both).

Sections:

- Section name is the substring inside `[...]` and may contain spaces/unicode.
- Reject empty/whitespace-only section names (tests include `invalid/section-only-spaces`).
- Reject nested brackets (`[[...]]`) and other malformed bracket patterns.

## Test suite mapping

- `ini_pub_test.mbt` / `ini_priv_test.mbt`: positive coverage for all rules
  above + real-world samples, and negative coverage for malformed
  headers/keys/quotes/continuations
- `ini_spec.mbt`: the `Doc` encoding contract used as oracle
- `ini_qc.mbt`: generators for the round-trip property test

