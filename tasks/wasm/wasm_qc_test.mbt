///|
/// Property tests (black-box; do not modify this file).
///
/// `QcModule` describes a small module in a dialect whose binary encoding
/// and text rendering are both fixed by `specs/wasm.md`: function types
/// over the number types, function and global imports, tables, one
/// memory, globals with constant initializers, exports with unique
/// names, a start function, element and data segments, custom sections,
/// and function bodies built from `nop`, `unreachable`, `drop`,
/// `return`, `i32.const`, `local.get`, `call`, `br`, and nested
/// `block`/`loop`/`if`. Every generated module is well-formed and valid
/// by construction, so `decode_module` must succeed, `print` must
/// produce exactly `QcModule::expected_print`, and `validate_module`
/// must not raise. Shrinking only ever removes material, so every
/// shrink candidate stays inside the dialect.
///
/// `QcFuzz` wraps adversarial bytes (usually a valid header followed by
/// section-shaped garbage). The only obligation is "succeed or raise,
/// never panic" for decoding, and for printing/validating whatever
/// happens to decode.

///|
enum QcNum {
  QI32
  QI64
  QF32
  QF64
} derive(Debug, Eq)

///|
struct QcFuncType {
  params : Array[QcNum]
  results : Array[QcNum]
} derive(Debug)

///|
enum QcImport {
  QImFunc(Int) // type index
  QImGlobal(QcNum, Bool) // type, mutable
} derive(Debug)

///|
enum QcStmt {
  QNop
  QUnreachable
  QConstDrop(Int)
  QLocalDrop(Int)
  QCall(Int)
  QBlock(Array[QcStmt])
  QLoop(Array[QcStmt])
  QIf(Array[QcStmt], Array[QcStmt]?)
  QBr(Int)
  QReturn
} derive(Debug)

///|
struct QcFunc {
  type_ : Int
  locals : Array[QcNum]
  body : Array[QcStmt]
} derive(Debug)

///|
struct QcMemory {
  min : Int
  max : Int?
  is64 : Bool
} derive(Debug)

///|
struct QcTable {
  min : Int
  max : Int?
} derive(Debug)

///|
/// Initializer: a constant of the global's type, chosen from a fixed set
/// with a known rendering.
struct QcGlobal {
  type_ : QcNum
  mutable_ : Bool
  init : Int // index into the constant table for the type
} derive(Debug)

///|
enum QcKind {
  QKFunc
  QKTable
  QKMemory
  QKGlobal
} derive(Debug, Eq)

///|
struct QcExport {
  name : Int // index into qc_names
  kind : QcKind
  index : Int
} derive(Debug)

///|
enum QcElem {
  QEPassiveFuncs(Array[Int])
  QEActiveFuncs(Int, Int, Array[Int]) // table, offset, funcs
  QEDeclarative(Array[Int])
  QEPassiveExprs(Array[Int?]) // Some(f) = ref.func f, None = ref.null func
} derive(Debug)

///|
enum QcData {
  QDPassive(Array[Int])
  QDActive(Int, Array[Int]) // offset, bytes
} derive(Debug)

///|
struct QcModule {
  types : Array[QcFuncType]
  imports : Array[QcImport]
  funcs : Array[QcFunc]
  tables : Array[QcTable]
  memory : QcMemory?
  globals : Array[QcGlobal]
  exports : Array[QcExport]
  start : Int?
  elems : Array[QcElem]
  datas : Array[QcData]
  customs : Array[Int] // custom sections (payload seeds) inserted before the type section
} derive(Debug)

///|
/// Names with their string-literal rendering (module/field/export names).
let qc_names : Array[(String, String)] = [
  ("a", "\"a\""),
  ("", "\"\""),
  ("b\"c", "\"b\\u{22}c\""),
  ("d\\e", "\"d\\u{5c}e\""),
  ("f g", "\"f g\""),
  ("h\ti", "\"h\\u{9}i\""),
  ("j\u{7f}", "\"j\\u{7f}\""),
  ("k\u{e9}", "\"k\\u{e9}\""),
  ("\u{1f600}", "\"\\u{1f600}\""),
  ("_z9", "\"_z9\""),
  ("l\u{0}", "\"l\\u{0}\""),
  ("m~", "\"m~\""),
]

///|
/// Constants per number type: encoding bytes and rendering.
let qc_i32_consts : Array[(Int, String)] = [
  (0, "i32.const 0"),
  (1, "i32.const 1"),
  (-1, "i32.const -1"),
  (127, "i32.const 127"),
  (-128, "i32.const -128"),
  (2147483647, "i32.const 2147483647"),
  (-2147483648, "i32.const -2147483648"),
  (65535, "i32.const 65535"),
]

