# WHATWG URL — parser-oriented specification for this repo

This document is a **practical, test-oriented spec** for the `url`
package. It summarizes the behavior of the WHATWG URL Standard required
by this repository's API and test suite, and the conventions the suite
uses.

It is **not** a verbatim copy of the standard; the authoritative text is
vendored at `specs/url.bs` (Bikeshed source of https://url.spec.whatwg.org/).

## Objectives (what the implementation must do)

The `url` package expects an implementation that can:

1. Parse a URL string with the WHATWG **basic URL parser**, optionally
   resolving against a base `Url`, raising an error on any input the
   algorithm rejects.
2. Expose the parsed URL through the standard's getters (`href`,
   `protocol`, `username`, `password`, `host`, `hostname`, `port`,
   `pathname`, `search`, `hash`, `origin`).
3. Mutate the URL in place through the standard's setters
   (`set_href` … `set_hash`), which never raise.
4. Serialize canonically via `to_string` / `href`, such that parsing a
   serialization observes identically to the original — the standard's
   idempotence guarantee, checked by a property-based test over
   generated inputs (generators shipped in `url_qc.mbt`).

## Primary references

- WHATWG URL Standard (vendored snapshot): `specs/url.bs`
- WHATWG URL Standard (online): https://url.spec.whatwg.org/
- Web Platform Tests, `url/resources/urltestdata.json` and
  `setters_tests.json` — the upstream fixture files this suite's WPT
  tests transcribe:
  https://github.com/web-platform-tests/wpt/tree/master/url

## Dialect

