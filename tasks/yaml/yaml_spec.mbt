///|
/// A YAML node, loaded under the YAML 1.2.2 core schema (spec §10.2 and
/// §10.3).
///
/// - `Null`, `Bool`, `Integer`, `Float` and `String` are the core-schema
///   scalar types. `Integer` is a mathematical integer — the schema puts no
///   bound on it, so it is a `BigInt`. `Float` is an IEEE 754 binary64
///   value; `.inf`, `-.inf` and `.nan` are floats too.
/// - `Sequence` keeps element order.
/// - `Mapping` is an unordered set of key/value pairs whose keys are unique
///   (§3.2.1.3). Keys are nodes like any other — a scalar of any type, a
///   sequence or a mapping — and two keys are the same key exactly when they
///   are equal nodes, so `1`, `1.0` and `"1"` are three distinct keys.
///   Mapping equality is map equality: entry order is not part of the value.
pub(all) enum Yaml {
  Null
  Bool(Bool)
  Integer(BigInt)
  Float(Double)
  String(String)
  Sequence(Array[Yaml])
  Mapping(Map[Yaml, Yaml])
} derive(Debug)

///|
/// Structural equality on YAML nodes. Identical to field-by-field equality
/// except for floats, which compare by IEEE 754 equality with one
/// adjustment: any `nan` equals any other `nan`, so documents containing
/// `.nan` remain comparable. (As in IEEE 754, `-0.0 == 0.0`.)
pub impl Eq for Yaml with fn equal(self, other) {
  match (self, other) {
    (Null, Null) => true
    (Bool(a), Bool(b)) => a == b
    (Integer(a), Integer(b)) => a == b
    (Float(a), Float(b)) => a == b || (a.is_nan() && b.is_nan())
    (String(a), String(b)) => a == b
    (Sequence(a), Sequence(b)) => a == b
    (Mapping(a), Mapping(b)) => a == b
    _ => false
  }
}

///|
/// Hashing consistent with the `Eq` above, so that nodes can be mapping
/// keys: all `nan` values hash alike, `0.0` and `-0.0` hash alike, and a
/// mapping hashes independently of its entry order.
pub impl Hash for Yaml with fn hash_combine(self, hasher) {
  match self {
    Null => hasher.combine_int(0)
    Bool(b) => {
      hasher.combine_int(1)
      hasher.combine_bool(b)
    }
    Integer(i) => {
      hasher.combine_int(2)
      hasher.combine(i)
    }
    Float(f) => {
      hasher.combine_int(3)
      if f.is_nan() {
        hasher.combine_int(0)
      } else if f == 0.0 {
        hasher.combine_double(0.0)
      } else {
        hasher.combine_double(f)
      }
    }
    String(s) => {
      hasher.combine_int(4)
      hasher.combine_string(s)
    }
    Sequence(items) => {
      hasher.combine_int(5)
      for item in items {
        hasher.combine(item)
      }
    }
    Mapping(entries) => {
      hasher.combine_int(6)
      let mut acc = 0
      for key, value in entries {
        acc += Hash::hash(key) * 31 + Hash::hash(value)
      }
      hasher.combine_int(acc)
    }
  }
}

