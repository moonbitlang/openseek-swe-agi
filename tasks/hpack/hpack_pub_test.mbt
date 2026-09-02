///|
/// Generated from go-hpack/story_00.json
/// 3 test cases
test "valid/compat/go-hpack/story_00" {
  let decoder = @hpack.Decoder::new()

  // Case 0
  let wire_0 : Bytes = [
    0x00, 0x85, 0xb9, 0x49, 0x53, 0x39, 0xe4, 0x83, 0xc5, 0x83, 0x7f, 0x00, 0x85,
    0xb8, 0x82, 0x4e, 0x5a, 0x4b, 0x83, 0x9d, 0x29, 0xaf, 0x00, 0x88, 0xb8, 0x3b,
    0x53, 0x39, 0xec, 0x32, 0x7d, 0x7f, 0x88, 0xf4, 0x39, 0xce, 0x75, 0xc8, 0x75,
    0xfa, 0x57, 0x00, 0x84, 0xb9, 0x58, 0xd3, 0x3f, 0x81, 0x63,
  ]
  let headers_0 = decoder.decode(wire_0[:])
  assert_eq(headers_0.length(), 4)
  assert_eq(headers_0[0].name, b":method")
  assert_eq(headers_0[0].value, b"GET")
  assert_eq(headers_0[1].name, b":scheme")
  assert_eq(headers_0[1].value, b"http")
  assert_eq(headers_0[2].name, b":authority")
  assert_eq(headers_0[2].value, b"yahoo.co.jp")
  assert_eq(headers_0[3].name, b":path")
  assert_eq(headers_0[3].value, b"/")

  // Case 1
  let wire_1 : Bytes = [
    0x00, 0x85, 0xb9, 0x49, 0x53, 0x39, 0xe4, 0x83, 0xc5, 0x83, 0x7f, 0x00, 0x85,
    0xb8, 0x82, 0x4e, 0x5a, 0x4b, 0x83, 0x9d, 0x29, 0xaf, 0x00, 0x88, 0xb8, 0x3b,
    0x53, 0x39, 0xec, 0x32, 0x7d, 0x7f, 0x8c, 0xf1, 0xe3, 0xc2, 0xfe, 0x87, 0x39,
    0xce, 0xb9, 0x0e, 0xbf, 0x4a, 0xff, 0x00, 0x84, 0xb9, 0x58, 0xd3, 0x3f, 0x81,
    0x63,
  ]
  let headers_1 = decoder.decode(wire_1[:])
  assert_eq(headers_1.length(), 4)
  assert_eq(headers_1[0].name, b":method")
  assert_eq(headers_1[0].value, b"GET")
  assert_eq(headers_1[1].name, b":scheme")
  assert_eq(headers_1[1].value, b"http")
  assert_eq(headers_1[2].name, b":authority")
  assert_eq(headers_1[2].value, b"www.yahoo.co.jp")
  assert_eq(headers_1[3].name, b":path")
  assert_eq(headers_1[3].value, b"/")

  // Case 2
  let wire_2 : Bytes = [
    0x00, 0x85, 0xb9, 0x49, 0x53, 0x39, 0xe4, 0x83, 0xc5, 0x83, 0x7f, 0x00, 0x85,
    0xb8, 0x82, 0x4e, 0x5a, 0x4b, 0x83, 0x9d, 0x29, 0xaf, 0x00, 0x88, 0xb8, 0x3b,
    0x53, 0x39, 0xec, 0x32, 0x7d, 0x7f, 0x87, 0xea, 0xbf, 0xa3, 0x53, 0x32, 0xfd,
    0x2b, 0x00, 0x84, 0xb9, 0x58, 0xd3, 0x3f, 0x9b, 0x60, 0xd4, 0x8e, 0x62, 0xa1,
    0x84, 0x9e, 0xb6, 0x11, 0x58, 0x98, 0x25, 0x35, 0x31, 0x41, 0xe6, 0x3a, 0xd5,
    0x21, 0x60, 0xb2, 0x06, 0xc4, 0xf2, 0xf5, 0xd5, 0x37,
  ]
  let headers_2 = decoder.decode(wire_2[:])
  assert_eq(headers_2.length(), 4)
  assert_eq(headers_2[0].name, b":method")
  assert_eq(headers_2[0].value, b"GET")
  assert_eq(headers_2[1].name, b":scheme")
  assert_eq(headers_2[1].value, b"http")
  assert_eq(headers_2[2].name, b":authority")
  assert_eq(headers_2[2].value, b"k.yimg.jp")
  assert_eq(headers_2[3].name, b":path")
  assert_eq(headers_2[3].value, b"/images/top/sp2/cmn/logo-ns-130528.png")
}

