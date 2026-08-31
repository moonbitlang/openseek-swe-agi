///|
test "invalid/no-equals-sign" {
  let ini_text =
    #|keyvalue
    #|
  @test.assert_raise(() => @ini.parse(ini_text))
}

///|
test "invalid/empty-key" {
  let ini_text =
    #|=value
    #|
  @test.assert_raise(() => @ini.parse(ini_text))
}

///|
test "invalid/section-after-content" {
  let ini_text =
    #|[section key=value
    #|
  @test.assert_raise(() => @ini.parse(ini_text))
}

///|
test "invalid/unclosed-quote" {
  let ini_text =
    #|key="unclosed value
    #|
  @test.assert_raise(() => @ini.parse(ini_text))
}

///|
test "invalid/mismatched-quotes-01" {
  let ini_text =
    #|value="starts with double'
    #|
  @test.assert_raise(() => @ini.parse(ini_text))
}

///|
test "invalid/mismatched-quotes-02" {
  let ini_text =
    #|value='starts with single"
    #|
  @test.assert_raise(() => @ini.parse(ini_text))
}

///|
test "invalid/section-no-open-bracket" {
  let ini_text =
    #|section]
    #|key=value
    #|
  @test.assert_raise(() => @ini.parse(ini_text))
}

///|
test "invalid/multiple-equals-without-quotes" {
  let ini_text =
    #|key=value=extra
    #|
  @test.assert_raise(() => @ini.parse(ini_text))
}

///|
test "invalid/nested-sections-brackets" {
  let ini_text =
    #|[[nested]]
    #|key=value
    #|
  @test.assert_raise(() => @ini.parse(ini_text))
}

///|
test "invalid/quote-in-section-name" {
  let ini_text =
    #|[section"name]
    #|key=value
    #|
  @test.assert_raise(() => @ini.parse(ini_text))
}

///|
test "invalid/multiline-without-backslash" {
  let ini_text =
    #|key=value
    #|continued
    #|
  @test.assert_raise(() => @ini.parse(ini_text))
}

///|
test "invalid/control-characters-in-key" {
  let ini_text =
    #|key\nname=value
    #|
  @test.assert_raise(() => @ini.parse(ini_text))
}

///|
test "invalid/section-in-value" {
  let ini_text =
    #|key=value [section]
    #|
  @test.assert_raise(() => @ini.parse(ini_text))
}

///|
test "invalid/nested-brackets-in-section" {
  let ini_text =
    #|[[section]]
    #|key=value
    #|
  @test.assert_raise(() => @ini.parse(ini_text))
}

///|
test "invalid/angle-brackets-section" {
  let ini_text =
    #|<section>
    #|key=value
    #|
  @test.assert_raise(() => @ini.parse(ini_text))
}

///|
test "invalid/key-only-spaces" {
  let ini_text =
    #|   =value
    #|
  @test.assert_raise(() => @ini.parse(ini_text))
}

///|
test "invalid/section-only-spaces" {
  let ini_text =
    #|[   ]
    #|key=value
    #|
  @test.assert_raise(() => @ini.parse(ini_text))
}

///|
test "invalid/backslash-continuation-no-newline" {
  let ini_text =
    #|key=value\
    #|
  @test.assert_raise(() => @ini.parse(ini_text))
}

///|
test "valid/spaces-around-equals" {
  let ini_text =
    #|key = value
    #|key2  =  value2
    #|
  let ini = @ini.parse(ini_text)
  assert_eq(ini, {
    global: { "key": "value", "key2": "value2" },
    sections: Map([]),
  })
}

///|
test "valid/quoted-values" {
  let ini_text =
    #|name="John Doe"
    #|path='C:\Program Files'
    #|
  let ini = @ini.parse(ini_text)
  assert_eq(ini, {
    global: { "name": "John Doe", "path": "C:\\Program Files" },
    sections: Map([]),
  })
}

///|
test "valid/special-characters-in-value" {
  let ini_text =
    #|url=http://example.com:8080/path?query=value&foo=bar
    #|email=user@example.com
    #|
  let ini = @ini.parse(ini_text)
  assert_eq(ini, {
    global: {
      "url": "http://example.com:8080/path?query=value&foo=bar",
      "email": "user@example.com",
    },
    sections: Map([]),
  })
}

