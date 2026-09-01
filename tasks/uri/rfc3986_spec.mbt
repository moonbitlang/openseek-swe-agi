///|
/// A parsed URI or relative reference, split into the components of the
/// RFC 3986 generic syntax (Section 3):
///
///     scheme ":" [ "//" authority ] path [ "?" query ] [ "#" fragment ]
///
/// Components are stored exactly as written in the input, still
/// percent-encoded; nothing is decoded. For the optional components `None`
/// means absent and `Some("")` means present but empty (`http://h/?` has
/// `query = Some("")`). The only permitted normalization is lowercasing the
/// scheme.
///
/// - `scheme` is `""` for a relative reference (RFC 3986 schemes are never
///   empty, so no ambiguity arises).
/// - `userinfo`, `host`, and `port` are the authority subcomponents:
///   `host` is `Some(_)` exactly when the input has an authority (`//`),
///   and `userinfo`/`port` can only be `Some(_)` when `host` is. IPv6 and
///   IPvFuture hosts keep their surrounding brackets (`Some("[::1]")`).
/// - `path` is always present, possibly empty.
/// - `query` and `fragment` are stored without their leading `?` / `#`.
pub(all) struct Uri {
  scheme : String
  userinfo : String?
  host : String?
  port : String?
  path : String
  query : String?
  fragment : String?
} derive(Eq, Debug)

///|
/// Parse a URI or relative reference per the RFC 3986 generic syntax.
///
/// Raises on invalid input: forbidden raw characters (spaces, `<>`, `\`,
/// `^`, backtick, `{}`, `|`, control characters), malformed
/// percent-encodings, invalid schemes, non-numeric ports, malformed
/// IPv6/IPvFuture literals, and ambiguous authorities.
declare pub fn Uri::parse(input : String) -> Uri raise

///|
/// Resolve `reference` against the base URI per the RFC 3986 Section 5.2
/// algorithm in strict mode (`http:g` stays `http:g`), including dot-segment
/// removal per Section 5.2.4. Raises when `reference` is not a valid
/// URI-reference.
declare pub fn Uri::resolve(base : Uri, reference : String) -> Uri raise

///|
/// Recompose the URI per RFC 3986 Section 5.3: exactly the components that
/// are present are emitted, with their `:`, `//`, `@`, `?`, `#` delimiters
/// appearing precisely when the corresponding component is present, even
/// when it is empty. `Uri::parse(uri.to_string()) == uri` must hold for
/// every well-formed `Uri` (components within the RFC 3986 grammar,
/// respecting the invariants documented on the struct); the round-trip is
/// checked by a property-based test.
declare pub fn Uri::to_string(self : Uri) -> String
