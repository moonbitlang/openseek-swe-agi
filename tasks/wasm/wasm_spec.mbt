///|
/// A decoded WebAssembly module: the abstract syntax (§2) of the
/// WebAssembly Core Specification, Release 3.0, vendored as
/// `specs/WebAssembly-3.0.pdf` (plain-text rendering
/// `specs/WebAssembly-3.0.txt`; summary in `specs/wasm.md`). Section
/// numbers below refer to that release.
///
/// The concrete representation is chosen by the implementation. Tests
/// obtain a `Module` from `decode_module` and observe it only through
/// `Module::print` and `validate_module`.
declare pub type Module

///|
/// Decode a WebAssembly binary (`.wasm`) into a `Module`.
///
/// Parameters:
///
/// - `data`: the complete binary, `\0asm` magic first.
///
/// Decoding implements the *binary format* chapter (§5): a byte sequence
/// is a well-formed encoding of a module if and only if it is generated
/// by the binary grammar (§5.1), and every other input is *malformed* and
/// makes `decode_module` raise. In particular a decoder must check:
///
/// - the preamble (§5.5.17): the 4-byte magic `\0asm` and the 4-byte
///   version `1`;
/// - sections (§5.5.2, §5.5.17): the known ids 0..13 only; each
///   non-custom section at most once, in the prescribed order (type,
///   import, function, table, memory, tag, global, export, start,
///   element, data count, code, data); a section size that equals the
///   length of its contents and does not run past the end of the input;
///   custom sections (id 0, §5.5.3) anywhere, skipped, but with a valid
///   UTF-8 name;
/// - integers (§5.2.2): LEB128 of at most ceil(N/7) bytes whose unused
///   bits in the last byte are zero (unsigned) or sign-extended
///   (signed), for `u32`, `u64`, `s32`, `s33` and `s64`; a list length
///   larger than the remaining input is truncated input;
/// - names (§5.2.4): length-prefixed, strictly valid UTF-8 (no overlong
///   forms, surrogates or code points above U+10FFFF);
/// - types (§5.3): recursive groups (`0x4E`), sub types (`0x50`,
///   `0x4F`), func/struct/array composite types, packed `i8`/`i16` field
///   types, mutability bytes 0 or 1, the twelve abstract heap types and
///   `(ref null? x)` reference types of Release 3.0 and nothing else
///   (no `cont`/`nocont`, no `shared` types);
/// - limits (§5.3.9): flags 0x00/0x01 (i32 address type) and 0x04/0x05
///   (i64), bounds as `u64`; the threads proposal's shared flags
///   0x02/0x03 are not part of Release 3.0 (its feature list is §7.8.2)
///   and are malformed;
/// - tables written with the `0x40 0x00` prefix carry an initializer
///   expression; the byte after `0x40` must be zero;
/// - element segments in all eight flag forms (0..7), with the element
///   kind byte fixed to 0x00; data segments with flags 0, 1 or 2;
/// - function bodies (§5.5.13, instructions §5.4, opcode index §7.10):
///   local declarations whose total count fits in a `u32`, then the
///   complete Release 3.0 instruction set — every
///   single-byte opcode and every `0xFB` (GC), `0xFC` (saturating
///   truncation, bulk memory, table) and `0xFD` (vector, relaxed vector)
///   sub-opcode with its immediates — ending with `end` exactly at the
///   declared body size. An unknown opcode or sub-opcode, a missing
///   `end`, bytes after the final `end`, an `else` outside an `if`,
///   memarg flags of 0x80 or more, or cast flags above 3 are malformed;
/// - module-level consistency (§5.5.15, §5.5.17): the function and code
///   sections have the same length; the data count, when present, equals
///   the number of data segments, and it must be present when a data
///   index occurs in the code section (`memory.init`, `data.drop`,
///   `array.new_data`, `array.init_data`).
///
/// Tests only assert that malformed inputs raise; the error type and
/// message are free.
///
/// Examples (bytes written as hex):
///
///     input                              result
///
///     00 61 73 6d 01 00 00 00            the empty module
///     00 61 73 6d 01 00 00 00 01 01 00   a module with an empty type section
///     (empty input)                      raises: no preamble
///     00 61 73 6d 02 00 00 00            raises: unknown version
///     00 61 73 6d 01 00 00 00 01 05 00   raises: section runs past the end
///     00 61 73 6d 01 00 00 00 05 01 00 04 01 00
///                                        raises: memory section before table
///                                        section is fine, but the table
///                                        section after it is out of order
declare pub fn decode_module(data : Bytes) -> Module raise

