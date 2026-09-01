///|
/// A parsed WHATWG URL.
///
/// A `Url` is a mutable object wrapping a URL record in the sense of the
/// WHATWG URL Standard: scheme, username, password, host, port, path,
/// query, and fragment. Its internal representation is up to the
/// implementation — tests only observe a `Url` through the getters below
/// and mutate it through the setters, exactly like the `URL` interface
/// the standard defines for JavaScript.
declare pub type Url

///|
/// Parse an absolute or relative URL string with the WHATWG basic URL
/// parser, resolving against `base` when it is given.
///
/// Parameters:
///
/// - `input`: the URL string. Leading/trailing C0 controls and spaces are
///   stripped, and all tabs and newlines removed, before parsing.
/// - `base`: an already-parsed base URL for relative resolution.
///
/// Raises on any input the basic URL parser rejects: a missing or
/// unresolvable scheme, a bad port, a host that fails host parsing
/// (forbidden host code points, bad IPv4 numbers, malformed IPv6,
/// domain-to-ASCII failure), and the other failure cases of the state
/// machine. The error type is not specified; tests only assert that
/// `parse` raises.
///
/// Examples:
///
///     input                        serialization
///
///     "http://EXAMPLE.com:80/a/../b"   "http://example.com/b"
///
/// <!-- -->
///
///     "../d" against "http://h/a/b/c"  "http://h/a/d"
///
declare pub fn Url::parse(input : String, base? : Url) -> Url raise

///|
/// Serialize the URL with the WHATWG URL serializer. The result is
/// canonical: parsing it back and serializing again returns the same
/// string (checked by a property-based test over generated inputs; the
/// generators are shipped in `url_qc.mbt`).
declare pub fn Url::to_string(self : Url) -> String

///|
/// The `href` getter: identical to `to_string`.
declare pub fn Url::href(self : Url) -> String

///|
/// The scheme followed by `:`, e.g. `"http:"`.
declare pub fn Url::protocol(self : Url) -> String

///|
/// The username, percent-encoded as stored (`""` when absent).
declare pub fn Url::username(self : Url) -> String

///|
/// The password, percent-encoded as stored (`""` when absent).
declare pub fn Url::password(self : Url) -> String

///|
/// The host serialization, with `:port` appended when a (non-default)
/// port is present; `""` when the URL has no host.
declare pub fn Url::host(self : Url) -> String

///|
/// The host serialization without the port: a lowercased ASCII domain,
/// an IPv4 address in dotted decimal, an IPv6 address in brackets in its
/// canonical compressed form, or an opaque host. `""` when the URL has
/// an empty host or none.
declare pub fn Url::hostname(self : Url) -> String

///|
/// The port in decimal, or `""` when no port is stored (default ports
/// are never stored).
declare pub fn Url::port(self : Url) -> String

///|
/// The URL path serialization: `/`-joined segments for list paths (so
/// `""` never occurs for special-scheme URLs, which always have at least
/// one segment), or the opaque path itself for opaque-path URLs such as
/// `mailto:` and `data:`.
declare pub fn Url::pathname(self : Url) -> String

///|
/// `"?"` followed by the query, or `""` when the query is null or empty.
declare pub fn Url::search(self : Url) -> String

///|
/// `"#"` followed by the fragment, or `""` when the fragment is null or
/// empty.
declare pub fn Url::hash(self : Url) -> String

///|
/// The serialization of the URL's origin: scheme://host with the
/// explicit port when one is stored (`http`, `https`, `ws`, `wss`, and
/// `ftp` URLs, plus the origin of the URL inside a `blob:` URL), or
/// `"null"` for every opaque origin (`file:` and other schemes).
declare pub fn Url::origin(self : Url) -> String

///|
/// The `href` setter: reparse `href` from scratch as an absolute URL and
/// replace every component.
///
/// This is the one setter that reports failure. Per the standard's href
/// setter steps, an unparsable value throws a `TypeError` — here, raises
/// — before anything is written, so the URL is left unchanged. Every
/// other setter below is infallible: an invalid value is silently
/// ignored and the URL keeps its previous state.
declare pub fn Url::set_href(self : Url, href : String) -> Unit raise

///|
/// The `protocol` setter: parse `protocol` (an optional trailing `:` is
/// allowed) as a new scheme, keeping the URL unchanged when the scheme
/// is invalid or the special/non-special switch the standard forbids
/// would occur.
declare pub fn Url::set_protocol(self : Url, protocol : String) -> Unit

///|
/// The `username` setter: percent-encode with the userinfo set and
/// store. Does nothing when the URL cannot have credentials (no host,
/// or `file:` scheme).
declare pub fn Url::set_username(self : Url, username : String) -> Unit

///|
/// The `password` setter: percent-encode with the userinfo set and
/// store. Does nothing when the URL cannot have credentials.
declare pub fn Url::set_password(self : Url, password : String) -> Unit

///|
/// The `host` setter: parse `hostname[:port]` in host state, updating
/// host (and port, when given) on success. Ignored for opaque-path URLs.
declare pub fn Url::set_host(self : Url, host : String) -> Unit

///|
/// The `hostname` setter: like `set_host` but parsed in hostname state —
/// a `:` stops the parse, so the port is never changed.
declare pub fn Url::set_hostname(self : Url, hostname : String) -> Unit

///|
/// The `port` setter: `""` clears the port; otherwise parse leading
/// decimal digits, store the port when it is in range and not the
/// scheme's default. Does nothing when the URL cannot have a port.
declare pub fn Url::set_port(self : Url, port : String) -> Unit

///|
/// The `pathname` setter: reparse `pathname` in path start state,
/// replacing the old path. Ignored for opaque-path URLs.
declare pub fn Url::set_pathname(self : Url, pathname : String) -> Unit

///|
/// The `search` setter: `""` clears the query; otherwise parse (an
/// optional leading `?` is allowed) in query state with the
/// scheme-appropriate percent-encode set.
declare pub fn Url::set_search(self : Url, search : String) -> Unit

///|
/// The `hash` setter: `""` clears the fragment; otherwise parse (an
/// optional leading `#` is allowed) in fragment state.
declare pub fn Url::set_hash(self : Url, hash : String) -> Unit
