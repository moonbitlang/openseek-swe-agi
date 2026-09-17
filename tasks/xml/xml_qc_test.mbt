///|
/// A well-formed event sequence for the round-trip property test:
/// `parse(print(doc.0)) == doc.0` must hold for every generated `QcDoc`.
///
/// Everything generated stays inside the printable dialect on purpose (see
/// `print` in `xml_spec.mbt`): names are valid XML Names, PI targets are
/// never `xml`, PI data never contains `?>` or a carriage return and never
/// starts with white space, comments never contain `--` or a carriage
/// return and never end with `-`, text events are non-empty and never
/// adjacent, attribute values and text reach every character a printer
/// must escape (`<`, `&`, `>`, quotes, tab, line feed, carriage return),
/// and the sequence always has the document shape: an optional
/// declaration and doctype, one element tree, and only comments and PIs
/// outside it.
pub(all) struct QcDoc(Array[@xml.Event]) derive(Debug)

///|
let qc_name_start_char : @quickcheck.Generator[Char] = @quickcheck.frequency([
  (6, @quickcheck.char_range('a', 'z')),
  (2, @quickcheck.char_range('A', 'Z')),
  (1, @quickcheck.elements(['_', ':', 'é', '中', 'Ω'])),
])

///|
let qc_name_char : @quickcheck.Generator[Char] = @quickcheck.frequency([
  (6, @quickcheck.char_range('a', 'z')),
  (2, @quickcheck.char_range('0', '9')),
  (1, @quickcheck.elements(['-', '.', '_', ':', '·', 'é', '中'])),
])

///|
/// `@quickcheck.int_range` is half-open; every bound in this file is inclusive.
fn qc_int(min : Int, max : Int) -> @quickcheck.Generator[Int] {
  @quickcheck.int_range(min, max + 1)
}

///|
fn qc_text(
  chars : @quickcheck.Generator[Char],
  min~ : Int,
  max~ : Int,
) -> @quickcheck.Generator[String] {
  qc_int(min, max).flat_map(len => {
    chars.array_with_size(len).map(cs => String::from_array(cs))
  })
}

///|
let qc_name_gen : @quickcheck.Generator[String] = qc_name_start_char.flat_map(first => {
  qc_text(qc_name_char, min=0, max=6).map(rest => first.to_string() + rest)
})

///|
let qc_pi_target_gen : @quickcheck.Generator[String] = qc_name_gen.map(t => {
  if t.equal_ignore_ascii_case("xml") {
    "pi"
  } else {
    t
  }
})

///|
/// Character data and attribute values: markup characters, quotes, `]`
/// (for `]]>`), and every kind of white space.
let qc_text_char : @quickcheck.Generator[Char] = @quickcheck.frequency([
  (6, @quickcheck.char_range('a', 'z')),
  (2, @quickcheck.char_range('0', '9')),
  (2, @quickcheck.elements([' ', '&', '<', '>', '"', '\'', ']', ';', '#'])),
  (1, @quickcheck.elements(['\n', '\t', '\r', '中', '好', '😀', 'é'])),
])

///|
let qc_text_gen : @quickcheck.Generator[String] = @quickcheck.frequency([
  (5, qc_text(qc_text_char, min=1, max=12)),
  // `]]>` may not appear literally in character data ([14] CharData)
  (1, qc_text(qc_text_char, min=0, max=5).map(s => s + "]]>")),
])

///|
let qc_attr_value_gen : @quickcheck.Generator[String] = qc_text(
  qc_text_char,
  min=0,
  max=10,
)

///|
let qc_attrs_gen : @quickcheck.Generator[Map[String, String]] = qc_int(0, 3).flat_map(n => {
    qc_name_gen
    .flat_map(k => qc_attr_value_gen.map(v => (k, v)))
    .array_with_size(n)
    .map(entries => {
      let out : Map[String, String] = Map([])
      for entry in entries {
        out[entry.0] = entry.1
      }
      out
    })
  },
)

///|
/// Comment content: an alphabet without `-` and without carriage return,
/// optionally prefixed with a safe single-dash token, so `--` and a
/// trailing `-` can never occur.
let qc_comment_char : @quickcheck.Generator[Char] = @quickcheck.frequency([
  (6, @quickcheck.char_range('a', 'z')),
  (2, @quickcheck.elements([' ', '<', '>', '&', '\n', '\t', '中'])),
])