///|
let qc_i64_consts : Array[(Int64, String)] = [
  (0L, "i64.const 0"),
  (-1L, "i64.const -1"),
  (9223372036854775807L, "i64.const 9223372036854775807"),
  (-9223372036854775808L, "i64.const -9223372036854775808"),
  (4294967296L, "i64.const 4294967296"),
  (-64L, "i64.const -64"),
]

///|
let qc_f32_consts : Array[(UInt, String)] = [
  (0x00000000U, "f32.const 0x0p+0 (;=0;)"),
  (0x3f800000U, "f32.const 0x1p+0 (;=1;)"),
  (0x40400000U, "f32.const 0x1.8p+1 (;=3;)"),
  (0xbf800000U, "f32.const -0x1p+0 (;=-1;)"),
  (0x7f800000U, "f32.const inf (;=inf;)"),
  (0x7fc00000U, "f32.const nan (;=NaN;)"),
]

///|
let qc_f64_consts : Array[(UInt64, String)] = [
  (0x0000000000000000UL, "f64.const 0x0p+0 (;=0;)"),
  (0x3ff0000000000000UL, "f64.const 0x1p+0 (;=1;)"),
  (0x3fe0000000000000UL, "f64.const 0x1p-1 (;=0.5;)"),
  (0x4004000000000000UL, "f64.const 0x1.4p+1 (;=2.5;)"),
  (0xbff0000000000000UL, "f64.const -0x1p+0 (;=-1;)"),
  (0xfff0000000000000UL, "f64.const -inf (;=-inf;)"),
]

///|
fn qc_pick(rand : @quickcheck.RandomState, n : Int) -> Int {
  rand.next_uint(limit=n.reinterpret_as_uint()).reinterpret_as_int()
}

///|
fn qc_num_text(t : QcNum) -> String {
  match t {
    QI32 => "i32"
    QI64 => "i64"
    QF32 => "f32"
    QF64 => "f64"
  }
}

///|
fn qc_num_byte(t : QcNum) -> Byte {
  match t {
    QI32 => 0x7F
    QI64 => 0x7E
    QF32 => 0x7D
    QF64 => 0x7C
  }
}

///|
fn qc_leb(out : Array[Byte], value : Int) -> Unit {
  let mut v = value.reinterpret_as_uint()
  for ;; {
    let b = (v & 0x7FU).reinterpret_as_int()
    v = v >> 7
    if v == 0U {
      out.push(b.to_byte())
      break
    }
    out.push((b | 0x80).to_byte())
  }
}

///|
fn qc_sleb32(out : Array[Byte], value : Int) -> Unit {
  let mut v = value
  for ;; {
    let b = v.land(0x7F)
    v = v >> 7
    if (v == 0 && b.land(0x40) == 0) || (v == -1 && b.land(0x40) != 0) {
      out.push(b.to_byte())
      break
    }
    out.push((b | 0x80).to_byte())
  }
}

///|
fn qc_sleb64(out : Array[Byte], value : Int64) -> Unit {
  let mut v = value
  for ;; {
    let b = (v & 0x7FL).to_int()
    v = v >> 7
    if (v == 0L && b.land(0x40) == 0) || (v == -1L && b.land(0x40) != 0) {
      out.push(b.to_byte())
      break
    }
    out.push((b | 0x80).to_byte())
  }
}

///|
fn qc_name_bytes(out : Array[Byte], s : String) -> Unit {
  let enc : Array[Byte] = []
  for ch in s {
    let c = ch.to_int()
    if c < 0x80 {
      enc.push(c.to_byte())
    } else if c < 0x800 {
      enc.push((0xC0 | (c >> 6)).to_byte())
      enc.push((0x80 | c.land(0x3F)).to_byte())
    } else if c < 0x10000 {
      enc.push((0xE0 | (c >> 12)).to_byte())
      enc.push((0x80 | (c >> 6).land(0x3F)).to_byte())
      enc.push((0x80 | c.land(0x3F)).to_byte())
    } else {
      enc.push((0xF0 | (c >> 18)).to_byte())
      enc.push((0x80 | (c >> 12).land(0x3F)).to_byte())
      enc.push((0x80 | (c >> 6).land(0x3F)).to_byte())
      enc.push((0x80 | c.land(0x3F)).to_byte())
    }
  }
  qc_leb(out, enc.length())
  for b in enc {
    out.push(b)
  }
}

///|
fn qc_section(out : Array[Byte], id : Int, payload : Array[Byte]) -> Unit {
  out.push(id.to_byte())
  qc_leb(out, payload.length())
  for b in payload {
    out.push(b)
  }
}

///|
fn qc_const_bytes(out : Array[Byte], t : QcNum, i : Int) -> Unit {
  match t {
    QI32 => {
      out.push(0x41)
      qc_sleb32(out, qc_i32_consts[i].0)
    }
    QI64 => {
      out.push(0x42)
      qc_sleb64(out, qc_i64_consts[i].0)
    }
    QF32 => {
      out.push(0x43)
      let bits = qc_f32_consts[i].0
      for k in 0..<4 {
        out.push(((bits >> (8 * k)) & 0xFFU).reinterpret_as_int().to_byte())
      }
    }
    QF64 => {
      out.push(0x44)
      let bits = qc_f64_consts[i].0
      for k in 0..<8 {
        out.push(((bits >> (8 * k)) & 0xFFUL).to_int().to_byte())
      }
    }
  }
}