///|
test "valid/empty-section" {
  let ini_text =
    #|[empty]
    #|[nonempty]
    #|key=value
    #|
  let ini = @ini.parse(ini_text)
  assert_eq(ini, {
    global: Map([]),
    sections: { "empty": Map([]), "nonempty": { "key": "value" } },
  })
}

///|
test "valid/section-with-spaces" {
  let ini_text =
    #|[section name]
    #|key=value
    #|
  let ini = @ini.parse(ini_text)
  assert_eq(ini, {
    global: Map([]),
    sections: { "section name": { "key": "value" } },
  })
}

///|
test "valid/blank-lines" {
  let ini_text =
    #|key1=value1
    #|
    #|
    #|key2=value2
    #|
    #|[section]
    #|
    #|key3=value3
    #|
  let ini = @ini.parse(ini_text)
  assert_eq(ini, {
    global: { "key1": "value1", "key2": "value2" },
    sections: { "section": { "key3": "value3" } },
  })
}

///|
test "valid/unicode-content" {
  let ini_text =
    #|[データベース]
    #|名前=テスト
    #|
  let ini = @ini.parse(ini_text)
  assert_eq(ini, {
    global: Map([]),
    sections: { "データベース": { "名前": "テスト" } },
  })
}

///|
test "valid/colon-separator" {
  let ini_text =
    #|key:value
    #|key2 : value2
    #|
  let ini = @ini.parse(ini_text)
  assert_eq(ini, {
    global: { "key": "value", "key2": "value2" },
    sections: Map([]),
  })
}

///|
test "valid/empty-ini" {
  let ini_text = ""
  let ini = @ini.parse(ini_text)
  assert_eq(ini, { global: Map([]), sections: Map([]), })
}

///|
test "valid/only-comments" {
  let ini_text =
    #|; comment 1
    #|# comment 2
    #|
  let ini = @ini.parse(ini_text)
  assert_eq(ini, { global: Map([]), sections: Map([]), })
}

///|
test "valid/duplicate-keys-last-wins" {
  let ini_text =
    #|key=value1
    #|key=value2
    #|
  let ini = @ini.parse(ini_text)
  assert_eq(ini, { global: { "key": "value2" }, sections: Map([]), })
}

///|
test "valid/multiline-value-with-backslash" {
  let ini_text =
    #|key=line1\
    #|line2\
    #|line3
    #|
  let ini = @ini.parse(ini_text)
  assert_eq(ini, { global: { "key": "line1line2line3" }, sections: Map([]), })
}

///|
test "edge/leading-whitespace" {
  let ini_text =
    #|  key=value
    #|  [section]
    #|  key2=value2
    #|
  let ini = @ini.parse(ini_text)
  assert_eq(ini, {
    global: { "key": "value" },
    sections: { "section": { "key2": "value2" } },
  })
}

///|
test "edge/trailing-whitespace" {
  let ini_text =
    #|key=value  
    #|[section]  
    #|
  let ini = @ini.parse(ini_text)
  assert_eq(ini, {
    global: { "key": "value" },
    sections: { "section": Map([]) },
  })
}

///|
test "edge/value-with-equals" {
  let ini_text =
    #|url=http://example.com?a=b&c=d
    #|
  let ini = @ini.parse(ini_text)
  assert_eq(ini, {
    global: { "url": "http://example.com?a=b&c=d" },
    sections: Map([]),
  })
}

///|
test "edge/numeric-section-name" {
  let ini_text =
    #|[123]
    #|key=value
    #|
  let ini = @ini.parse(ini_text)
  assert_eq(ini, { global: Map([]), sections: { "123": { "key": "value" } }, })
}

///|
test "edge/special-chars-in-section" {
  let ini_text =
    #|[section-name_with.special]
    #|key=value
    #|
  let ini = @ini.parse(ini_text)
  assert_eq(ini, {
    global: Map([]),
    sections: { "section-name_with.special": { "key": "value" } },
  })
}