///|
let qc_comment_gen : @quickcheck.Generator[String] = @quickcheck.frequency([
  (4, qc_text(qc_comment_char, min=0, max=10)),
  (1, qc_text(qc_comment_char, min=0, max=6).map(s => "a-b " + s)),
])

///|
/// PI data: empty, or starting with a letter; the alphabet has no `>` and
/// no carriage return, so `?>` can never occur.
let qc_pi_data_char : @quickcheck.Generator[Char] = @quickcheck.frequency([
  (6, @quickcheck.char_range('a', 'z')),
  (2, @quickcheck.elements([' ', '=', '"', '\'', '?', '<', '&', '\n'])),
])

///|
let qc_pi_data_gen : @quickcheck.Generator[String] = @quickcheck.frequency([
  (1, @quickcheck.pure("")),
  (
    3,
    @quickcheck.char_range('a', 'z').flat_map(first => {
      qc_text(qc_pi_data_char, min=0, max=8).map(rest => {
        first.to_string() + rest
      })
    }),
  ),
])

///|
let qc_misc_gen : @quickcheck.Generator[@xml.Event] = @quickcheck.frequency([
  (1, qc_comment_gen.map(c => Comment(c))),
  (
    1,
    qc_pi_target_gen.flat_map(t => qc_pi_data_gen.map(d => PI(target=t, data=d))),
  ),
])

///|
/// One element as an event span: `Start`, merged non-adjacent text and
/// child spans, `End`.
fn qc_element_gen(depth : Int) -> @quickcheck.Generator[Array[@xml.Event]] {
  qc_name_gen.flat_map(name => {
    qc_attrs_gen.flat_map(attrs => {
      let children_gen : @quickcheck.Generator[Array[Array[@xml.Event]]] = if depth <=
        0 {
        @quickcheck.pure([])
      } else {
        qc_int(0, 3).flat_map(n => {
          @quickcheck.frequency([
            (3, qc_text_gen.map(t => ([Text(t)] : Array[@xml.Event]))),
            (2, qc_element_gen(depth - 1)),
            (1, qc_misc_gen.map(m => [m])),
          ]).array_with_size(n)
        })
      }
      children_gen.map(chunks => {
        let out : Array[@xml.Event] = [Start(name~, attributes=attrs)]
        for chunk in chunks {
          for e in chunk {
            // merge adjacent text so the stream stays canonical
            if e is Text(t2) && out[out.length() - 1] is Text(t1) {
              out[out.length() - 1] = Text(t1 + t2)
            } else {
              out.push(e)
            }
          }
        }
        out.push(End(name))
        out
      })
    })
  })
}

///|
let qc_decl_gen : @quickcheck.Generator[@xml.Event] = @quickcheck.frequency([
  (2, @quickcheck.pure(Decl(version="1.0", encoding=None, standalone=None))),
  (
    1,
    @quickcheck.elements([
      Decl(version="1.0", encoding=Some("UTF-8"), standalone=None),
      Decl(version="1.0", encoding=Some("utf-8"), standalone=Some(true)),
      Decl(version="1.0", encoding=None, standalone=Some(false)),
      Decl(version="1.1", encoding=Some("ISO-8859-1"), standalone=Some(true)),
    ]),
  ),
])

///|
fn qc_misc_list(max : Int) -> @quickcheck.Generator[Array[@xml.Event]] {
  qc_int(0, max).flat_map(n => qc_misc_gen.array_with_size(n))
}

///|
fn qc_root_name(root : Array[@xml.Event]) -> String {
  if root[0] is Start(name~, ..) {
    name
  } else {
    "a"
  }
}

