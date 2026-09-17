///|
/// One markup event of an XML 1.0 document, in document order.
///
/// - `Decl` is the XML declaration exactly as written: `encoding` and
///   `standalone` are `None` when the declaration omits them.
/// - `DocType` carries the document type name. The declarations of the
///   internal subset are not events (they affect parsing: entity
///   replacement, attribute defaults and normalization); comments and
///   processing instructions inside the internal subset are reported as
///   ordinary `Comment` / `PI` events in document order.
/// - `Start`/`End` delimit every element, including elements without
///   content: `<a/>` and `<a></a>` both parse to `Start` followed by `End`.
///   Attribute order is not significant in XML, so attributes are a map
///   (equality ignores order). Values are fully normalized (references
///   expanded, white space per the declared attribute type) and include
///   attributes defaulted by the internal subset.
/// - `Text` is character data after entity and character-reference
///   expansion and CDATA-section unwrapping. Adjacent character data
///   merges into one event, empty character data produces no event, and
///   there is no `Text` outside the root element.
/// - `Comment` carries the text between `<!--` and `-->`; `PI` carries the
///   target and the data that follows the white space after the target
///   (`""` when there is none).
/// - `EntityRef` is a reference in content that the parser recognized but
///   did not expand: a reference to an external parsed entity, or to an
///   undeclared entity in a document where that is not a well-formedness
///   error (see `parse`).
pub(all) enum Event {
  Decl(version~ : String, encoding~ : String?, standalone~ : Bool?)
  DocType(String)
  Start(name~ : String, attributes~ : Map[String, String])
  End(String)
  Text(String)
  Comment(String)
  PI(target~ : String, data~ : String)
  EntityRef(String)
} derive(Eq, Debug)

///|
/// Parse an XML 1.0 (Fifth Edition) document into its events.
///
/// Parameters:
///
/// - `input`: the document entity as a decoded character sequence (the
///   view's window; a leading U+FEFF byte order mark is skipped).
///
/// Returns the document's markup events in document order.
///
/// The parser is a non-validating processor that reads only the document
/// entity — never an external subset, an external entity, or a parameter
/// entity — and checks well-formedness only: the `document` grammar, the
/// `Char` and `Name` productions, proper nesting, unique attributes, legal
/// references, and the other well-formedness constraints of the spec.
/// Validity (content models, ID rules, ...) is not enforced. There is no
/// namespace processing: `a:b` is a plain name and `xmlns` attributes are
/// ordinary attributes. Because the input is already decoded, the encoding
/// declaration is checked for syntax and reported, nothing more.
///
/// As required of a non-validating processor (section 5.1), the internal
/// DTD subset is processed: internal general entities are expanded,
/// attribute values are normalized according to their declared types, and
/// declared default values are supplied — using every declaration up to
/// the first parameter-entity reference between declarations; later
/// declarations are still checked for well-formedness but only used when
/// the document is `standalone="yes"`. Line ends are normalized on input
/// (section 2.11); characters produced by character references never are.
///
/// Entity references resolve as follows. The predefined entities and the
/// internal entities declared as above are expanded; in content the
/// replacement text is parsed as content and must be well-formed by
/// itself. In content, a reference to an external parsed entity, or to an
/// undeclared entity in a document that has an external subset or a
/// parameter-entity reference and is not `standalone="yes"`, produces an
/// `EntityRef` event (sections 4.1 and 4.4.3). Every other unresolvable
/// reference is an error: an undeclared entity elsewhere (WFC: Entity
/// Declared), an unparsed entity, and in attribute values also external
/// and undeclared entities (sections 3.3.3 and 4.4.4).
///
/// Raises on any input that is not a well-formed XML 1.0 document.
///
/// Examples:
///
///     XML                            events
///
///     <a>hi</a>                      [Start(name="a", attributes=Map([])),
///                                     Text("hi"),
///                                     End("a")]
///
/// <!-- -->
///
///     <a b="1"/>                     [Start(name="a", attributes={ "b": "1" }),
///                                     End("a")]
///
/// <!-- -->
///
///     <?xml version="1.0"?>          [Decl(version="1.0", encoding=None, standalone=None),
///     <!DOCTYPE a [                   DocType("a"),
///     <!ENTITY h "hi">                Start(name="a", attributes=Map([])),
///     ]>                              Text("hi!"),
///     <a>&h;!</a>                     End("a")]
///
declare pub fn parse(input : StringView) -> Array[Event] raise

///|
/// Print events back to XML text.
///
/// The exact text is unspecified, but it must parse back to an equal
/// event sequence: `parse(print(events)) == events` for every well-formed
/// sequence. Well-formed means:
///
/// - the sequence has the document shape: an optional leading `Decl`, at
///   most one `DocType` before the root, exactly one element tree
///   (balanced `Start`/`End` with matching names), only `Comment` and
///   `PI` events outside the root element, and no `EntityRef` anywhere
///   (the parser only produces it for documents whose declarations the
///   event model does not carry);
/// - `Text` events are non-empty and no two are adjacent;
/// - every string contains only characters matched by the `Char`
///   production; names and PI targets are valid XML names, and no PI
///   target is `xml` in any letter case;
/// - a `Comment` value contains no `--`, does not end with `-`, and
///   contains no carriage return; a `PI` data value contains no `?>`, no
///   carriage return, and does not start with white space;
/// - a `Decl` has a version matching `1.[0-9]+` and, if present, an
///   encoding name matching `[A-Za-z][A-Za-z0-9._-]*`.
///
/// Character data and attribute values may contain markup characters,
/// carriage returns, or (in attribute values) tabs and line feeds:
/// `print` escapes them (`&lt;`, `&amp;`, `&#13;`, ...) so they survive
/// re-parsing exactly.
declare pub fn print(events : Array[Event]) -> String
