///|
/// A URL-shaped input string for the round-trip (idempotence) property
/// test: whenever `Url::parse` accepts the wrapped string, serializing
/// and reparsing must reproduce the same serialization.
///
/// Any string at all is a legal `QcUrlText` — inputs that `parse`
/// rejects make the property vacuously true — so generation only needs
/// to be *biased* toward parseable URLs (it mixes special and
/// non-special schemes, every host kind, credentials, ports, dot
/// segments, percent-encoding, Unicode, and stray tabs/newlines), and
/// shrinking can safely reuse the core `String` shrinker.
pub(all) struct QcUrlText(String) derive(Debug)

///|
fn qc_text(
  chars : @quickcheck.Generator[Char],
  min~ : Int,
  max~ : Int,
) -> @quickcheck.Generator[String] {
  @quickcheck.int_range(min, max).flat_map(len => {
    chars.array_with_size(len).map(cs => String::from_array(cs))
  })
}

///|
let qc_scheme_gen : @quickcheck.Generator[String] = @quickcheck.frequency([
  (3, @quickcheck.pure("http")),
  (2, @quickcheck.pure("https")),
  (1, @quickcheck.pure("ws")),
  (1, @quickcheck.pure("wss")),
  (1, @quickcheck.pure("ftp")),
  (2, @quickcheck.pure("file")),
  (2, @quickcheck.pure("foo")),
  (1, @quickcheck.pure("a-b+c.d")),
])

///|
let qc_label_char : @quickcheck.Generator[Char] = @quickcheck.frequency([
  (6, @quickcheck.char_range('a', 'z')),
  (2, @quickcheck.char_range('0', '9')),
  (1, @quickcheck.elements(['-', '_'])),
])

///|
let qc_domain_gen : @quickcheck.Generator[String] = @quickcheck.frequency([
  (
    5,
    @quickcheck.int_range(1, 3).flat_map(n => {
      qc_text(qc_label_char, min=1, max=6)
      .array_with_size(n)
      .map(labels => labels.join("."))
    }),
  ),
  (
    3,
    @quickcheck.elements([
      "localhost", "example.com", "EXAMPLE.COM", "xn--nxasmq5b.com", "bücher.de",
      "中文.com", "a_b.example",
    ]),
  ),
])

///|
let qc_ipv4_gen : @quickcheck.Generator[String] = @quickcheck.frequency([
  (
    3,
    @quickcheck.int_range(0, 255).flat_map(a => {
      @quickcheck.int_range(0, 255).map(b => "\{a}.0.\{b}.1")
    }),
  ),
  (
    2,
    @quickcheck.elements([
      "127.0.0.1", "0", "0x7f.1", "2130706433", "0300.168.0xF0", "1.2.3.4.5", "999.1.2.3",
    ]),
  ),
])

///|
let qc_ipv6_gen : @quickcheck.Generator[String] = @quickcheck.elements([
  "[::1]", "[::]", "[1:2:3:4:5:6:7:8]", "[::ffff:192.168.1.1]", "[2001:db8::1]",
  "[1:0:0:2::3]",
])

///|
let qc_host_gen : @quickcheck.Generator[String] = @quickcheck.frequency([
  (6, qc_domain_gen),
  (2, qc_ipv4_gen),
  (2, qc_ipv6_gen),
  (1, @quickcheck.pure("")),
])

///|
let qc_userinfo_gen : @quickcheck.Generator[String] = @quickcheck.frequency([
  (7, @quickcheck.pure("")),
  (
    2,
    @quickcheck.elements(["user@", "u:p@", "%C3%A9@", "a b@", "u:@", ":pass@"]),
  ),
])

///|
let qc_port_gen : @quickcheck.Generator[String] = @quickcheck.frequency([
  (7, @quickcheck.pure("")),
  (2, @quickcheck.int_range(0, 65535).map(p => ":\{p}")),
  (1, @quickcheck.elements([":80", ":443", ":21", ":008080", ":0"])),
])

///|
let qc_path_char : @quickcheck.Generator[Char] = @quickcheck.frequency([
  (8, @quickcheck.char_range('a', 'z')),
  (2, @quickcheck.char_range('0', '9')),
  (3, @quickcheck.elements(['.', '%', '~', '-', '_', ':', '@'])),
  (2, @quickcheck.elements([' ', '<', '>', '"', '`', '{', '}', '|', '^', '['])),
  (1, @quickcheck.elements(['é', '中', '😀', '\\', '\'', '&', '='])),
])

