///|
pub(all) struct Doc(Array[Array[String]]) derive(Eq, Debug)

///|
pub fn Doc::length(self : Doc) -> Int {
  self.0.length()
}

///|
/// Parse CSV text into records of fields
///
/// Parameters:
///
/// - `input`: CSV text as StringView
///
/// Returns the parsed records, in input order: each record is an array of
/// field values. All field values are plain strings; no type inference is
/// performed.
///
/// Raises a parse error on malformed input (unterminated quotes, `"` inside
/// unquoted fields, non-separator text after a closing quote, inconsistent
/// field counts).
///
/// Field semantics:
///
/// - Empty fields are empty strings ("")
/// - Quoted fields have their surrounding quotes removed
/// - Escaped quotes (`""`) within quoted fields are unescaped
/// - Line breaks within quoted fields are preserved
///
/// Examples:
///
///     CSV                     records
///
///     a,b,c                   [["a", "b", "c"],
///     1,2,3                    ["1", "2", "3"]]
///
/// <!-- -->
///
///     name,age                [["name", "age"],
///     Alice,30                 ["Alice", "30"],
///     Bob,25                   ["Bob", "25"]]
///
/// <!-- -->
///
///     a,"b,c",d               [["a", "b,c", "d"],
///     1,"2,3",4                ["1", "2,3", "4"]]
///
/// <!-- -->
///
///     empty,,fields           [["empty", "", "fields"],
///     ,middle,                 ["", "middle", ""]]
///
declare pub fn parse(input : StringView) -> Doc raise

///|
declare pub fn print(doc : Doc) -> String
