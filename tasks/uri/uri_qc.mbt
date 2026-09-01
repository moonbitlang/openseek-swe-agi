///|
/// Generators for well-formed URIs, used by the round-trip property test.
/// They stay inside the RFC 3986 grammar on purpose: every component draws
/// only from its own legal characters (plus whole percent-triplets), schemes
/// are generated lowercase so the permitted scheme normalization is a no-op,
/// and authority/path combinations follow Section 3.3 — with an authority
/// the path is empty or `/`-rooted, without one it never starts with `//`.
let unreserved_char : @quickcheck.Generator[Char] = @quickcheck.frequency() <| [
  (6, @quickcheck.char_range('a', 'z')),
  (2, @quickcheck.char_range('A', 'Z')),
  (2, @quickcheck.char_range('0', '9')),
  (1, @quickcheck.elements(['-', '.', '_', '~'])),
]

///|
let sub_delims_char : @quickcheck.Generator[Char] = @quickcheck.elements([
  '!', '$', '&', '\'', '(', ')', '*', '+', ',', ';', '=',
])

///|
let pct_atom : @quickcheck.Generator[String] = {
  let hex_digit = @quickcheck.frequency() <| [
    (2, @quickcheck.char_range('0', '9')),
    (1, @quickcheck.char_range('A', 'F')),
  ]
  hex_digit.zip_with(hex_digit, (hi, lo) => String::from_array(['%', hi, lo]))
}

///|
fn char_atom(
  chars : @quickcheck.Generator[Char],
) -> @quickcheck.Generator[String] {
  chars.map(c => String::from_array([c]))
}

///|
/// One "atom" of a component: a single character legal for that component,
/// or a whole percent-triplet. `extra` holds the characters a component
/// allows beyond unreserved / pct-encoded / sub-delims (RFC 3986 Section 2).
fn component_atom(extra : Array[Char]) -> @quickcheck.Generator[String] {
  let weighted = [
    (8U, char_atom(unreserved_char)),
    (1, pct_atom),
    (1, char_atom(sub_delims_char)),
  ]
  if extra.length() > 0 {
    weighted.push((1, char_atom(@quickcheck.elements(extra))))
  }
  @quickcheck.frequency(weighted)
}

///|
fn atom_text(
  atom : @quickcheck.Generator[String],
  min~ : Int,
  max~ : Int,
) -> @quickcheck.Generator[String] {
  @quickcheck.int_range(min, max).flat_map() <| len => {
    atom.array_with_size(len).map(a => a.join(""))
  }
}

///|
/// `ALPHA *( ALPHA / DIGIT / "+" / "-" / "." )`, lowercase so the permitted
/// scheme normalization cannot break the round-trip.
let scheme_gen : @quickcheck.Generator[String] = @quickcheck.char_range(
  'a', 'z',
).flat_map() <| first => {
  let rest_char = @quickcheck.frequency() <| [
    (6, @quickcheck.char_range('a', 'z')),
    (2, @quickcheck.char_range('0', '9')),
    (1, @quickcheck.elements(['+', '-', '.'])),
  ]
  atom_text(char_atom(rest_char), min=0, max=5).map(rest => {
    String::from_array([first]) + rest
  })
}

///|
let userinfo_gen : @quickcheck.Generator[String] = atom_text(
  component_atom([':']),
  min=0,
  max=8,
)

///|
/// A reg-name, or occasionally a fixed IPv6 / zoned-IPv6 / IPvFuture
/// literal (kept as exemplars; generating the literal grammars themselves
/// adds nothing to the round-trip property).
let host_gen : @quickcheck.Generator[String] = @quickcheck.frequency() <| [
  (6, atom_text(component_atom([]), min=0, max=10)),
  (
    1,
    @quickcheck.elements([
      "[::1]", "[2001:db8::8:800:200c:417a]", "[fe80::a%25en0]", "[v1.x]",
    ]),
  ),
]