///|
fn qc_const_text(t : QcNum, i : Int) -> String {
  match t {
    QI32 => qc_i32_consts[i].1
    QI64 => qc_i64_consts[i].1
    QF32 => qc_f32_consts[i].1
    QF64 => qc_f64_consts[i].1
  }
}

///|
fn qc_const_count(t : QcNum) -> Int {
  match t {
    QI32 => qc_i32_consts.length()
    QI64 => qc_i64_consts.length()
    QF32 => qc_f32_consts.length()
    QF64 => qc_f64_consts.length()
  }
}

///|
fn qc_stmts_bytes(out : Array[Byte], stmts : Array[QcStmt]) -> Unit {
  for s in stmts {
    match s {
      QNop => out.push(0x01)
      QUnreachable => out.push(0x00)
      QConstDrop(c) => {
        out.push(0x41)
        qc_sleb32(out, c)
        out.push(0x1A)
      }
      QLocalDrop(k) => {
        out.push(0x20)
        qc_leb(out, k)
        out.push(0x1A)
      }
      QCall(f) => {
        out.push(0x10)
        qc_leb(out, f)
      }
      QBlock(body) => {
        out.push(0x02)
        out.push(0x40)
        qc_stmts_bytes(out, body)
        out.push(0x0B)
      }
      QLoop(body) => {
        out.push(0x03)
        out.push(0x40)
        qc_stmts_bytes(out, body)
        out.push(0x0B)
      }
      QIf(then_, else_) => {
        out.push(0x41)
        out.push(0x00)
        out.push(0x04)
        out.push(0x40)
        qc_stmts_bytes(out, then_)
        if else_ is Some(e) {
          out.push(0x05)
          qc_stmts_bytes(out, e)
        }
        out.push(0x0B)
      }
      QBr(l) => {
        out.push(0x0C)
        qc_leb(out, l)
      }
      QReturn => out.push(0x0F)
    }
  }
}

///|
fn qc_stmts_text(
  lines : Array[String],
  stmts : Array[QcStmt],
  depth : Int,
) -> Unit {
  let indent = "  ".repeat(depth + 2)
  for s in stmts {
    match s {
      QNop => lines.push(indent + "nop")
      QUnreachable => lines.push(indent + "unreachable")
      QConstDrop(c) => {
        lines.push(indent + "i32.const " + c.to_string())
        lines.push(indent + "drop")
      }
      QLocalDrop(k) => {
        lines.push(indent + "local.get " + k.to_string())
        lines.push(indent + "drop")
      }
      QCall(f) => lines.push(indent + "call " + f.to_string())
      QBlock(body) => {
        lines.push(indent + "block")
        qc_stmts_text(lines, body, depth + 1)
        lines.push(indent + "end")
      }
      QLoop(body) => {
        lines.push(indent + "loop")
        qc_stmts_text(lines, body, depth + 1)
        lines.push(indent + "end")
      }
      QIf(then_, else_) => {
        lines.push(indent + "i32.const 0")
        lines.push(indent + "if")
        qc_stmts_text(lines, then_, depth + 1)
        if else_ is Some(e) {
          lines.push(indent + "else")
          qc_stmts_text(lines, e, depth + 1)
        }
        lines.push(indent + "end")
      }
      QBr(l) => lines.push(indent + "br " + l.to_string())
      QReturn => lines.push(indent + "return")
    }
  }
}

///|
fn qc_params_results_text(ft : QcFuncType) -> String {
  let mut s = ""
  if ft.params.length() > 0 {
    s = s + " (param"
    for p in ft.params {
      s = s + " " + qc_num_text(p)
    }
    s = s + ")"
  }
  if ft.results.length() > 0 {
    s = s + " (result"
    for r in ft.results {
      s = s + " " + qc_num_text(r)
    }
    s = s + ")"
  }
  s
}

///|
fn qc_data_text(bytes : Array[Int]) -> String {
  let sb = StringBuilder()
  sb.write_char('"')
  for v in bytes {
    if v >= 0x20 && v < 0x7F && v != 0x22 && v != 0x5C {
      sb.write_char(v.unsafe_to_char())
    } else {
      sb.write_string("\\")
      sb.write_char("0123456789abcdef"[v >> 4].to_int().unsafe_to_char())
      sb.write_char("0123456789abcdef"[v.land(0xF)].to_int().unsafe_to_char())
    }
  }
  sb.write_char('"')
  sb.to_string()
}