The dialect is the **WHATWG URL Standard** — a living standard — as
captured by the vendored snapshot and its WPT fixture vintage. This is
*not* RFC 3986/3987: the WHATWG algorithm differs deliberately
(error-tolerant parsing, `\` as a path separator in special URLs,
tab/newline stripping, host canonicalization, IDNA, percent-encoding
rules). Where the two disagree, the WHATWG algorithm wins.

The whole suite (1220 fixture-derived cases) has been cross-validated
against a current mainstream implementation of the standard (Node.js
24 / Ada): every expected value in these tests matches it exactly.

## API contract (from `url_spec.mbt`)

```
type Url                                  // opaque, mutable
Url::parse(input : String, base? : Url) -> Url raise
Url::to_string(self) / Url::href(self) -> String
Url::protocol / username / password / host / hostname / port /
    pathname / search / hash / origin    -> String
Url::set_href / set_protocol / set_username / set_password / set_host /
    set_hostname / set_port / set_pathname / set_search / set_hash
                                          : (Url, String) -> Unit
```

- `parse` **raises** on failure (any error type; tests assert only that
  it raises). Setters **never raise** — invalid input leaves the URL
  unchanged, per the standard's setter steps.
- `Url` is deliberately opaque: the URL record layout is yours. Tests
  observe URLs only through getters.

### Getter semantics (all serialized forms)

- `protocol()` — scheme + `":"`.
- `username()` / `password()` — as stored (already percent-encoded by
  parsing/setters); `""` when absent.
- `hostname()` — serialized host without port: lowercase ASCII domain,
  dotted-decimal IPv4, bracketed compressed IPv6, or opaque host; `""`
  for an empty or absent host.
- `host()` — `hostname`, plus `":" + port` when a port is stored.
- `port()` — decimal digits, or `""` when no port is stored. Default
  ports (`http`/`ws` 80, `https`/`wss` 443, `ftp` 21) are never stored.
- `pathname()` — `"/" + segment + "/" + segment…` for list paths (dot
  segments were resolved during parsing), or the opaque path verbatim
  for opaque-path URLs (`mailto:`, `data:`, …).
- `search()` — `"?" + query`, or `""` when the query is null **or
  empty**; `hash()` — `"#" + fragment`, likewise.
- `origin()` — `scheme + "://" + host [ + ":" + port ]` for the special
  schemes other than `file:`; for `blob:` URLs the origin of the inner
  URL; the literal string `"null"` for every opaque origin (`file:`,
  non-special schemes, failures).

## Parsing summary (what the tests lean on)

The vendored standard is authoritative; highlights:

### Input preparation

- Remove leading/trailing C0 controls (U+0000–U+001F) and spaces.
- Remove **all** tabs (U+0009), LFs (U+000A), and CRs (U+000D).

### Scheme and relative references

- Scheme: ASCII alpha, then alphanumeric/`+`/`-`/`.`, then `:`;
  lowercased. Input without a (resolvable) scheme is a failure unless a
  `base` is supplied, in which case the WHATWG relative-resolution
  states apply (including the special-scheme `http:foo.com`-style
  "scheme-relative-ish" behavior and fragment/query-only references).
- Special schemes: `http`, `https`, `ws`, `wss`, `ftp`, `file`. Special
  URLs always have a host and a list path, treat `\` like `/`, and
  ignore the number of slashes after `scheme:` (with validation-error
  tolerance); non-special URLs distinguish `scheme://host/…` (authority)
  from `scheme:/…` (path-absolute) from `scheme:…` (opaque path).

### Credentials

- Everything before the **last** `@` in the authority is userinfo; the
  first `:` splits username/password. Both are percent-encoded with the
  userinfo encode set. `user:pass@` with empty host is a failure
  (host-missing).

### Hosts

- Special schemes parse hosts as **domains**: percent-decode, then
  domain-to-ASCII (UTS 46 with `beStrict=false` — lowercasing/mapping,
  punycode for non-ASCII labels), then reject forbidden domain code
  points.
- A domain whose last label is numeric-ish enters the **IPv4 parser**:
  decimal/`0x` hex/`0`-prefixed octal parts, at most 4 parts, the last
  part covering the remaining bytes; out-of-range parts or values are
  failures. Serialization is always dotted decimal.
- `[…]` is the **IPv6 parser** (with embedded IPv4 tails); serialization
  compresses the longest zero run with `::`.
- Non-special schemes get **opaque hosts**: forbidden host code points
  fail, other code points are kept, C0-and-friends get percent-encoded.
- `file:` hosts: `localhost` becomes the empty host.
- An empty host is a failure for non-`file` special schemes.

### Ports

- Decimal digits after the host `:`; value ≤ 65535 or failure; leading
  zeros allowed; a scheme's default port is dropped. An empty port
  (`http://h:/`) is allowed and means "no port".

### Paths

- Special (and non-opaque non-special) URLs: split on `/` (and `\` when
  special), percent-encode each segment with the path encode set,
  resolve `.` and `..` (including their percent-encoded spellings,
  case-insensitively) as you go. `file:` keeps a Windows drive letter
  first segment (`C:` / normalized from `C|`).
- Opaque paths (non-special `scheme:…` without slashes): kept as one
  string, C0-control encode set only — except that a U+0020 space
  immediately before the `?` or `#` terminator is percent-encoded
  (`"a:b ?c"` serializes as `a:b%20?c`, while interior spaces stay
  raw: `lolscheme:x x#x%20x`).

### Query and fragment

- `?…` starts the query (encode set: query, with extra characters for
  special schemes), `#…` starts the fragment (fragment encode set).

## Serialization

Serialization is canonical and deterministic:

- `scheme ":"`, then `"//" [userinfo "@"] host [":" port]` when a host
  is present (`file:` with empty host still serializes `file:///…`).
- When there is **no** host, a list path starting with an empty segment
  gets the `"/."` prefix (`foo:/.//p`) so reparsing cannot mistake
  `//…` for an authority — this is what keeps serialization idempotent.
- `"?" + query` when the query is non-null; `"#" + fragment` when the
  fragment is non-null (both may be empty strings, which the getters
  render as `""` but the serializer keeps: `http://h/?` has href
  `"http://h/?"`).

## Setters (WHATWG setter steps)

- `set_href(s)` — reparse `s` as a fresh absolute URL and replace
  everything (the only setter the tests use with valid input only).
- `set_protocol(s)` — parse `s` (trailing `:` optional) in scheme-start
  state; a special↔non-special switch, credentials/port with a
  cannot-have-them target, or `file` with empty host are rejected
  (URL unchanged).
- `set_username` / `set_password` — percent-encode (userinfo set) and
  store; no-ops when the URL has no host or is `file:`… i.e. "cannot
  have username/password/port".
- `set_host(s)` — parse in host state: updates host, and port when
  `:port` follows; a bare trailing `:` rejects. No-op for opaque paths.
- `set_hostname(s)` — parse in hostname state: `:` terminates, port
  untouched.
- `set_port(s)` — `""` clears; digits parse (leading digits only —
  `"8080stuff"` takes 8080; non-digit start rejects); > 65535 rejects;
  default port stores as null. No-op when the URL cannot have a port.
- `set_pathname(s)` — empty the path and parse in path-start state.
  No-op for opaque paths.
- `set_search(s)` — `""` sets the query to null; otherwise strip one
  leading `?` and parse in query state.
- `set_hash(s)` — `""` sets the fragment to null; otherwise strip one
  leading `#` and parse in fragment state.

## Error handling

Any rejected input must raise from `parse`. The tests never inspect the
error message or type, so any raise-based error design works. They do,
however, cover the full range of parse failures — missing scheme, bad
ports, empty special hosts, forbidden host code points, IPv4 overflow,
malformed IPv6, domain-to-ASCII failures — so precise failure detection
matters much more than the shape of the error value.

Validation errors in the standard's sense (non-fatal diagnostics) are
**not** part of this task's API.
