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
/// without a separator, empty keys, unterminated or mismatched quotes,
/// multiple unquoted separators, invalid continuations).
///
/// Entry semantics:
///
/// - `=` and `:` both separate keys from values
/// - Whitespace around keys, separators, and unquoted values is trimmed
/// - Quoted values (`"..."` or `'...'`) keep their inner text verbatim
///   (including whitespace and `;`/`#`), with the surrounding quotes removed
/// - `;` and `#` start comments (full-line, or inline after whitespace in an
///   unquoted value)
/// - A trailing `\` continues an unquoted value onto the next line
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
/// (non-empty keys, section names valid per the dialect, and values free of
/// `\r` and `\\`). Values that carry whitespace, comment characters,
/// separators, or line breaks need quoting to survive the round-trip.
declare pub fn print(doc : Doc) -> String