///|
/// The binary encoding of the module.
fn QcModule::encode(self : QcModule) -> Bytes {
  let out : Array[Byte] = [0x00, 0x61, 0x73, 0x6D, 0x01, 0x00, 0x00, 0x00]
  for seed in self.customs {
    let payload : Array[Byte] = []
    qc_name_bytes(payload, qc_names[seed % qc_names.length()].0)
    for k in 0..<(seed % 5) {
      payload.push(((seed * 31 + k * 7) % 256).to_byte())
    }
    qc_section(out, 0, payload)
  }
  // types
  let tsec : Array[Byte] = []
  qc_leb(tsec, self.types.length())
  for ft in self.types {
    tsec.push(0x60)
    qc_leb(tsec, ft.params.length())
    for p in ft.params {
      tsec.push(qc_num_byte(p))
    }
    qc_leb(tsec, ft.results.length())
    for r in ft.results {
      tsec.push(qc_num_byte(r))
    }
  }
  qc_section(out, 1, tsec)
  // imports
  if self.imports.length() > 0 {
    let isec : Array[Byte] = []
    qc_leb(isec, self.imports.length())
    for i, imp in self.imports {
      qc_name_bytes(isec, qc_names[i % qc_names.length()].0)
      qc_name_bytes(isec, qc_names[(i * 7 + 3) % qc_names.length()].0)
      match imp {
        QImFunc(t) => {
          isec.push(0x00)
          qc_leb(isec, t)
        }
        QImGlobal(t, m) => {
          isec.push(0x03)
          isec.push(qc_num_byte(t))
          isec.push(if m { 0x01 } else { 0x00 })
        }
      }
    }
    qc_section(out, 2, isec)
  }
  // functions
  if self.funcs.length() > 0 {
    let fsec : Array[Byte] = []
    qc_leb(fsec, self.funcs.length())
    for f in self.funcs {
      qc_leb(fsec, f.type_)
    }
    qc_section(out, 3, fsec)
  }
  // tables
  if self.tables.length() > 0 {
    let tbl : Array[Byte] = []
    qc_leb(tbl, self.tables.length())
    for t in self.tables {
      tbl.push(0x70)
      match t.max {
        Some(mx) => {
          tbl.push(0x01)
          qc_leb(tbl, t.min)
          qc_leb(tbl, mx)
        }
        None => {
          tbl.push(0x00)
          qc_leb(tbl, t.min)
        }
      }
    }
    qc_section(out, 4, tbl)
  }
  // memory
  if self.memory is Some(m) {
    let msec : Array[Byte] = [0x01]
    let flag = (if m.is64 { 0x04 } else { 0x00 }) |
      (if m.max is Some(_) { 0x01 } else { 0x00 })
    msec.push(flag.to_byte())
    qc_leb(msec, m.min)
    if m.max is Some(mx) {
      qc_leb(msec, mx)
    }
    qc_section(out, 5, msec)
  }
  // globals
  if self.globals.length() > 0 {
    let gsec : Array[Byte] = []
    qc_leb(gsec, self.globals.length())
    for g in self.globals {
      gsec.push(qc_num_byte(g.type_))
      gsec.push(if g.mutable_ { 0x01 } else { 0x00 })
      qc_const_bytes(gsec, g.type_, g.init)
      gsec.push(0x0B)
    }
    qc_section(out, 6, gsec)
  }
  // exports
  if self.exports.length() > 0 {
    let esec : Array[Byte] = []
    qc_leb(esec, self.exports.length())
    for e in self.exports {
      qc_name_bytes(esec, qc_export_name(e.name))
      esec.push(
        match e.kind {
          QKFunc => 0x00
          QKTable => 0x01
          QKMemory => 0x02
          QKGlobal => 0x03
        },
      )
      qc_leb(esec, e.index)
    }
    qc_section(out, 7, esec)
  }
  // start
  if self.start is Some(s) {
    let ssec : Array[Byte] = []
    qc_leb(ssec, s)
    qc_section(out, 8, ssec)
  }
  // element segments
  if self.elems.length() > 0 {
    let esec : Array[Byte] = []
    qc_leb(esec, self.elems.length())
    for e in self.elems {
      match e {
        QEPassiveFuncs(fs) => {
          esec.push(0x01)
          esec.push(0x00)
          qc_leb(esec, fs.length())
          for f in fs {
            qc_leb(esec, f)
          }
        }
        QEActiveFuncs(table, offset, fs) => {
          esec.push(0x02)
          qc_leb(esec, table)
          esec.push(0x41)
          qc_sleb32(esec, offset)
          esec.push(0x0B)
          esec.push(0x00)
          qc_leb(esec, fs.length())
          for f in fs {
            qc_leb(esec, f)
          }
        }
        QEDeclarative(fs) => {
          esec.push(0x03)
          esec.push(0x00)
          qc_leb(esec, fs.length())
          for f in fs {
            qc_leb(esec, f)
          }
        }
        QEPassiveExprs(items) => {
          esec.push(0x05)
          esec.push(0x70)
          qc_leb(esec, items.length())
          for it in items {
            match it {
              Some(f) => {
                esec.push(0xD2)
                qc_leb(esec, f)
              }
              None => {
                esec.push(0xD0)
                esec.push(0x70)
              }
            }
            esec.push(0x0B)
          }
        }
      }
    }
    qc_section(out, 9, esec)
  }
  // data count (always present when data segments exist)
  if self.datas.length() > 0 {
    let dc : Array[Byte] = []
    qc_leb(dc, self.datas.length())
    qc_section(out, 12, dc)
  }
  // code
  if self.funcs.length() > 0 {
    let csec : Array[Byte] = []
    qc_leb(csec, self.funcs.length())
    for f in self.funcs {
      let body : Array[Byte] = []
      qc_leb(body, f.locals.length())
      for l in f.locals {
        qc_leb(body, 1)
        body.push(qc_num_byte(l))
      }
      qc_stmts_bytes(body, f.body)
      if self.types[f.type_].results.length() > 0 {
        body.push(0x00) // unreachable makes the result stack polymorphic
      }
      body.push(0x0B)
      qc_leb(csec, body.length())
      for b in body {
        csec.push(b)
      }
    }
    qc_section(out, 10, csec)
  }
  // data segments
  if self.datas.length() > 0 {
    let dsec : Array[Byte] = []
    qc_leb(dsec, self.datas.length())
    for d in self.datas {
      match d {
        QDPassive(bytes) => {
          dsec.push(0x01)
          qc_leb(dsec, bytes.length())
          for b in bytes {
            dsec.push(b.to_byte())
          }
        }
        QDActive(offset, bytes) => {
          dsec.push(0x00)
          if self.memory is Some({ is64: true, .. }) {
            dsec.push(0x42)
            qc_sleb64(dsec, offset.to_int64())
          } else {
            dsec.push(0x41)
            qc_sleb32(dsec, offset)
          }
          dsec.push(0x0B)
          qc_leb(dsec, bytes.length())
          for b in bytes {
            dsec.push(b.to_byte())
          }
        }
      }
    }
    qc_section(out, 11, dsec)
  }
  Bytes::from_array(out[:])
}

