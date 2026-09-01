///|
/// A calendar date (RFC 3339 `full-date`, e.g. `1979-05-27`).
pub(all) struct Date {
  year : Int
  month : Int
  day : Int
} derive(Eq, Debug)

///|
/// A time of day (RFC 3339 `partial-time`, e.g. `07:32:00.999`).
///
/// `nanosecond` holds the fractional second as a number of nanoseconds
/// (`07:32:00.5` has `nanosecond` 500_000_000). Fractional digits beyond
/// nanosecond precision are truncated, not rounded.
pub(all) struct Time {
  hour : Int
  minute : Int
  second : Int
  nanosecond : Int
} derive(Eq, Debug)

///|
/// A TOML value (the TOML v1.0.0 data model).
///
/// - `Integer` is a signed 64-bit integer; an integer outside that range
///   is a parse error.
/// - `Float` is an IEEE 754 binary64 value (including `inf`, `-inf`, and
///   `nan`).
/// - `Datetime` is an offset date-time; `offset` is the UTC offset in
///   minutes east (`Z` and `+00:00` both give 0, `-07:00` gives -420).
/// - `Table` is a map: key order is not part of the value, and equality
///   of tables is map equality.
pub(all) enum Toml {
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
} derive(Debug)

///|
/// Structural equality on TOML values. Identical to field-by-field
/// equality except for floats, which compare by IEEE 754 equality with
/// one adjustment: any `nan` equals any other `nan`, so documents
/// containing `nan` values remain comparable. (As in IEEE 754,
/// `-0.0 == 0.0`.)
pub impl Eq for Toml with fn equal(self, other) {
  match (self, other) {
    (String(a), String(b)) => a == b
    (Integer(a), Integer(b)) => a == b
    (Float(a), Float(b)) => a == b || (a.is_nan() && b.is_nan())
    (Bool(a), Bool(b)) => a == b
    (Datetime(d1, t1, offset=o1), Datetime(d2, t2, offset=o2)) =>
      d1 == d2 && t1 == t2 && o1 == o2
    (LocalDatetime(d1, t1), LocalDatetime(d2, t2)) => d1 == d2 && t1 == t2
    (LocalDate(a), LocalDate(b)) => a == b
    (LocalTime(a), LocalTime(b)) => a == b
    (Array(a), Array(b)) => a == b
    (Table(a), Table(b)) => a == b
    _ => false
  }
}

///|
/// Parse a TOML v1.0.0 document.
///
/// Parameters:
///
/// - `input`: TOML text as StringView
///
/// Returns the document's root table: a map from top-level keys to values.
///
/// Raises a parse error on any input that is not a valid TOML v1.0.0
/// document: syntax errors, invalid escapes, malformed numbers, dates or
/// times, out-of-range integers, duplicate keys, table redefinitions, and
/// the other structural rules of the spec.
///
/// Examples:
///
///     TOML                    document
///
///     a = 42                  { "a": Integer(42) }
///
/// <!-- -->
///
///     [tbl]                   { "tbl": Table({ "a": Integer(42) }) }
///     a = 42
///
/// <!-- -->
///
///     a = ["x", 2]            { "a": Array([String("x"), Integer(2)]) }
///
/// <!-- -->
///
///     [[arr]]                 { "arr": Array([
///     a = 1                     Table({ "a": Integer(1) }),
///     [[arr]]                   Table({ "a": Integer(2) }),
///     a = 2                   ]) }
///
declare pub fn parse(input : StringView) -> Map[String, Toml] raise