///|
let qc_path_gen : @quickcheck.Generator[String] = @quickcheck.frequency([
  (
    6,
    @quickcheck.int_range(0, 3).flat_map(n => {
      qc_text(qc_path_char, min=1, max=5)
      .array_with_size(n)
      .map(segs => if segs.is_empty() { "" } else { "/" + segs.join("/") })
    }),
  ),
  (
    2,
    @quickcheck.elements([
      "/a/./b", "/a/../b", "/..", "/%2e%2E", "/a//", "/C:/x", "/C|/x", "/%2e/", "/.//p",
      "/a\\b",
    ]),
  ),
])

///|
let qc_query_char : @quickcheck.Generator[Char] = @quickcheck.frequency([
  (8, @quickcheck.char_range('a', 'z')),
  (3, @quickcheck.elements(['=', '&', '+', '%', ' ', '\'', '"', '<', '>'])),
  (1, @quickcheck.elements(['é', '中', '😀'])),
])

///|
let qc_query_gen : @quickcheck.Generator[String] = @quickcheck.frequency([
  (5, @quickcheck.pure("")),
  (1, @quickcheck.pure("?")),
  (4, qc_text(qc_query_char, min=0, max=8).map(q => "?" + q)),
])

///|
let qc_fragment_gen : @quickcheck.Generator[String] = @quickcheck.frequency([
  (5, @quickcheck.pure("")),
  (1, @quickcheck.pure("#")),
  (4, qc_text(qc_query_char, min=0, max=8).map(f => "#" + f)),
])

///|
let qc_hier_gen : @quickcheck.Generator[String] = qc_scheme_gen.flat_map(scheme => {
  qc_userinfo_gen.flat_map(user => {
    qc_host_gen.flat_map(host => {
      qc_port_gen.flat_map(port => {
        qc_path_gen.flat_map(path => {
          qc_query_gen.flat_map(query => {
            qc_fragment_gen.map(fragment => {
              scheme + "://" + user + host + port + path + query + fragment
            })
          })
        })
      })
    })
  })
})

///|
let qc_opaque_gen : @quickcheck.Generator[String] = @quickcheck.elements([
  "mailto", "data", "javascript", "about", "a",
]).flat_map(scheme => {
  qc_text(qc_path_char, min=0, max=10).flat_map(path => {
    qc_query_gen.map(query => scheme + ":" + path + query)
  })
})

///|
let qc_fixed_gen : @quickcheck.Generator[String] = @quickcheck.elements([
  "file:///C:/a/b", "file://localhost/etc", "file:c:\\foo\\bar", "http://example.com:80/",
  "https://example.com:443/", "http://u:p@h/..", "non-special:/.//p", "foo:/.//x",
  "a:/..//y", "foo:/bar", "http:foo.com", "data:text/plain,hi", "mailto:a@b?x#y",
  "http://example\t.\norg", "https://@test@test@example:800/",
])

///|
/// Occasionally wrap the URL in the whitespace the parser must strip:
/// leading/trailing C0-or-space, and tabs/newlines anywhere.
fn qc_mangle(s : String) -> @quickcheck.Generator[String] {
  @quickcheck.frequency([
    (8, @quickcheck.pure(s)),
    (1, @quickcheck.pure("  " + s + " \n")),
    (
      1,
      @quickcheck.pure(
        match s.find(":") {
          Some(i) =>
            s.view(end_offset=i).to_owned() +
            "\t:\n" +
            s.view(start_offset=i + 1).to_owned()
          None => "\t" + s
        },
      ),
    ),
  ])
}

///|
let qc_url_gen : @quickcheck.Generator[String] = @quickcheck.frequency([
  (6, qc_hier_gen),
  (2, qc_opaque_gen),
  (1, qc_fixed_gen),
  (1, @quickcheck.spawn()),
]).flat_map(s => qc_mangle(s))

///|
pub impl @quickcheck.Arbitrary for QcUrlText with fn arbitrary(size, rand) {
  QcUrlText(qc_url_gen.run(size, rand))
}

///|
/// Shrinking just shrinks the wrapped string with the core instance:
/// every candidate is still a legal input for the idempotence property.
pub impl @quickcheck.Shrink for QcUrlText with fn shrink(self) {
  @quickcheck.Shrink::shrink(self.0).map(s => QcUrlText(s))
}
