///|
test "invalid/unclosed-section" {
  let ini_text =
    #|[section
    #|key=value
    #|
  @test.assert_raise(() => @ini.parse(ini_text))
}

///|
test "invalid/empty-section-name" {
  let ini_text =
    #|[]
    #|key=value
    #|
  @test.assert_raise(() => @ini.parse(ini_text))
}

///|
test "valid/simple-key-value" {
  let ini_text =
    #|key=value
    #|
  let ini = @ini.parse(ini_text)
  assert_eq(ini, { global: { "key": "value" }, sections: Map([]), })
}

///|
test "valid/multiple-keys" {
  let ini_text =
    #|name=John
    #|age=30
    #|city=NYC
    #|
  let ini = @ini.parse(ini_text)
  assert_eq(ini, {
    global: { "name": "John", "age": "30", "city": "NYC" },
    sections: Map([]),
  })
}

///|
test "valid/simple-section" {
  let ini_text =
    #|[database]
    #|host=localhost
    #|port=5432
    #|
  let ini = @ini.parse(ini_text)
  assert_eq(ini, {
    global: Map([]),
    sections: { "database": { "host": "localhost", "port": "5432" } },
  })
}

///|
test "valid/multiple-sections" {
  let ini_text =
    #|[database]
    #|host=localhost
    #|port=5432
    #|
    #|[server]
    #|port=8080
    #|debug=true
    #|
  let ini = @ini.parse(ini_text)
  assert_eq(ini, {
    global: Map([]),
    sections: {
      "database": { "host": "localhost", "port": "5432" },
      "server": { "port": "8080", "debug": "true" },
    },
  })
}

///|
test "valid/global-and-sections" {
  let ini_text =
    #|global_key=global_value
    #|
    #|[section1]
    #|key1=value1
    #|
    #|[section2]
    #|key2=value2
    #|
  let ini = @ini.parse(ini_text)
  assert_eq(ini, {
    global: { "global_key": "global_value" },
    sections: {
      "section1": { "key1": "value1" },
      "section2": { "key2": "value2" },
    },
  })
}

///|
test "valid/comments-semicolon" {
  let ini_text =
    #|; This is a comment
    #|key=value ; inline comment
    #|
  let ini = @ini.parse(ini_text)
  assert_eq(ini, { global: { "key": "value" }, sections: Map([]), })
}

///|
test "valid/comments-hash" {
  let ini_text =
    #|# This is a comment
    #|key=value # inline comment
    #|
  let ini = @ini.parse(ini_text)
  assert_eq(ini, { global: { "key": "value" }, sections: Map([]), })
}

///|
test "valid/empty-value" {
  let ini_text =
    #|key=
    #|
  let ini = @ini.parse(ini_text)
  assert_eq(ini, { global: { "key": "" }, sections: Map([]), })
}

///|
test "quickcheck: roundtrips" {
  @quickcheck.check(
    (doc : Doc) => @ini.parse(@ini.print(doc)) == doc,
    count=300,
  )
}

///|
test "quickcheck: parse should never panic" {
  @quickcheck.check((s : String) => {
    try @ini.parse(s) catch {
      _ => true
    } noraise {
      _ => true
    }
  })
}
