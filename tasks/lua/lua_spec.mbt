///|
/// How executing a Lua chunk can fail.
///
/// - `SyntaxError` means the source is not a valid Lua 5.4 chunk: the
///   error was detected while lexing, parsing, or compiling, before any
///   code ran. Examples: an invalid token, an unclosed block (missing
///   `end`), `break` outside a loop, `...` in a non-vararg function.
/// - `RuntimeError` means the chunk compiled but its execution raised a
///   Lua error that no `pcall`/`xpcall` in the program caught. Examples:
///   `error(...)`, a failed `assert(...)`, arithmetic or concatenation on
///   invalid operands, indexing or calling `nil`, yielding from the main
///   coroutine, bad arguments to a standard-library function.
///
/// The `String` payload is a human-readable message. The tests match only
/// the variant, never the message text, but a helpful message (for
/// example, in the `chunk:line: description` style of the reference
/// interpreter) makes failures much easier to debug.
pub(all) suberror LuaError {
  SyntaxError(String)
  RuntimeError(String)
} derive(Debug)

///|
/// Execute a Lua 5.4 chunk in a fresh interpreter.
///
/// Parameters:
///
/// - `src`: Lua source text (a chunk, as the reference implementation
///   would `load` it in text mode).
///
/// Every call runs in a brand-new VM: no state (globals, metatables,
/// loaded chunks) is shared between calls, so execution is deterministic.
/// The standard libraries required by this suite are loaded: base
/// (including `assert`, `error`, `pcall`, `xpcall`, `type`, `tostring`,
/// `tonumber`, `pairs`, `ipairs`, `next`, `select`, `load`, `rawget`,
/// `rawset`, `rawequal`, `rawlen`, `setmetatable`, `getmetatable`),
/// `string`, `table`, `math`, and `coroutine`.
///
/// Returns unit when the chunk runs to completion.
///
/// Raises `SyntaxError` when the source fails to compile as a Lua 5.4
/// chunk, and `RuntimeError` when the compiled chunk fails at run time
/// with an error not caught inside the program (a failed `assert` is a
/// runtime error).
///
/// Examples:
///
///     exec("assert(2 + 3 == 5)")          returns
///     exec("local = 1")                   raises SyntaxError
///     exec("error('boom')")               raises RuntimeError
///     exec("assert(false, 'boom')")       raises RuntimeError
///
declare pub fn exec(src : StringView) -> Unit raise LuaError