///|
/// Export names are unique by construction: the name-table entry plus
/// a numeric suffix.
fn qc_export_name(i : Int) -> String {
  qc_names[i % qc_names.length()].0 + i.to_string()
}

///|
fn qc_export_name_text(i : Int) -> String {
  let (_, rendered) = qc_names[i % qc_names.length()]
  rendered[0:rendered.length() - 1].to_owned() + i.to_string() + "\""
}

///|
/// The text rendering `print` must produce for this module.
fn QcModule::expected_print(self : QcModule) -> String {
  let lines : Array[String] = []
  for i, ft in self.types {
    lines.push("  (type (;\{i};) (func" + qc_params_results_text(ft) + "))")
  }
  let mut fi = 0
  let mut gi = 0
  for i, imp in self.imports {
    let mn = qc_names[i % qc_names.length()].1
    let nn = qc_names[(i * 7 + 3) % qc_names.length()].1
    let desc = match imp {
      QImFunc(t) => {
        let s = "(func (;\{fi};) (type \{t}))"
        fi += 1
        s
      }
      QImGlobal(t, m) => {
        let ty = if m { "(mut " + qc_num_text(t) + ")" } else { qc_num_text(t) }
        let s = "(global (;\{gi};) " + ty + ")"
        gi += 1
        s
      }
    }
    lines.push("  (import " + mn + " " + nn + " " + desc + ")")
  }
  for i, t in self.tables {
    let mx = if t.max is Some(m) { " " + m.to_string() } else { "" }
    lines.push("  (table (;\{i};) " + t.min.to_string() + mx + " funcref)")
  }
  if self.memory is Some(m) {
    let pre = if m.is64 { "i64 " } else { "" }
    let mx = if m.max is Some(x) { " " + x.to_string() } else { "" }
    lines.push("  (memory (;0;) " + pre + m.min.to_string() + mx + ")")
  }
  for i, g in self.globals {
    let ty = if g.mutable_ {
      "(mut " + qc_num_text(g.type_) + ")"
    } else {
      qc_num_text(g.type_)
    }
    lines.push(
      "  (global (;\{gi + i};) " +
      ty +
      " " +
      qc_const_text(g.type_, g.init) +
      ")",
    )
  }
  for e in self.exports {
    let kind = match e.kind {
      QKFunc => "func"
      QKTable => "table"
      QKMemory => "memory"
      QKGlobal => "global"
    }
    lines.push(
      "  (export " + qc_export_name_text(e.name) + " (" + kind + " \{e.index}))",
    )
  }
  if self.start is Some(s) {
    lines.push("  (start \{s})")
  }
  for i, e in self.elems {
    let mut s = "  (elem (;\{i};) "
    match e {
      QEPassiveFuncs(fs) => {
        s = s + "func"
        for f in fs {
          s = s + " \{f}"
        }
      }
      QEActiveFuncs(table, offset, fs) => {
        s = s + "(table \{table}) (i32.const \{offset}) func"
        for f in fs {
          s = s + " \{f}"
        }
      }
      QEDeclarative(fs) => {
        s = s + "declare func"
        for f in fs {
          s = s + " \{f}"
        }
      }
      QEPassiveExprs(items) => {
        s = s + "funcref"
        for it in items {
          s = s +
            (match it {
              Some(f) => " (ref.func \{f})"
              None => " (ref.null func)"
            })
        }
      }
    }
    lines.push(s + ")")
  }
  for i, f in self.funcs {
    let ft = self.types[f.type_]
    let head = "  (func (;\{fi + i};) (type \{f.type_})" +
      qc_params_results_text(ft)
    if f.locals.length() == 0 &&
      f.body.length() == 0 &&
      ft.results.length() == 0 {
      lines.push(head + ")")
    } else {
      lines.push(head)
      if f.locals.length() > 0 {
        let mut ls = "    (local"
        for l in f.locals {
          ls = ls + " " + qc_num_text(l)
        }
        lines.push(ls + ")")
      }
      qc_stmts_text(lines, f.body, 0)
      if ft.results.length() > 0 {
        lines.push("    unreachable")
      }
      lines.push("  )")
    }
  }
  for i, d in self.datas {
    match d {
      QDPassive(bytes) =>
        lines.push("  (data (;\{i};) " + qc_data_text(bytes) + ")")
      QDActive(offset, bytes) => {
        let addr = if self.memory is Some({ is64: true, .. }) {
          "i64"
        } else {
          "i32"
        }
        lines.push(
          "  (data (;\{i};) (" +
          addr +
          ".const \{offset}) " +
          qc_data_text(bytes) +
          ")",
        )
      }
    }
  }
  if lines.length() == 0 {
    return "(module)\n"
  }
  let sb = StringBuilder()
  sb.write_string("(module\n")
  for l in lines {
    sb.write_string(l)
    sb.write_char('\n')
  }
  sb.write_string(")\n")
  sb.to_string()
}