///|
let qc_doc_gen : @quickcheck.Generator[QcDoc] = qc_int(0, 2).flat_map(shape => {
  qc_element_gen(2).flat_map(root => {
    if shape == 0 {
      @quickcheck.pure(QcDoc(root))
    } else {
      qc_decl_gen.flat_map(decl => {
        qc_misc_list(1).flat_map(before => {
          qc_misc_list(1).flat_map(after => {
            qc_misc_list(1).map(epilog => {
              let events : Array[@xml.Event] = []
              if shape == 2 {
                events.push(decl)
              }
              events.append(before)
              if shape == 2 {
                events.push(DocType(qc_root_name(root)))
              }
              events.append(after)
              events.append(root)
              events.append(epilog)
              QcDoc(events)
            })
          })
        })
      })
    }
  })
})

///|
pub impl @quickcheck.Arbitrary for QcDoc with fn arbitrary(size, rand) {
  qc_doc_gen.run(size, rand)
}

///|
/// Index of the `End` event matching the `Start` at `i`.
fn qc_matching_end(events : Array[@xml.Event], i : Int) -> Int {
  let mut depth = 0
  for j in i..<events.length() {
    match events[j] {
      Start(..) => depth += 1
      End(_) => {
        depth -= 1
        if depth == 0 {
          return j
        }
      }
      _ => ()
    }
  }
  -1
}

///|
/// Index range [lo, hi) of the root element's events.
fn qc_root_span(events : Array[@xml.Event]) -> (Int, Int) {
  for i in 0..<events.length() {
    if events[i] is Start(..) {
      return (i, qc_matching_end(events, i) + 1)
    }
  }
  (0, 0)
}

///|
fn qc_slice(
  events : Array[@xml.Event],
  lo : Int,
  hi : Int,
) -> Array[@xml.Event] {
  let out : Array[@xml.Event] = []
  for i in lo..<hi {
    out.push(events[i])
  }
  out
}

///|
/// Shrinking preserves well-formedness: candidates drop the prolog and
/// epilog, drop single misc events outside the root, replace the whole
/// root element with `<a/>`, or simplify one event's payload in place
/// (renaming a `Start` also renames its matching `End`). Every candidate
/// is still a well-formed document, so the round-trip property never
/// minimizes to an unprintable counterexample.
pub impl @quickcheck.Shrink for QcDoc with fn shrink(self) {
  let events = self.0
  let out : Array[QcDoc] = []
  let (lo, hi) = qc_root_span(events)
  // 1. keep only the root element
  if lo > 0 || hi < events.length() {
    out.push(QcDoc(qc_slice(events, lo, hi)))
  }
  // 2. drop one misc event outside the root
  for i in 0..<events.length() {
    if i >= lo && i < hi {
      continue
    }
    let copy = events.copy()
    ignore(copy.remove(i))
    out.push(QcDoc(copy))
  }
  // 3. replace the root element span with <a/>
  let simple_start : @xml.Event = Start(name="a", attributes=Map([]))
  if hi - lo > 2 || (hi - lo == 2 && events[lo] != simple_start) {
    let copy = qc_slice(events, 0, lo)
    copy.push(simple_start)
    copy.push(End("a"))
    copy.append(qc_slice(events, hi, events.length()))
    out.push(QcDoc(copy))
  }
  // 4. simplify one event's payload in place
  for i in 0..<events.length() {
    let mut replacement : @xml.Event? = None
    let mut end_rename : Int = -1
    match events[i] {
      Decl(version~, encoding~, standalone~) =>
        if !(encoding is None && standalone is None) {
          replacement = Some(Decl(version~, encoding=None, standalone=None))
        }
      DocType(n) => if n != "a" { replacement = Some(DocType("a")) }
      Start(name~, attributes~) =>
        if name != "a" || attributes.length() > 0 {
          replacement = Some(Start(name="a", attributes=Map([])))
          if name != "a" {
            end_rename = qc_matching_end(events, i)
          }
        }
      Text(t) => if t != "a" { replacement = Some(Text("a")) }
      Comment(c) => if c != "" { replacement = Some(Comment("")) }
      PI(target~, data~) =>
        if target != "a" || data != "" {
          replacement = Some(PI(target="a", data=""))
        }
      End(_) | EntityRef(_) => ()
    }
    if replacement is Some(r) {
      let copy = events.copy()
      copy[i] = r
      if end_rename >= 0 {
        copy[end_rename] = End("a")
      }
      out.push(QcDoc(copy))
    }
  }
  out.iter()
}
