# Multiline Log Sample parser plugin for Embulk

TODO: Write short description here and embulk-parser-multiline-log-sample.gemspec file.

## Overview

* **Plugin type**: parser
* **Guess supported**: no

## Configuration

- **property1**: description (string, required)
- **property2**: description (integer, default: default-value)

## Example

```yaml
in:
  type: any file input plugin type
  parser:
    type: multiline-log-sample
    property1: example1
    property2: example2
```

(If guess supported) you don't have to write `parser:` section in the configuration file. After writing `in:` section, you can let embulk guess `parser:` section using this command:

```
$ embulk install embulk-parser-multiline-log-sample
$ embulk guess -g multiline-log-sample config.yml -o guessed.yml
```

## Build

```
$ rake
```