///|
fn qc_gen_num(rand : @quickcheck.RandomState) -> QcNum {
  match qc_pick(rand, 4) {
    0 => QI32
    1 => QI64
    2 => QF32
    _ => QF64
  }
}

///|
fn qc_gen_stmts(
  rand : @quickcheck.RandomState,
  n_locals : Int,
  callable : Array[Int],
  can_return : Bool,
  depth : Int,
  budget : Int,
) -> Array[QcStmt] {
  let out : Array[QcStmt] = []
  let n = qc_pick(rand, budget + 1)
  for _i in 0..<n {
    let choice = qc_pick(rand, if depth < 3 { 10 } else { 7 })
    let stmt : QcStmt = match choice {
      0 => QNop
      1 => QUnreachable
      2 => QConstDrop(qc_i32_consts[qc_pick(rand, qc_i32_consts.length())].0)
      3 => if n_locals > 0 { QLocalDrop(qc_pick(rand, n_locals)) } else { QNop }
      4 =>
        if callable.length() > 0 {
          QCall(callable[qc_pick(rand, callable.length())])
        } else {
          QNop
        }
      5 => if depth > 0 { QBr(qc_pick(rand, depth)) } else { QNop }
      6 => if can_return { QReturn } else { QUnreachable }
      7 =>
        QBlock(
          qc_gen_stmts(
            rand,
            n_locals,
            callable,
            can_return,
            depth + 1,
            budget / 2,
          ),
        )
      8 =>
        QLoop(
          qc_gen_stmts(
            rand,
            n_locals,
            callable,
            can_return,
            depth + 1,
            budget / 2,
          ),
        )
      _ => {
        let then_ = qc_gen_stmts(
          rand,
          n_locals,
          callable,
          can_return,
          depth + 1,
          budget / 2,
        )
        if qc_pick(rand, 2) == 0 {
          QIf(then_, None)
        } else {
          QIf(
            then_,
            Some(
              qc_gen_stmts(
                rand,
                n_locals,
                callable,
                can_return,
                depth + 1,
                budget / 2,
              ),
            ),
          )
        }
      }
    }
    out.push(stmt)
  }
  out
}