///|
test "edge/case-sensitivity" {
  let ini_text =
    #|Key=value1
    #|key=value2
    #|KEY=value3
    #|
  let ini = @ini.parse(ini_text)
  assert_eq(ini, {
    global: { "Key": "value1", "key": "value2", "KEY": "value3" },
    sections: Map([]),
  })
}

///|
test "edge/crlf-line-endings" {
  let ini_text = "[section]\r\nkey=value\r\n"
  let ini = @ini.parse(ini_text)
  assert_eq(ini, {
    global: Map([]),
    sections: { "section": { "key": "value" } },
  })
}

///|
test "edge/boolean-like-values" {
  let ini_text =
    #|bool1=true
    #|bool2=false
    #|bool3=yes
    #|bool4=no
    #|bool5=on
    #|bool6=off
    #|
  let ini = @ini.parse(ini_text)
  assert_eq(ini, {
    global: {
      "bool1": "true",
      "bool2": "false",
      "bool3": "yes",
      "bool4": "no",
      "bool5": "on",
      "bool6": "off",
    },
    sections: Map([]),
  })
}

///|
test "valid/nested-section-appearance" {
  let ini_text =
    #|[section.subsection]
    #|key=value
    #|
  let ini = @ini.parse(ini_text)
  assert_eq(ini, {
    global: Map([]),
    sections: { "section.subsection": { "key": "value" } },
  })
}

///|
test "valid/complex-multiline" {
  let ini_text =
    #|description=This is a \
    #|very long \
    #|description
    #|
  let ini = @ini.parse(ini_text)
  assert_eq(ini, {
    global: { "description": "This is a very long description" },
    sections: Map([]),
  })
}

///|
test "valid/quoted-with-semicolon" {
  let ini_text =
    #|value="contains ; semicolon"
    #|
  let ini = @ini.parse(ini_text)
  assert_eq(ini, {
    global: { "value": "contains ; semicolon" },
    sections: Map([]),
  })
}

///|
test "valid/quoted-with-hash" {
  let ini_text =
    #|value="contains # hash"
    #|
  let ini = @ini.parse(ini_text)
  assert_eq(ini, { global: { "value": "contains # hash" }, sections: Map([]), })
}

///|
test "valid/quoted-with-newline" {
  let ini_text =
    #|value="line1
    #|line2"
    #|
  let ini = @ini.parse(ini_text)
  assert_eq(ini, { global: { "value": "line1\nline2" }, sections: Map([]), })
}

///|
test "valid/escaped-quotes-in-value" {
  let ini_text =
    #|value="She said \"Hello\""
    #|
  let ini = @ini.parse(ini_text)
  assert_eq(ini, {
    global: { "value": "She said \"Hello\"" },
    sections: Map([]),
  })
}

///|
test "valid/array-like-syntax" {
  let ini_text =
    #|colors=red,green,blue
    #|numbers=1,2,3,4,5
    #|
  let ini = @ini.parse(ini_text)
  assert_eq(ini, {
    global: { "colors": "red,green,blue", "numbers": "1,2,3,4,5" },
    sections: Map([]),
  })
}

///|
test "valid/section-overwrite" {
  let ini_text =
    #|[section]
    #|key1=value1
    #|
    #|[section]
    #|key2=value2
    #|
  let ini = @ini.parse(ini_text)
  assert_eq(ini, {
    global: Map([]),
    sections: { "section": { "key1": "value1", "key2": "value2" } },
  })
}

///|
test "valid/numbers-as-values" {
  let ini_text =
    #|integer=42
    #|negative=-17
    #|float=3.14
    #|scientific=1.23e-4
    #|
  let ini = @ini.parse(ini_text)
  assert_eq(ini, {
    global: {
      "integer": "42",
      "negative": "-17",
      "float": "3.14",
      "scientific": "1.23e-4",
    },
    sections: Map([]),
  })
}

///|
test "valid/empty-lines-between-sections" {
  let ini_text =
    #|[section1]
    #|key1=value1
    #|
    #|
    #|
    #|[section2]
    #|key2=value2
    #|
  let ini = @ini.parse(ini_text)
  assert_eq(ini, {
    global: Map([]),
    sections: {
      "section1": { "key1": "value1" },
      "section2": { "key2": "value2" },
    },
  })
}

