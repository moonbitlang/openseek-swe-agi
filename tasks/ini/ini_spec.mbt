///|
/// An INI document. `global` holds the entries that appear before any
/// section header (empty when there are none); `sections` maps each section
/// name to that section's key/value entries. Keys and values are plain
/// strings; no type inference is performed.
///
/// Duplicates collapse during parsing: a duplicate key within a section
/// takes the value of its last occurrence, and a repeated section header
/// re-opens the existing section. Equality of documents is map equality and
/// does not depend on iteration order.
pub(all) struct Doc {
  global : Map[String, String]
  sections : Map[String, Map[String, String]]
} derive(Eq, Debug)

///|
/// Parse INI text into a structured document
///
/// Parameters:
///
/// - `input`: INI text as StringView
///
/// Returns the parsed document (see `Doc`).
///
/// Raises a parse error on malformed input (malformed section headers, lines
/// without a separator, empty keys or keys holding a control character,
/// unterminated or mismatched quotes, invalid continuations).
///
/// Entry semantics:
///
/// - `=` and `:` both separate keys from values. The first one on the line
///   is the separator; every later `=` or `:` is value text, so
///   `url=http://host:8080/p?a=b` is one entry holding the whole URL
/// - Whitespace around keys, separators, and unquoted values is trimmed
/// - Quoted values keep whitespace and `;`/`#` verbatim and lose the
///   surrounding quotes. The closing quote is on the same line as the
///   opening one, followed only by whitespace or an inline comment
/// - Each carrier decodes its own set and leaves every other sequence
///   exactly as written, backslash included — `C:\Program` is itself,
///   because `\P` decodes to nothing else:
///   - unquoted: `\\`, `\n`, `\r`, `\t`
///   - `"..."`: those, and `\"`
///   - `'...'`: `\\` and `\'` only, so `'a\nb'` keeps its backslash and
///     `\'` is the one way to hold an apostrophe between single quotes
/// - `;` and `#` start comments (full-line, or inline after whitespace in an
///   unquoted value)
/// - A trailing `\` continues an unquoted value onto the next line, joining
///   the lines directly. Continuation is decided on the raw line before
///   escapes are applied: an odd-length run of trailing backslashes ends in
///   a marker, an even-length run is escaped literals. A marker with no
///   following line is an error. See `specs/ini.md`
/// - A continuation line contributes text, not syntax. Its `=`, `:`, quotes
///   and comment markers are ordinary characters of the joined value
///
/// Examples:
///
///     INI                     document
///
///     key=value               { global: { "key": "value" }, sections: Map([]) }
///
/// <!-- -->
///
///     [section]               { global: Map([]),
///     key=value                 sections: { "section": { "key": "value" } } }
///
/// <!-- -->
///
///     global=yes              { global: { "global": "yes" },
///     [section]                 sections: { "section": { "key": "value" } } }
///     key=value
///
/// <!-- -->
///
///     [section1]              { global: Map([]),
///     a=1                       sections: { "section1": { "a": "1" },
///     [section2]                            "section2": { "b": "2" } } }
///     b=2
///
declare pub fn parse(input : StringView) -> Doc raise

///|
/// Print a document back to INI text.
///
/// The exact text is unspecified, but it must parse back to an equal
/// document: `parse(print(doc)) == doc` for any well-formed document
/// (non-empty keys and section names valid per the dialect; values are
/// unrestricted).
///
/// Double quotes carry every value, since they keep whitespace, comment
/// characters and separators verbatim and escape the rest. The unquoted
/// form is trimmed at both ends and gives `;`/`#` and a trailing `\` their
/// special meanings, so it fits only a value that has none of them.
declare pub fn print(doc : Doc) -> String
