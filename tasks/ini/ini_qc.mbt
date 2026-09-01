///|
/// Generators for well-formed documents, used by the round-trip property
/// test. Keys and section names stay inside the dialect on purpose:
/// non-empty, and without separators, comment markers, quotes, or brackets.
///
/// Values are unrestricted, so the generator reaches the characters that
/// carry a meaning somewhere in the grammar — the separators `=` and `:`,
/// the comment markers `;` and `#`, both quotes, `\` and `\r`, and a line
/// break. Each of those forces a choice of carrier, and `\` and `\r` also
/// have to survive whichever one is chosen.
let name_char : @quickcheck.Generator[Char] = @quickcheck.frequency() <| [
  (5, @quickcheck.char_range('a', 'z')),
  (2, @quickcheck.char_range('0', '9')),
  (2, @quickcheck.elements(['_', '-', '.'])),
  (1, @quickcheck.elements(['中', 'é', 'Ω'])),
]

///|
let value_char : @quickcheck.Generator[Char] = @quickcheck.frequency() <| [
  (5, @quickcheck.char_range('a', 'z')),
  (2, @quickcheck.char_range('0', '9')),
  (2, @quickcheck.elements([' ', ',', '=', ':', ';', '#', '"', '\''])),
  (1, @quickcheck.elements(['\\', '\n', '\r', '\t'])),
  (1, @quickcheck.elements(['你', '好', '😀', 'é'])),
]

///|
fn text(
  chars : @quickcheck.Generator[Char],
  min~ : Int,
  max~ : Int,
) -> @quickcheck.Generator[String] {
  @quickcheck.int_range(min, max).flat_map() <| len => {
    chars.array_with_size(len).map(cs => String::from_array(cs))
  }
}

///|
let key_gen : @quickcheck.Generator[String] = text(name_char, min=1, max=8)

///|
let section_name_gen : @quickcheck.Generator[String] = @quickcheck.int_range(
  1, 3,
).flat_map() <| words => {
  text(name_char, min=1, max=6).array_with_size(words).map(ws => ws.join(" "))
}

///|
let entry_gen : @quickcheck.Generator[(String, String)] = key_gen.flat_map() <| key => {
  text(value_char, min=0, max=10).map(value => (key, value))
}

///|
let fields_gen : @quickcheck.Generator[Map[String, String]] = @quickcheck.int_range(
  0, 4,
).flat_map() <| n => {
  entry_gen
  .array_with_size(n)
  .map(entries => {
    let out : Map[String, String] = Map([])
    for entry in entries {
      out[entry.0] = entry.1
    }
    out
  })
}

///|
let section_gen : @quickcheck.Generator[(String, Map[String, String])] = section_name_gen.flat_map() <| name => {
  fields_gen.map(fields => (name, fields))
}

///|
let doc_gen : @quickcheck.Generator[Doc] = fields_gen.flat_map() <| global => {
  @quickcheck.int_range(0, 4).flat_map() <| count => {
    section_gen
    .array_with_size(count)
    .map(secs => {
      let sections : Map[String, Map[String, String]] = Map([])
      for sec in secs {
        sections[sec.0] = sec.1
      }
      { global, sections, }
    })
  }
}

///|
pub impl @quickcheck.Arbitrary for Doc with fn arbitrary(size, rand) {
  doc_gen.run(size, rand)
}

///|
/// Lazy shrink candidates for one set of fields: drop an entry, or shrink an
/// entry's value via the String instance — safe because its candidates only
/// delete characters or mutate them into a fixed printable set, so values
/// stay inside the dialect. Keys are never shrunk: shrinking one to "" would
/// leave the dialect and minimize toward misleading counterexamples.
fn shrink_fields(fields : Map[String, String]) -> Iter[Map[String, String]] {
  let dropped = fields
    .iter()
    .map(kv => {
      let shrunk = fields.copy()
      shrunk.remove(kv.0)
      shrunk
    })
  let value_shrunk = fields
    .iter()
    .flat_map(kv => {
      let (k, v) = kv
      @quickcheck.Shrink::shrink(v).map(value => {
        let shrunk = fields.copy()
        shrunk[k] = value
        shrunk
      })
    })
  dropped.concat(value_shrunk)
}

///|
/// Shrinking drops a section, drops an entry, or shrinks a value, so every
/// candidate stays a well-formed document. The core
/// `Shrink for Map` instance is deliberately not used: it also shrinks keys
/// (down to ""), which leaves the dialect, makes the property fail for
/// unrelated reasons, and minimizes toward misleading counterexamples.
pub impl @quickcheck.Shrink for Doc with fn shrink(self) {
  let dropped_sections = self.sections
    .iter()
    .map(kv => {
      let (k, _) = kv
      let sections = self.sections.copy()
      sections.remove(k)
      { global: self.global, sections, }
    })
  let shrunk_global = shrink_fields(self.global).map(global => Doc::{
    global,
    sections: self.sections,
  })
  let shrunk_sections = self.sections
    .iter()
    .flat_map(kv => {
      let (k, v) = kv
      shrink_fields(v).map(shrunk => {
        let sections = self.sections.copy()
        sections[k] = shrunk
        { global: self.global, sections, }
      })
    })
  dropped_sections.concat(shrunk_global).concat(shrunk_sections)
}
