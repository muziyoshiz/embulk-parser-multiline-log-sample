# Sample of Embulk parser plugin for multiline logs

This is a parser plugin for parsing _fictional_ Java application logs that include stack traces of the Java application.

This plugin is just a sample of Embulk parser plugin. Please modify the plugin for your needs.

## Overview

* **Plugin type**: parser
* **Guess supported**: no

## Configuration

- **charset**: Charset for LineDecoder utility (string, default: utf-8)
- **newline**: Newline for LineDecoder utility (string, default: CRLF)
- **log_levels**: Log levels accepted by the parser. If nil, all log levels are accepted (array of string, default: nil)

## Example

```yaml
in:
  type: any file input plugin type
  parser:
    type: multiline-log-sample
    charset: UTF-8
    newline: LF
    log_levels: [ "WARN", "ERROR" ]
```

## Build

```
$ rake
```

## Sample of target _fictional_ Java application logs

```
2015-03-14 20:12:22,123 [ERROR] Book reader error
Exception in thread "main" java.lang.IllegalStateException: A book has a null property
        at com.example.myproject.Author.getBookIds(Author.java:38)
        at com.example.myproject.Bootstrap.main(Bootstrap.java:14)
Caused by: java.lang.NullPointerException
        at com.example.myproject.Book.getId(Book.java:22)
        at com.example.myproject.Author.getBookIds(Author.java:35)
        ... 1 more
2015-03-14 20:13:34,456 [INFO] Login (userId=12345)
2015-03-14 20:13:41,678 [INFO] Login (userId=2345)
2015-03-14 20:13:34,456 [WARN] Suspected SQL injection attack (input="; DROP TABLE USERS --")
2015-03-14 20:15:03,001 [INFO] Login (userId=3456789)
2015-03-14 20:16:00,000 [ERROR] Indescribable error
2015-03-14 20:16:45,183 [ERROR] Book reader error
Exception in thread "main" java.lang.IllegalStateException: A book has a null property
        at com.example.myproject.Author.getBookIds(Author.java:38)
        at com.example.myproject.Bootstrap.main(Bootstrap.java:14)
Caused by: java.sql.SQLException: Unknown reason
        at com.example.myproject.Book.getId(Book.java:32)
        at com.example.myproject.Author.getBookIds(Author.java:35)
        ... 1 more
```