///|
test "valid/comment-only-lines" {
  let ini_text =
    #|; Header comment
    #|# Another header comment
    #|
    #|[section]
    #|; Section comment
    #|key=value
    #|# Another section comment
    #|
  let ini = @ini.parse(ini_text)
  assert_eq(ini, {
    global: Map([]),
    sections: { "section": { "key": "value" } },
  })
}

///|
test "edge/very-long-key" {
  let ini_text =
    #|this_is_a_very_long_key_name_that_should_still_be_valid=value
    #|
  let ini = @ini.parse(ini_text)
  assert_eq(ini, {
    global: {
      "this_is_a_very_long_key_name_that_should_still_be_valid": "value",
    },
    sections: Map([]),
  })
}

///|
test "edge/very-long-section-name" {
  let ini_text =
    #|[this.is.a.very.long.section.name.that.should.still.be.valid]
    #|key=value
    #|
  let ini = @ini.parse(ini_text)
  assert_eq(ini, {
    global: Map([]),
    sections: {
      "this.is.a.very.long.section.name.that.should.still.be.valid": {
        "key": "value",
      },
    },
  })
}

///|
test "edge/windows-path-value" {
  let ini_text =
    #|path=C:\Users\John\Documents\file.txt
    #|
  let ini = @ini.parse(ini_text)
  assert_eq(ini, {
    global: { "path": "C:\\Users\\John\\Documents\\file.txt" },
    sections: Map([]),
  })
}

///|
test "edge/value-with-brackets" {
  let ini_text =
    #|value=[not a section]
    #|
  let ini = @ini.parse(ini_text)
  assert_eq(ini, { global: { "value": "[not a section]" }, sections: Map([]), })
}

///|
test "edge/whitespace-only-value" {
  let ini_text =
    #|key=   
    #|
  let ini = @ini.parse(ini_text)
  assert_eq(ini, { global: { "key": "" }, sections: Map([]), })
}

///|
test "edge/mixed-comment-styles" {
  let ini_text =
    #|; Semicolon comment
    #|key1=value1
    #|# Hash comment
    #|key2=value2 ; inline semicolon
    #|key3=value3 # inline hash
    #|
  let ini = @ini.parse(ini_text)
  assert_eq(ini, {
    global: { "key1": "value1", "key2": "value2", "key3": "value3" },
    sections: Map([]),
  })
}

///|
test "valid/tab-separated" {
  let ini_text =
    #|key	=	value
    #|
  let ini = @ini.parse(ini_text)
  assert_eq(ini, { global: { "key": "value" }, sections: Map([]), })
}

///|
test "valid/many-sections" {
  let ini_text =
    #|[section1]
    #|a=1
    #|
    #|[section2]
    #|b=2
    #|
    #|[section3]
    #|c=3
    #|
    #|[section4]
    #|d=4
    #|
    #|[section5]
    #|e=5
    #|
  let ini = @ini.parse(ini_text)
  assert_eq(ini, {
    global: Map([]),
    sections: {
      "section1": { "a": "1" },
      "section2": { "b": "2" },
      "section3": { "c": "3" },
      "section4": { "d": "4" },
      "section5": { "e": "5" },
    },
  })
}

///|
test "valid/mixed-separators" {
  let ini_text =
    #|key1=value1
    #|key2:value2
    #|key3 = value3
    #|key4 : value4
    #|
  let ini = @ini.parse(ini_text)
  assert_eq(ini, {
    global: {
      "key1": "value1",
      "key2": "value2",
      "key3": "value3",
      "key4": "value4",
    },
    sections: Map([]),
  })
}

///|
test "valid/real-world-database-config" {
  let ini_text =
    #|; Database configuration
    #|
    #|[database]
    #|driver=postgresql
    #|host=localhost
    #|port=5432
    #|username=admin
    #|password=secret123
    #|database=myapp
    #|
    #|[connection]
    #|max_connections=100
    #|timeout=30
    #|
  let ini = @ini.parse(ini_text)
  assert_eq(ini, {
    global: Map([]),
    sections: {
      "database": {
        "driver": "postgresql",
        "host": "localhost",
        "port": "5432",
        "username": "admin",
        "password": "secret123",
        "database": "myapp",
      },
      "connection": { "max_connections": "100", "timeout": "30" },
    },
  })
}