///|
/// Render the module in the WebAssembly text format (§6) in the flat,
/// one-definition-per-line style spelled out in `specs/wasm.md`
/// § Printing (abbreviations of §6.4.4, §6.4.7, §6.4.15 and §6.5;
/// number/string syntax of §6.3). The output is compared
/// byte-for-byte, so the layout is part of the contract:
///
/// - a module without definitions prints as `(module)\n`; otherwise
///   `(module\n`, one definition per line indented two spaces, `)\n`;
/// - definitions appear in this order: types, imports, tables,
///   memories, tags, globals, exports, start, element segments,
///   functions, data segments; custom sections are not printed;
/// - every definition carries its index as a `(;N;)` comment right after
///   its keyword; imports are numbered before definitions of the same
///   kind; element and data segments count from 0 in their own spaces;
/// - types: a group encoded with `0x4E` prints as `(rec` on its own
///   line, its types indented two more spaces, and `)` (`(rec)` when
///   empty); the shorthand encoding prints a bare `(type (;N;) ...)`;
///   a sub type prints `(sub final? super* comptype)`, or only its
///   composite type when it is final without supertypes; composite types
///   print `(func (param t*) (result t*))` (either group omitted when
///   empty), `(struct (field ft)*)` and `(array ft)`, with `(mut st)`
///   for mutable fields and `i8`/`i16` for packed storage;
/// - value types print by keyword (`i32` `i64` `f32` `f64` `v128`);
///   nullable abstract reference types use the shorthands `funcref
///   externref anyref eqref i31ref structref arrayref nullref nullfuncref
///   nullexternref exnref nullexnref`, every other reference type prints
///   `(ref null? ht)`;
/// - `(import "module" "name" desc)` with desc `(func (;N;) (type T))`
///   (no parameter/result expansion for imported functions),
///   `(table (;N;) tabletype)`, `(memory (;N;) limits)`,
///   `(global (;N;) globaltype)` or `(tag (;N;) typeuse)`, where a
///   typeuse is `(type T)` followed by the type's `(param ...)` and
///   `(result ...)` groups when `T` is a function type;
/// - limits print `min` or `min max`, prefixed with `i64 ` for a 64-bit
///   address type; a table type prints its limits then its element type;
///   a mutable global type prints `(mut t)`;
/// - `(table (;N;) tabletype init?)` (the initializer, when encoded,
///   inline after the type), `(memory (;N;) limits)`, `(tag (;N;)
///   typeuse)`, `(global (;N;) globaltype init)`; constant expressions
///   print their instructions inline separated by single spaces;
/// - `(export "name" (func N))` (likewise `table`, `memory`, `global`,
///   `tag`), `(start N)`;
/// - element segments: `(elem (;N;) declare? (table T)? (offset)? func
///   idx*)` for the element-kind encodings, where `(table T)` appears
///   only when the encoding carries an explicit table index and an
///   offset is a parenthesized constant expression, and `(elem (;N;)
///   declare? (table T)? (offset)? reftype (expr)*)` for the expression
///   encodings;
/// - data segments: `(data (;N;) (memory M)? (offset)? "bytes")` with
///   `(memory M)` only for a nonzero memory index;
/// - functions: `(func (;N;) typeuse)` on one line when the body has no
///   locals and no instructions; otherwise the header line, a single
///   `(local t*)` line listing every local when there are any, one
///   instruction per line indented four spaces plus two per enclosing
///   `block`/`loop`/`if`/`try_table`, `else` and `end` at the depth of
///   their block, and a closing `  )`;
/// - instructions print in the plain (unfolded) syntax as mnemonic
///   followed by immediates: block types as ` (result t)` or a typeuse;
///   `try_table` catch clauses as `(catch tag label)`, `(catch_ref tag
///   label)`, `(catch_all label)`, `(catch_all_ref label)`; `br_table`
///   labels then the default; `call_indirect` and `return_call_indirect`
///   print the table index only when nonzero, then `(type T)`;
///   `select (result t*)` for the typed form; loads and stores print
///   ` M` for a nonzero memory index, ` offset=o` for a nonzero offset
///   and ` align=2^a` when the alignment differs from the natural one,
///   lane immediates last; `memory.size`, `memory.grow`, `memory.fill`
///   omit a zero memory index, `memory.copy` and `table.copy` omit both
///   indices when both are zero, `memory.init` and `table.init` print the
///   memory/table index only when nonzero before the segment index;
///   `v128.const i32x4 0x… 0x… 0x… 0x…` (four little-endian lanes as
///   eight hex digits each), `i8x16.shuffle` its sixteen lanes;
///   `ref.null ht`, `ref.test`/`ref.cast` a reference type,
///   `br_on_cast`/`br_on_cast_fail` label then two reference types;
///   there are no other comments;
/// - `i32.const`/`i64.const` print signed decimal; indices print
///   unsigned decimal;
/// - `f32.const`/`f64.const` print `0x0p+0` for zero, `inf`, `nan`,
///   `nan:0x<payload>` (lower-case hex, no leading zeros) or
///   `0x1.<hex>p<±exp>` (fraction digits with trailing zeros trimmed and
///   the dot dropped when there are none, subnormals normalised so the
///   leading digit is 1, exponent always signed), all with a leading `-`
///   when the sign bit is set, followed by ` (;=D;)` where D is `NaN`,
///   `inf`, `-inf`, `-0`, `0` or the shortest decimal digit string that
///   rounds back to the same value, written positionally without an
///   exponent;
/// - names print as string literals: printable ASCII other than `"` and
///   `\` verbatim, every other character as `\u{hex}` (lower case, no
///   leading zeros); data strings print bytes 0x20..0x7E other than `"`
///   and `\` verbatim and every other byte as `\hh`;
/// - the output ends with a newline.
///
/// Examples:
///
///     module                         print()
///
///     the empty module               "(module)\n"
///     one empty type section         "(module)\n"
///     one function type () -> ()     "(module\n  (type (;0;) (func))\n)\n"
///     a memory with limits 1..2      "(module\n  (memory (;0;) 1 2)\n)\n"
declare pub fn Module::print(self : Module) -> String