///|
/// Parse a YAML 1.2.2 stream and return its documents, in order.
///
/// Parameters:
///
/// - `input`: YAML text as StringView. The stream is the view's window;
///   `to_owned()` materializes exactly that.
///
/// A stream holds zero or more documents (§9.2): an empty stream, or one
/// holding only comments, gives `[]`; `---` separates documents; `...` ends
/// one. A document whose root node is empty (`---` alone, `--- # comment`)
/// is `Null`. Every document is loaded under the core schema (§10.3):
///
/// - plain scalars resolve by the core-schema regular expressions —
///   `null`/`Null`/`NULL`/`~` and the empty scalar are `Null`;
///   `true`/`True`/`TRUE` and `false`/`False`/`FALSE` are `Bool`;
///   `[-+]?[0-9]+`, `0o[0-7]+` and `0x[0-9a-fA-F]+` are `Integer`;
///   `[-+]?(\.[0-9]+|[0-9]+(\.[0-9]*)?)([eE][-+]?[0-9]+)?`, `[-+]?\.inf`
///   (any of `.inf`/`.Inf`/`.INF`) and `.nan`/`.NaN`/`.NAN` are `Float`;
///   anything else is a `String`. Quoted and block scalars are always
///   strings;
/// - the standard tags `!!null`, `!!bool`, `!!int`, `!!float` and `!!str`
///   (and their `tag:yaml.org,2002:` forms, via `%TAG` or `!<...>`) force
///   that resolution on a scalar of any style: `!!str 12` is `String("12")`
///   and `!!int "12"` is `Integer(12)`. A node whose content is not valid
///   for its tag (`!!int abc`), or whose kind does not match it (`!!str`
///   on a sequence, `!!seq` on a scalar) is an error (§3.3.3). `!!seq` and
///   `!!map` accept a sequence or a mapping respectively;
/// - any other tag — the `!` non-specific tag, local tags, tags of
///   YAML 1.1's type repository such as `!!set`, `!!omap` and `!!binary`,
///   verbatim and named-handle tags — has no native type here, so the node
///   is loaded by its kind (§3.3.2, §10.1): a scalar is its content as a
///   `String`, a sequence a `Sequence`, a mapping a `Mapping`. `%TAG`
///   directives are honoured when expanding tag shorthands, and a named
///   handle used without a `%TAG` directive in the same document is an
///   error (§6.8.2);
/// - anchors and aliases are resolved: an alias is a copy of the most
///   recent preceding node carrying the anchor (§7.1). An alias to an
///   undefined anchor, or one that refers back into a node still being
///   loaded (a cycle, which no finite tree can represent), is an error;
/// - a mapping with two equal keys is an error (§3.2.1.3). Keys compare as
///   loaded nodes: `1` and `0x1` collide, `1` and `"1"` do not.
///
/// Raises a parse error on any input that is not well-formed under YAML
/// 1.2.2: a C0 control character other than tab, line feed and carriage
/// return anywhere in the stream (§5.1; in a double-quoted scalar they are
/// written as escapes); DEL, a C1 control other than U+0085, U+FFFE, U+FFFF
/// or a byte order mark in node content outside a quoted scalar (§5.1 —
/// quoted scalars allow every non-C0 character, for JSON compatibility;
/// §5.2 — a byte order mark may also start the stream or a document),
/// bad block indentation (tabs used as indentation included),
/// unterminated quoted scalars or flow collections, invalid double-quote
/// escapes, content trailing a completed node, a directive that is not
/// followed by `---` or not preceded by `...`, a repeated `%YAML` directive,
/// a malformed `%YAML` version, and the other structural rules of the spec.
/// `%YAML 1.1` documents are processed as 1.2 (§6.8.1). The whole stream is
/// checked: an error in a later document is an error.
///
/// Examples:
///
///     YAML                    documents
///
///     a: 1                    [Mapping(Map([
///     b: two                    (String("a"), Integer(1)),
///                               (String("b"), String("two")),
///                             ]))]
///
/// <!-- -->
///
///     - 0x1A                  [Sequence([Integer(26), String("str"), Null, Bool(true)])]
///     - !!str str
///     - ~
///     - true
///
/// <!-- -->
///
///     top:                    [Mapping(Map([
///       x: [1, 2.5]             (String("top"), Mapping(Map([
///                                 (String("x"), Sequence([Integer(1), Float(2.5)])),
///                               ]))),
///                             ]))]
///
/// <!-- -->
///
///     ---                     [String("first"), String("second")]
///     first
///     ---
///     second
///
declare pub fn parse(input : StringView) -> Array[Yaml] raise

///|
/// Print a stream of documents back to YAML text.
///
/// The exact text is unspecified — any YAML 1.2.2 that `parse` accepts is
/// fine — but it must parse back to an equal stream:
/// `parse(print(docs)) == docs` for any well-formed stream. Well-formed
/// means that every string in the stream (mapping keys included, `""` too)
/// contains no unpaired surrogate code units; every other node is
/// printable as it is: every `BigInt`, every `Double` (`.inf`, `-.inf` and
/// `.nan` have plain-scalar spellings), every sequence, and every mapping
/// with keys of any kind (explicit `?` entries, or flow-style keys, cover
/// non-scalar keys).
///
/// This range is exactly what `parse` can produce, so `print` accepts
/// everything `parse` returns. Numbers must round-trip exactly
/// (shortest-representation printing is sufficient, as long as an integral
/// float keeps a `.` or exponent so it stays a `Float`); `.nan` prints as a
/// NaN value, which the shipped `Eq` treats as equal to any other NaN.
declare pub fn print(docs : Array[Yaml]) -> String