///|
test "valid/real-world-app-config" {
  let ini_text =
    #|app_name=MyApplication
    #|version=1.2.3
    #|
    #|[server]
    #|host=0.0.0.0
    #|port=8080
    #|ssl=true
    #|
    #|[logging]
    #|level=debug
    #|file=/var/log/app.log
    #|
  let ini = @ini.parse(ini_text)
  assert_eq(ini, {
    global: { "app_name": "MyApplication", "version": "1.2.3" },
    sections: {
      "server": { "host": "0.0.0.0", "port": "8080", "ssl": "true" },
      "logging": { "level": "debug", "file": "/var/log/app.log" },
    },
  })
}

///|
test "edge/special-section-chars" {
  let ini_text =
    #|[section_name-123]
    #|key=value
    #|
  let ini = @ini.parse(ini_text)
  assert_eq(ini, {
    global: Map([]),
    sections: { "section_name-123": { "key": "value" } },
  })
}

///|
test "edge/value-starts-with-quote" {
  let ini_text =
    #|quote="value
    #|
  let ini = @ini.parse(ini_text)
  assert_eq(ini, { global: { "quote": "\"value" }, sections: Map([]), })
}

///|
test "edge/value-ends-with-backslash" {
  let ini_text =
    #|path=C:\Windows\
    #|
  let ini = @ini.parse(ini_text)
  assert_eq(ini, { global: { "path": "C:\\Windows\\" }, sections: Map([]), })
}

///|
test "valid/escape-sequences" {
  let ini_text =
    #|newline=line1\nline2
    #|tab=col1\tcol2
    #|backslash=path\\to\\file
    #|
  let ini = @ini.parse(ini_text)
  assert_eq(ini, {
    global: {
      "newline": "line1\nline2",
      "tab": "col1\tcol2",
      "backslash": "path\\to\\file",
    },
    sections: Map([]),
  })
}

///|
test "valid/complex-quoted-strings" {
  let ini_text =
    #|single='single quoted'
    #|double="double quoted"
    #|mixed1="contains 'single' quotes"
    #|mixed2='contains "double" quotes'
    #|
  let ini = @ini.parse(ini_text)
  assert_eq(ini, {
    global: {
      "single": "single quoted",
      "double": "double quoted",
      "mixed1": "contains 'single' quotes",
      "mixed2": "contains \"double\" quotes",
    },
    sections: Map([]),
  })
}

///|
test "valid/whitespace-preservation-in-quotes" {
  let ini_text =
    #|value="  leading and trailing  "
    #|
  let ini = @ini.parse(ini_text)
  assert_eq(ini, {
    global: { "value": "  leading and trailing  " },
    sections: Map([]),
  })
}

///|
test "valid/unicode-special-chars" {
  let ini_text =
    #|emoji=🚀🌟💻
    #|chinese=你好世界
    #|arabic=مرحبا
    #|
  let ini = @ini.parse(ini_text)
  assert_eq(ini, {
    global: {
      "emoji": "🚀🌟💻",
      "chinese": "你好世界",
      "arabic": "مرحبا",
    },
    sections: Map([]),
  })
}