///|
let port_gen : @quickcheck.Generator[String] = atom_text(
  char_atom(@quickcheck.char_range('0', '9')),
  min=0,
  max=4,
)

///|
/// pchar = unreserved / pct-encoded / sub-delims / ":" / "@"
let pchar_atom : @quickcheck.Generator[String] = component_atom([':', '@'])

///|
/// query = fragment = *( pchar / "/" / "?" )
let query_gen : @quickcheck.Generator[String] = atom_text(
  component_atom([':', '@', '/', '?']),
  min=0,
  max=10,
)

///|
/// `*( "/" segment )` — the path grammar when an authority is present
/// (path-abempty): empty or `/`-rooted, empty segments allowed.
let abempty_path_gen : @quickcheck.Generator[String] = @quickcheck.int_range(
  0, 3,
).flat_map() <| n => {
  atom_text(pchar_atom, min=0, max=6)
  .array_with_size(n)
  .map(segs => segs.map(s => "/" + s).join(""))
}

///|
/// Path without an authority: empty, `/` alone, path-absolute (its first
/// segment non-empty, so the result never starts with `//`), or rootless
/// (whose first segment may contain `:` because generated URIs always carry
/// a scheme).
let no_authority_path_gen : @quickcheck.Generator[String] = {
  let nz_segment = atom_text(pchar_atom, min=1, max=6)
  @quickcheck.frequency() <| [
    (1, @quickcheck.pure("")),
    (1, @quickcheck.pure("/")),
    (
      2,
      nz_segment.zip_with(abempty_path_gen, (first, rest) => "/" + first + rest),
    ),
    (2, nz_segment.zip_with(abempty_path_gen, (first, rest) => first + rest)),
  ]
}

///|
fn optional(
  gen : @quickcheck.Generator[String],
  present~ : UInt,
  absent~ : UInt,
) -> @quickcheck.Generator[String?] {
  @quickcheck.frequency() <| [
    (present, gen.map(v => Some(v))),
    (absent, @quickcheck.pure(None)),
  ]
}

///|
let uri_gen : @quickcheck.Generator[Uri] = scheme_gen.flat_map() <| scheme => {
  let tail = optional(query_gen, present=1, absent=1).zip(
    optional(query_gen, present=1, absent=1),
  )
  @quickcheck.frequency() <| [
    (
      3,
      optional(userinfo_gen, present=1, absent=2).flat_map() <| userinfo => {
        host_gen.flat_map() <| host => {
          optional(port_gen, present=1, absent=2).flat_map() <| port => {
            abempty_path_gen.flat_map() <| path => {
              tail.map(qf => {
                scheme,
                userinfo,
                host: Some(host),
                port,
                path,
                query: qf.0,
                fragment: qf.1,
              })
            }
          }
        }
      },
    ),
    (
      1,
      no_authority_path_gen.flat_map() <| path => {
        tail.map(qf => {
          scheme,
          userinfo: None,
          host: None,
          port: None,
          path,
          query: qf.0,
          fragment: qf.1,
        })
      },
    ),
  ]
}

///|
pub impl @quickcheck.Arbitrary for Uri with fn arbitrary(size, rand) {
  uri_gen.run(size, rand)
}

///|
/// Split a component into the units a shrink candidate may drop: single
/// characters, except that a percent-triplet stays whole so dropping a unit
/// can never produce a malformed encoding. Generated components are ASCII,
/// so per-character iteration is safe.
fn atoms(s : String) -> Array[String] {
  let chars = s.to_array()
  let out : Array[String] = []
  let mut i = 0
  while i < chars.length() {
    if chars[i] == '%' && i + 2 < chars.length() {
      out.push(String::from_array([chars[i], chars[i + 1], chars[i + 2]]))
      i += 3
    } else {
      out.push(String::from_array([chars[i]]))
      i += 1
    }
  }
  out
}