///|
/// Index 0 is invalid - must raise InvalidIndex error
test "invalid/index/zero" {
  let decoder = @hpack.Decoder::new()
  // 0x80 = indexed header field with index 0 (invalid)
  let data : Bytes = [0x80]
  let result = Ok(decoder.decode(data[:])) catch { e => Err(e) }
  assert_true(result is Err(InvalidIndex(0)))
}

///|
/// Index beyond static table and empty dynamic table
test "invalid/index/out-of-bounds-static" {
  let decoder = @hpack.Decoder::new()
  // With empty dynamic table, index 62 should fail
  let data : Bytes = [0xbe] // 0x80 | 62 = 0xbe
  let result = Ok(decoder.decode(data[:])) catch { e => Err(e) }
  assert_true(result is Err(InvalidIndex(_)))
}

///|
test "static-table/index-1/authority" {
  let decoder = @hpack.Decoder::new()
  // Indexed header field: 0x80 | 1 = 0x81
  let encoded : Bytes = [0x81]
  let headers = decoder.decode(encoded[:])
  assert_eq(headers.length(), 1)
  assert_eq(headers[0].name, b":authority")
  assert_eq(headers[0].value, b"")
}

///|
test "static-table/index-2/method-get" {
  let decoder = @hpack.Decoder::new()
  let encoded : Bytes = [0x82]
  let headers = decoder.decode(encoded[:])
  assert_eq(headers.length(), 1)
  assert_eq(headers[0].name, b":method")
  assert_eq(headers[0].value, b"GET")
}

///|
test "static-table/index-3/method-post" {
  let decoder = @hpack.Decoder::new()
  let encoded : Bytes = [0x83]
  let headers = decoder.decode(encoded[:])
  assert_eq(headers.length(), 1)
  assert_eq(headers[0].name, b":method")
  assert_eq(headers[0].value, b"POST")
}

///|
test "static-table/index-4/path-root" {
  let decoder = @hpack.Decoder::new()
  let encoded : Bytes = [0x84]
  let headers = decoder.decode(encoded[:])
  assert_eq(headers.length(), 1)
  assert_eq(headers[0].name, b":path")
  assert_eq(headers[0].value, b"/")
}

///|
test "static-table/index-5/path-index-html" {
  let decoder = @hpack.Decoder::new()
  let encoded : Bytes = [0x85]
  let headers = decoder.decode(encoded[:])
  assert_eq(headers.length(), 1)
  assert_eq(headers[0].name, b":path")
  assert_eq(headers[0].value, b"/index.html")
}

///|
test "static-table/index-6/scheme-http" {
  let decoder = @hpack.Decoder::new()
  let encoded : Bytes = [0x86]
  let headers = decoder.decode(encoded[:])
  assert_eq(headers.length(), 1)
  assert_eq(headers[0].name, b":scheme")
  assert_eq(headers[0].value, b"http")
}

///|
test "static-table/index-7/scheme-https" {
  let decoder = @hpack.Decoder::new()
  let encoded : Bytes = [0x87]
  let headers = decoder.decode(encoded[:])
  assert_eq(headers.length(), 1)
  assert_eq(headers[0].name, b":scheme")
  assert_eq(headers[0].value, b"https")
}

///|
test "static-table/index-8/status-200" {
  let decoder = @hpack.Decoder::new()
  let encoded : Bytes = [0x88]
  let headers = decoder.decode(encoded[:])
  assert_eq(headers.length(), 1)
  assert_eq(headers[0].name, b":status")
  assert_eq(headers[0].value, b"200")
}