///|
pub impl @quickcheck.Arbitrary for QcModule with fn arbitrary(size, rand) {
  let scale = if size < 1 { 1 } else if size > 12 { 12 } else { size }
  // types (always at least one; type 0 is always () -> () for start/calls)
  let types : Array[QcFuncType] = [{ params: [], results: [], }]
  for _i in 0..<qc_pick(rand, scale) {
    let params : Array[QcNum] = []
    for _p in 0..<qc_pick(rand, 4) {
      params.push(qc_gen_num(rand))
    }
    let results : Array[QcNum] = []
    for _r in 0..<qc_pick(rand, 3) {
      results.push(qc_gen_num(rand))
    }
    types.push({ params, results, })
  }
  // imports
  let imports : Array[QcImport] = []
  for _i in 0..<qc_pick(rand, 3) {
    if qc_pick(rand, 2) == 0 {
      imports.push(QImFunc(qc_pick(rand, types.length())))
    } else {
      imports.push(QImGlobal(qc_gen_num(rand), qc_pick(rand, 2) == 0))
    }
  }
  let n_imp_funcs = {
    let mut n = 0
    for imp in imports {
      if imp is QImFunc(_) {
        n += 1
      }
    }
    n
  }
  // functions
  let funcs : Array[QcFunc] = []
  let n_funcs = qc_pick(rand, scale)
  let all_func_types : Array[Int] = []
  for imp in imports {
    if imp is QImFunc(t) {
      all_func_types.push(t)
    }
  }
  for _i in 0..<n_funcs {
    let t = qc_pick(rand, types.length())
    all_func_types.push(t)
    let locals : Array[QcNum] = []
    for _l in 0..<qc_pick(rand, 3) {
      locals.push(qc_gen_num(rand))
    }
    funcs.push({ type_: t, locals, body: [], })
  }
  // bodies may call any function of type 0 (() -> ())
  let callable : Array[Int] = []
  for i, t in all_func_types {
    if t == 0 {
      callable.push(i)
    }
  }
  for f in funcs {
    let n_locals = types[f.type_].params.length() + f.locals.length()
    let body = qc_gen_stmts(
      rand,
      n_locals,
      callable,
      types[f.type_].results.length() == 0,
      0,
      scale,
    )
    for s in body {
      f.body.push(s)
    }
  }
  let total_funcs = n_imp_funcs + funcs.length()
  // tables
  let tables : Array[QcTable] = []
  for _i in 0..<qc_pick(rand, 3) {
    let min = qc_pick(rand, 5)
    let max = if qc_pick(rand, 2) == 0 {
      Some(min + qc_pick(rand, 5))
    } else {
      None
    }
    tables.push({ min, max, })
  }
  // memory
  let memory : QcMemory? = if qc_pick(rand, 2) == 0 {
    let min = qc_pick(rand, 4)
    let max = if qc_pick(rand, 2) == 0 {
      Some(min + qc_pick(rand, 4))
    } else {
      None
    }
    Some({ min, max, is64: qc_pick(rand, 3) == 0, })
  } else {
    None
  }
  // globals
  let globals : Array[QcGlobal] = []
  for _i in 0..<qc_pick(rand, 4) {
    let t = qc_gen_num(rand)
    globals.push({
      type_: t,
      mutable_: qc_pick(rand, 2) == 0,
      init: qc_pick(rand, qc_const_count(t)),
    })
  }
  let n_globals = imports.length() - n_imp_funcs + globals.length()
  // exports (unique names by construction)
  let exports : Array[QcExport] = []
  if qc_pick(rand, 2) == 0 {
    for i in 0..<qc_pick(rand, 6) {
      let kind = match qc_pick(rand, 4) {
        0 => QKFunc
        1 => QKTable
        2 => QKMemory
        _ => QKGlobal
      }
      let count = match kind {
        QKFunc => total_funcs
        QKTable => tables.length()
        QKMemory => if memory is Some(_) { 1 } else { 0 }
        QKGlobal => n_globals
      }
      if count > 0 {
        exports.push({ name: i, kind, index: qc_pick(rand, count), })
      }
    }
  }
  // start: any function of type 0
  let start = if callable.length() > 0 && qc_pick(rand, 3) == 0 {
    Some(callable[qc_pick(rand, callable.length())])
  } else {
    None
  }
  // element segments
  let elems : Array[QcElem] = []
  if total_funcs > 0 {
    for _i in 0..<qc_pick(rand, 3) {
      let fs : Array[Int] = []
      for _k in 0..<qc_pick(rand, 3) {
        fs.push(qc_pick(rand, total_funcs))
      }
      let e : QcElem = match
        qc_pick(rand, if tables.length() > 0 { 4 } else { 3 }) {
        0 => QEPassiveFuncs(fs)
        1 => QEDeclarative(fs)
        2 => {
          let items : Array[Int?] = []
          for f in fs {
            items.push(if qc_pick(rand, 3) == 0 { None } else { Some(f) })
          }
          QEPassiveExprs(items)
        }
        _ => QEActiveFuncs(qc_pick(rand, tables.length()), qc_pick(rand, 3), fs)
      }
      elems.push(e)
    }
  }
  // data segments
  let datas : Array[QcData] = []
  for _i in 0..<qc_pick(rand, 3) {
    let bytes : Array[Int] = []
    for _k in 0..<qc_pick(rand, 6) {
      bytes.push(
        match qc_pick(rand, 4) {
          0 => qc_pick(rand, 256)
          1 => 0x20 + qc_pick(rand, 95)
          2 => [0x22, 0x5C, 0x7F, 0x00, 0x0A][qc_pick(rand, 5)]
          _ => 0x80 + qc_pick(rand, 128)
        },
      )
    }
    if memory is Some(_) && qc_pick(rand, 2) == 0 {
      datas.push(QDActive(qc_pick(rand, 4), bytes))
    } else {
      datas.push(QDPassive(bytes))
    }
  }
  // custom sections
  let customs : Array[Int] = []
  for _i in 0..<qc_pick(rand, 3) {
    customs.push(qc_pick(rand, 64))
  }
  {
    types,
    imports,
    funcs,
    tables,
    memory,
    globals,
    exports,
    start,
    elems,
    datas,
    customs,
  }
}