///|
/// All ways to drop one atom from a component, lazily. Results shorter than
/// `min_atoms` atoms are not produced.
fn drop_one_atom(s : String, min_atoms? : Int = 0) -> Iter[String] {
  let a = atoms(s)
  guard a.length() > min_atoms else { return Iter::empty() }
  a
  .iter()
  .mapi((i, _) => {
    let kept : Array[String] = []
    for j in 0..<a.length() {
      if j != i {
        kept.push(a[j])
      }
    }
    kept.join("")
  })
}

///|
/// The Section 3.3 shape constraints tying the path to the authority: with
/// an authority the path must be empty or `/`-rooted; without one it must
/// not start with `//` (which would re-parse as an authority).
fn valid_path_shape(path : String, has_authority~ : Bool) -> Bool {
  if has_authority {
    path == "" || path.has_prefix("/")
  } else {
    !path.has_prefix("//")
  }
}

///|
fn shrink_some(component : String?) -> Iter[String] {
  if component is Some(s) {
    drop_one_atom(s)
  } else {
    Iter::empty()
  }
}

///|
/// Every shrink candidate stays a well-formed URI: optional components are
/// dropped whole, atoms (single characters or whole percent-triplets) are
/// dropped one at a time, and candidates whose path shape would become
/// invalid for their authority form are filtered out — so a failing
/// property minimizes to another URI the round-trip genuinely must survive.
/// The core `Shrink for String` instance is deliberately not used: it also
/// mutates characters into a fixed set containing `'\n'` and `' '`, which
/// are illegal in URIs and would minimize toward counterexamples that fail
/// for the wrong reason. Bracketed host literals are treated as atomic for
/// the same reason.
pub impl @quickcheck.Shrink for Uri with fn shrink(self) {
  let has_authority = self.host is Some(_)
  let drop_fragment = self.fragment
    .iter()
    .map(_ => Uri::{ ..self, fragment: None, })
  let drop_query = self.query.iter().map(_ => Uri::{ ..self, query: None, })
  let drop_userinfo = self.userinfo
    .iter()
    .map(_ => Uri::{ ..self, userinfo: None, })
  let drop_port = self.port.iter().map(_ => Uri::{ ..self, port: None, })
  let drop_host = if self.userinfo is None &&
    self.port is None &&
    valid_path_shape(self.path, has_authority=false) {
    self.host.iter().map(_ => Uri::{ ..self, host: None, })
  } else {
    Iter::empty()
  }
  let shrunk_path = drop_one_atom(self.path)
    .filter(path => valid_path_shape(path, has_authority~))
    .map(path => Uri::{ ..self, path, })
  let shrunk_host = if self.host is Some(h) && !h.has_prefix("[") {
    drop_one_atom(h).map(host => Uri::{ ..self, host: Some(host), })
  } else {
    Iter::empty()
  }
  let shrunk_userinfo = shrink_some(self.userinfo).map(userinfo => Uri::{
    ..self,
    userinfo: Some(userinfo),
  })
  let shrunk_port = shrink_some(self.port).map(port => Uri::{
    ..self,
    port: Some(port),
  })
  let shrunk_query = shrink_some(self.query).map(query => Uri::{
    ..self,
    query: Some(query),
  })
  let shrunk_fragment = shrink_some(self.fragment).map(fragment => Uri::{
    ..self,
    fragment: Some(fragment),
  })
  // Never below one atom, and never left starting with a non-letter.
  let shrunk_scheme = drop_one_atom(self.scheme, min_atoms=1)
    .filter(s => s.to_array() is ['a'..='z', ..])
    .map(scheme => Uri::{ ..self, scheme, })
  drop_fragment
  .concat(drop_query)
  .concat(drop_userinfo)
  .concat(drop_port)
  .concat(drop_host)
  .concat(shrunk_path)
  .concat(shrunk_host)
  .concat(shrunk_userinfo)
  .concat(shrunk_port)
  .concat(shrunk_query)
  .concat(shrunk_fragment)
  .concat(shrunk_scheme)
}
