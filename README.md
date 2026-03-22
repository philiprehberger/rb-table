# philiprehberger-table

[![Gem Version](https://badge.fury.io/rb/philiprehberger-table.svg)](https://badge.fury.io/rb/philiprehberger-table)
[![CI](https://github.com/philiprehberger/rb-table/actions/workflows/ci.yml/badge.svg)](https://github.com/philiprehberger/rb-table/actions/workflows/ci.yml)

Terminal table formatting with Unicode borders, alignment, and multiple styles.

## Requirements

- Ruby >= 3.1

## Installation

```sh
gem install philiprehberger-table
```

Or add to your Gemfile:

```ruby
gem 'philiprehberger-table'
```

## Usage

```ruby
require 'philiprehberger/table'

table = Philiprehberger::Table.new(
  headers: %w[Name Age City],
  rows: [
    %w[Alice 30 NYC],
    %w[Bob 25 LA]
  ]
)

puts table.render
# ┌───────┬─────┬──────┐
# │ Name  │ Age │ City │
# ├───────┼─────┼──────┤
# │ Alice │ 30  │ NYC  │
# │ Bob   │ 25  │ LA   │
# └───────┴─────┴──────┘
```

### Styles

```ruby
table.render(style: :unicode)   # Unicode box-drawing (default)
table.render(style: :ascii)     # +---+---+ borders
table.render(style: :markdown)  # | col | col | (valid Markdown)
table.render(style: :compact)   # Space-aligned, no borders
```

### Column Alignment

```ruby
table = Philiprehberger::Table.new(
  headers: %w[Name Amount],
  rows: [%w[Alice 100], %w[Bob 50]],
  align: { 0 => :left, 1 => :right }
)
```

Supported alignments: `:left` (default), `:right`, `:center`.

### ANSI Colors

ANSI escape sequences are stripped for width measurement but preserved in output, so colored text renders correctly.

## API

### `Philiprehberger::Table.new(headers:, rows:, align:)`

Creates a new table. Returns a `Grid` instance.

- `headers` - Array of column header strings
- `rows` - Array of row arrays (default: `[]`)
- `align` - Hash mapping column index to `:left`, `:right`, or `:center` (default: `{}`)

### `Grid#render(style: :unicode)`

Renders the table as a string. Style can be `:unicode`, `:ascii`, `:markdown`, or `:compact`.

### `Grid#to_s`

Renders with the default Unicode style.

### `Styles.fetch(name)`

Returns a style definition hash. Raises `KeyError` for unknown styles.

## Development

```sh
bundle install
bundle exec rspec
bundle exec rubocop
```

## License

MIT License. See [LICENSE](LICENSE) for details.