///|
/// Shrinking only removes material (whole item classes, or the last
/// function together with everything that could refer to it), so every
/// candidate stays well-formed and valid.
pub impl @quickcheck.Shrink for QcModule with fn shrink(self) {
  let out : Array[QcModule] = []
  if self.customs.length() > 0 {
    out.push({ ..self, customs: [], })
  }
  if self.datas.length() > 0 {
    out.push({ ..self, datas: [], })
  }
  if self.elems.length() > 0 {
    out.push({ ..self, elems: [], })
  }
  if self.exports.length() > 0 {
    out.push({ ..self, exports: [], })
  }
  if self.start is Some(_) {
    out.push({ ..self, start: None, })
  }
  if self.memory is Some(_) {
    out.push({ ..self, memory: None, datas: [], exports: [], })
  }
  if self.tables.length() > 0 {
    out.push({ ..self, tables: [], elems: [], exports: [], })
  }
  if self.globals.length() > 0 {
    out.push({ ..self, globals: [], exports: [], })
  }
  for i, f in self.funcs {
    if f.body.length() > 0 || f.locals.length() > 0 {
      let funcs = self.funcs.copy()
      funcs[i] = { type_: f.type_, locals: [], body: [], }
      out.push({ ..self, funcs, })
    }
  }
  if self.funcs.length() > 0 {
    // dropping the last defined function invalidates references to it
    let funcs = self.funcs[0:self.funcs.length() - 1].to_owned()
    out.push({ ..self, funcs, exports: [], elems: [], start: None, })
  }
  if self.imports.length() > 0 {
    out.push({
      ..self,
      imports: [],
      exports: [],
      elems: [],
      start: None,
      funcs: [],
    })
  }
  out.iter()
}

///|
struct QcFuzz {
  bytes : Bytes
} derive(Debug)

///|
/// Bytes that steer the fuzz toward interesting decoder paths: section
/// ids and small lengths, LEB128 continuation bytes, opcodes, type codes.
fn qc_fuzz_byte(rand : @quickcheck.RandomState) -> Int {
  match qc_pick(rand, 4) {
    0 => qc_pick(rand, 16)
    1 => qc_pick(rand, 256)
    2 => 0x80 + qc_pick(rand, 16)
    _ =>
      [
        0x00, 0x01, 0x0B, 0x40, 0x4E, 0x50, 0x60, 0x63, 0x7F, 0xFB, 0xFC, 0xFD, 0xFF,
      ][qc_pick(rand, 13)]
  }
}

///|
pub impl @quickcheck.Arbitrary for QcFuzz with fn arbitrary(size, rand) {
  let out : Array[Byte] = []
  if qc_pick(rand, 4) > 0 {
    for b in ([0x00, 0x61, 0x73, 0x6D, 0x01, 0x00, 0x00, 0x00] : Array[Byte]) {
      out.push(b)
    }
  }
  let n = qc_pick(rand, 16 + (if size > 0 { size } else { 1 }) * 4)
  for _i in 0..<n {
    out.push(qc_fuzz_byte(rand).to_byte())
  }
  { bytes: Bytes::from_array(out[:]), }
}

///|
pub impl @quickcheck.Shrink for QcFuzz with fn shrink(self) {
  @quickcheck.Shrink::shrink(self.bytes).map(b => { bytes: b, })
}

///|
test "quickcheck: generated modules decode, print as expected, and validate" {
  @quickcheck.check(
    (m : QcModule) => {
      let decoded = @wasm.decode_module(m.encode())
      if decoded.print() != m.expected_print() {
        return false
      }
      @wasm.validate_module(decoded)
      true
    },
    count=300,
  )
}

///|
test "quickcheck: decoding arbitrary bytes never panics" {
  @quickcheck.check((input : QcFuzz) => {
    try {
      let m = @wasm.decode_module(input.bytes)
      m.print() |> ignore
      @wasm.validate_module(m)
      true
    } catch {
      _ => true
    }
  })
}