///|
test "valid/complex-real-world-config" {
  let ini_text =
    #|; Application Configuration File
    #|; Generated on 2024-01-01
    #|
    #|app_name=MyApp
    #|version=2.1.0
    #|environment=production
    #|
    #|[database]
    #|; Primary database connection
    #|driver=mysql
    #|host=db.example.com
    #|port=3306
    #|database=production_db
    #|username=app_user
    #|password="p@ssw0rd!123"
    #|charset=utf8mb4
    #|
    #|[cache]
    #|enabled=true
    #|driver=redis
    #|host=cache.example.com
    #|port=6379
    #|prefix=myapp:
    #|
    #|[logging]
    #|level=info
    #|file=/var/log/myapp/app.log
    #|max_size=10M
    #|rotate=daily
    #|
  let ini = @ini.parse(ini_text)
  assert_eq(ini, {
    global: {
      "app_name": "MyApp",
      "version": "2.1.0",
      "environment": "production",
    },
    sections: {
      "database": {
        "driver": "mysql",
        "host": "db.example.com",
        "port": "3306",
        "database": "production_db",
        "username": "app_user",
        "password": "p@ssw0rd!123",
        "charset": "utf8mb4",
      },
      "cache": {
        "enabled": "true",
        "driver": "redis",
        "host": "cache.example.com",
        "port": "6379",
        "prefix": "myapp:",
      },
      "logging": {
        "level": "info",
        "file": "/var/log/myapp/app.log",
        "max_size": "10M",
        "rotate": "daily",
      },
    },
  })
}

///|
test "valid/php-ini-style" {
  let ini_text =
    #|[PHP]
    #|engine = On
    #|short_open_tag = Off
    #|precision = 14
    #|output_buffering = 4096
    #|implicit_flush = Off
    #|serialize_precision = -1
    #|
    #|[Date]
    #|date.timezone = UTC
    #|
  let ini = @ini.parse(ini_text)
  assert_eq(ini, {
    global: Map([]),
    sections: {
      "PHP": {
        "engine": "On",
        "short_open_tag": "Off",
        "precision": "14",
        "output_buffering": "4096",
        "implicit_flush": "Off",
        "serialize_precision": "-1",
      },
      "Date": { "date.timezone": "UTC" },
    },
  })
}

///|
test "valid/git-config-style" {
  let ini_text =
    #|[core]
    #|repositoryformatversion = 0
    #|filemode = true
    #|bare = false
    #|logallrefupdates = true
    #|
    #|[remote "origin"]
    #|url = https://github.com/user/repo.git
    #|fetch = +refs/heads/*:refs/remotes/origin/*
    #|
  let ini = @ini.parse(ini_text)
  assert_eq(ini, {
    global: Map([]),
    sections: {
      "core": {
        "repositoryformatversion": "0",
        "filemode": "true",
        "bare": "false",
        "logallrefupdates": "true",
      },
      "remote \"origin\"": {
        "url": "https://github.com/user/repo.git",
        "fetch": "+refs/heads/*:refs/remotes/origin/*",
      },
    },
  })
}

///|
test "valid/systemd-unit-style" {
  let ini_text =
    #|[Unit]
    #|Description=My Service
    #|After=network.target
    #|
    #|[Service]
    #|Type=simple
    #|ExecStart=/usr/bin/myapp
    #|Restart=always
    #|
    #|[Install]
    #|WantedBy=multi-user.target
    #|
  let ini = @ini.parse(ini_text)
  assert_eq(ini, {
    global: Map([]),
    sections: {
      "Unit": { "Description": "My Service", "After": "network.target" },
      "Service": {
        "Type": "simple",
        "ExecStart": "/usr/bin/myapp",
        "Restart": "always",
      },
      "Install": { "WantedBy": "multi-user.target" },
    },
  })
}

///|
test "edge/key-with-dots" {
  let ini_text =
    #|key.with.dots=value
    #|
  let ini = @ini.parse(ini_text)
  assert_eq(ini, { global: { "key.with.dots": "value" }, sections: Map([]), })
}

///|
test "edge/key-with-dashes" {
  let ini_text =
    #|key-with-dashes=value
    #|
  let ini = @ini.parse(ini_text)
  assert_eq(ini, { global: { "key-with-dashes": "value" }, sections: Map([]), })
}

///|
test "edge/numeric-keys" {
  let ini_text =
    #|123=numeric key
    #|456.789=dotted numeric
    #|
  let ini = @ini.parse(ini_text)
  assert_eq(ini, {
    global: { "123": "numeric key", "456.789": "dotted numeric" },
    sections: Map([]),
  })
}

///|
test "edge/url-as-value" {
  let ini_text =
    #|url=https://example.com:8080/path?param1=value1&param2=value2#fragment
    #|
  let ini = @ini.parse(ini_text)
  assert_eq(ini, {
    global: {
      "url": "https://example.com:8080/path?param1=value1&param2=value2#fragment",
    },
    sections: Map([]),
  })
}