///|
test "static-table/index-9/status-204" {
  let decoder = @hpack.Decoder::new()
  let encoded : Bytes = [0x89]
  let headers = decoder.decode(encoded[:])
  assert_eq(headers.length(), 1)
  assert_eq(headers[0].name, b":status")
  assert_eq(headers[0].value, b"204")
}

///|
test "static-table/index-10/status-206" {
  let decoder = @hpack.Decoder::new()
  let encoded : Bytes = [0x8a]
  let headers = decoder.decode(encoded[:])
  assert_eq(headers.length(), 1)
  assert_eq(headers[0].name, b":status")
  assert_eq(headers[0].value, b"206")
}

///|
/// C.3.1 - First Request, encoder direction. RFC 7541 Appendix C.3 is this
/// encoder's output (raw string literals); each block's bytes are the RFC's
/// hex dump.
test "valid/rfc/c3-1-first-request-encode" {
  let encoder = @hpack.Encoder::new(use_huffman=false)
  let headers1 : Array[@hpack.HeaderField] = [
    { name: b":method", value: b"GET", },
    { name: b":scheme", value: b"http", },
    { name: b":path", value: b"/", },
    { name: b":authority", value: b"www.example.com", },
  ]
  let encoded1 = encoder.encode(headers1)
  let expected1 : Bytes = [
    0x82, 0x86, 0x84, 0x41, 0x0f, 0x77, 0x77, 0x77, 0x2e, 0x65, 0x78, 0x61, 0x6d,
    0x70, 0x6c, 0x65, 0x2e, 0x63, 0x6f, 0x6d,
  ]
  assert_eq(encoded1, expected1)
}

///|
/// C.4.1 - First Request, encoder direction. RFC 7541 Appendix C.4 is this
/// encoder's output (Huffman-coded string literals); each block's bytes are
/// the RFC's hex dump.
test "valid/rfc/c4-1-first-request-huffman-encode" {
  let encoder = @hpack.Encoder::new(use_huffman=true)
  let headers1 : Array[@hpack.HeaderField] = [
    { name: b":method", value: b"GET", },
    { name: b":scheme", value: b"http", },
    { name: b":path", value: b"/", },
    { name: b":authority", value: b"www.example.com", },
  ]
  let encoded1 = encoder.encode(headers1)
  let expected1 : Bytes = [
    0x82, 0x86, 0x84, 0x41, 0x8c, 0xf1, 0xe3, 0xc2, 0xe5, 0xf2, 0x3a, 0x6b, 0xa0,
    0xab, 0x90, 0xf4, 0xff,
  ]
  assert_eq(encoded1, expected1)
}

///|
/// Round trip over generated header blocks: whatever the encoder emits
/// for a sequence of blocks (dynamic table state included, in either
/// string-literal form), a fresh decoder must reproduce the fields.
test "quickcheck: encode/decode roundtrips" {
  @quickcheck.check(
    (input : (Array[Array[@hpack.HeaderField]], Bool)) => {
      let (blocks, use_huffman) = input
      let encoder = @hpack.Encoder::new(use_huffman~)
      let decoder = @hpack.Decoder::new()
      for block in blocks {
        if decoder.decode(encoder.encode(block)[:]) != block {
          return false
        }
      }
      true
    },
    count=300,
  )
}

///|
/// Round trip for the two non-indexing literal forms over arbitrary
/// octet strings, so the Huffman coder sees the whole alphabet and
/// multi-octet string lengths.
test "quickcheck: literal forms roundtrip" {
  @quickcheck.check(
    (input : (Bytes, Bytes, Bool, Bool)) => {
      let (name, value, use_huffman, never_indexed) = input
      let encoder = @hpack.Encoder::new(use_huffman~)
      let field : @hpack.HeaderField = { name, value, }
      let wire = if never_indexed {
        encoder.encode_never_indexed(field)
      } else {
        encoder.encode_without_indexing(field)
      }
      @hpack.Decoder::new().decode(wire[:]) == [field]
    },
    count=300,
  )
}

///|
test "quickcheck: decode should never panic" {
  @quickcheck.check((data : Bytes) => {
    let decoder = @hpack.Decoder::new()
    try decoder.decode(data[:]) catch {
      _ => true
    } noraise {
      _ => true
    }
  })
}