///|
/// Validate a decoded module against the module-level rules of the
/// Validation chapter (§3; validity is defined in §3.1, the module rules
/// in §3.5; summary in `specs/wasm.md` § Validation). Type-checking the
/// instruction sequences inside function bodies (§3.4.12) is **out of
/// scope** for this task: `validate_module` must not reject a module on
/// account of its function bodies (only their local declarations,
/// §3.5.7, are checked). A solver that does type-check bodies is not
/// penalised, because every module the tests call valid has well-typed
/// bodies.
///
/// Returns silently for a valid module; raises for an *invalid* one.
/// The rules:
///
/// - types (§3.2.11, §3.5.1): every type index inside a composite type
///   refers to a type defined no later than the end of the enclosing
///   recursive group; a sub type has at most one supertype, which is
///   defined before it, is not final, and whose composite type the sub
///   type matches (§3.3.8–§3.3.10: function types contravariant in
///   parameters and covariant in results, struct types by field prefix,
///   array types by field; mutable fields are invariant); equivalence of
///   defined types is iso-recursive (§3.1.2–§3.1.3: structurally equal
///   recursive groups define equal types);
/// - limits (§3.2.12, §3.2.15, §3.2.16): a memory's bounds are at most
///   2^16 pages (i32 address type) or 2^48 (i64), a table's at most
///   2^32-1 or 2^64-1, and a minimum never exceeds a maximum;
/// - every function, imported or defined, refers to a function type; a
///   tag refers to a function type without results;
/// - the types of globals, locals, tables and element segments are
///   valid (type indices in range);
/// - constant expressions (§3.4.13) — global and table initializers,
///   element and data offsets, element items — contain only constant
///   instructions
///   (`t.const`, `v128.const`, `ref.null`, `ref.func`, `ref.i31`,
///   `struct.new`, `struct.new_default`, `array.new`,
///   `array.new_default`, `array.new_fixed`, `any.convert_extern`,
///   `extern.convert_any`, `global.get` of an immutable global and the
///   `i32`/`i64` `add`, `sub`, `mul` operators), are well-typed under
///   the subtyping relation, and leave exactly one value of the required
///   type; a global initializer may read imported and previously defined
///   globals only, a table initializer imported globals only; `ref.func`
///   names an existing function;
/// - a table encoded without an initializer has a nullable element type;
/// - an active data segment names an existing memory and its offset has
///   that memory's address type; an active element segment names an
///   existing table whose element type the segment's type matches and
///   its offset has that table's address type; element-kind items name
///   existing functions;
/// - the start function exists and has type `[] -> []` (§3.5.10);
/// - exports name existing functions, tables, memories, globals or
///   tags, and their names are pairwise distinct (§3.5.12, §3.5.13).
///
/// Well-formedness is not re-checked here: a `Module` always comes from
/// `decode_module`.
declare pub fn validate_module(mod_ : Module) -> Unit raise