///|
test "edge/json-like-value" {
  let ini_text =
    #|json={"key":"value","array":[1,2,3]}
    #|
  let ini = @ini.parse(ini_text)
  assert_eq(ini, {
    global: { "json": "{\"key\":\"value\",\"array\":[1,2,3]}" },
    sections: Map([]),
  })
}

///|
test "edge/base64-like-value" {
  let ini_text =
    #|token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIn0
    #|
  let ini = @ini.parse(ini_text)
  assert_eq(ini, {
    global: {
      "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIn0",
    },
    sections: Map([]),
  })
}

///|
test "edge/section-with-unicode" {
  let ini_text =
    #|[セクション]
    #|キー=値
    #|
  let ini = @ini.parse(ini_text)
  assert_eq(ini, {
    global: Map([]),
    sections: { "セクション": { "キー": "値" } },
  })
}

///|
test "edge/section-with-emoji" {
  let ini_text =
    #|[🚀 rocket]
    #|speed=fast
    #|
  let ini = @ini.parse(ini_text)
  assert_eq(ini, {
    global: Map([]),
    sections: { "🚀 rocket": { "speed": "fast" } },
  })
}

///|
test "valid/long-multiline-value" {
  let ini_text =
    #|long_text=This is a very long line that \
    #|continues on the next line and \
    #|then continues again and \
    #|finally ends here
    #|
  let ini = @ini.parse(ini_text)
  assert_eq(ini, {
    global: {
      "long_text": "This is a very long line that continues on the next line and then continues again and finally ends here",
    },
    sections: Map([]),
  })
}

///|
test "valid/key-value-no-space" {
  let ini_text =
    #|key=value
    #|key2:value2
    #|
  let ini = @ini.parse(ini_text)
  assert_eq(ini, {
    global: { "key": "value", "key2": "value2" },
    sections: Map([]),
  })
}

///|
test "edge/quoted-section-name" {
  let ini_text =
    #|["quoted section"]
    #|key=value
    #|
  let ini = @ini.parse(ini_text)
  assert_eq(ini, {
    global: Map([]),
    sections: { "quoted section": { "key": "value" } },
  })
}

///|
test "edge/single-quoted-section-name" {
  let ini_text =
    #|['quoted section']
    #|key=value
    #|
  let ini = @ini.parse(ini_text)
  assert_eq(ini, {
    global: Map([]),
    sections: { "quoted section": { "key": "value" } },
  })
}

///|
test "edge/backslash-at-eol-without-continuation" {
  let ini_text =
    #|path=C:\Program Files\
    #|nextkey=value
    #|
  let ini = @ini.parse(ini_text)
  assert_eq(ini, {
    global: { "path": "C:\\Program Files\\", "nextkey": "value" },
    sections: Map([]),
  })
}

///|
test "edge/all-empty-values" {
  let ini_text =
    #|key1=
    #|key2=
    #|key3=
    #|
  let ini = @ini.parse(ini_text)
  assert_eq(ini, {
    global: { "key1": "", "key2": "", "key3": "" },
    sections: Map([]),
  })
}

///|
test "edge/mixed-quote-types-in-value" {
  let ini_text =
    #|value=It's a "test" value
    #|
  let ini = @ini.parse(ini_text)
  assert_eq(ini, {
    global: { "value": "It's a \"test\" value" },
    sections: Map([]),
  })
}

///|
test "edge/preserve-internal-whitespace" {
  let ini_text =
    #|text=hello    world    with    spaces
    #|
  let ini = @ini.parse(ini_text)
  assert_eq(ini, {
    global: { "text": "hello    world    with    spaces" },
    sections: Map([]),
  })
}

///|
test "edge/comment-char-in-quoted-value" {
  let ini_text =
    #|comment="#not a comment"
    #|semicolon=";also not a comment"
    #|
  let ini = @ini.parse(ini_text)
  assert_eq(ini, {
    global: { "comment": "#not a comment", "semicolon": ";also not a comment" },
    sections: Map([]),
  })
}
