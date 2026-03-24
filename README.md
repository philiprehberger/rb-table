# philiprehberger-table

[![Tests](https://github.com/philiprehberger/rb-table/actions/workflows/ci.yml/badge.svg)](https://github.com/philiprehberger/rb-table/actions/workflows/ci.yml)
[![Gem Version](https://badge.fury.io/rb/philiprehberger-table.svg)](https://rubygems.org/gems/philiprehberger-table)
[![License](https://img.shields.io/github/license/philiprehberger/rb-table)](LICENSE)

Terminal table formatting with Unicode borders, alignment, and multiple styles

## Requirements

- Ruby >= 3.1

## Installation

Add to your Gemfile:

```ruby
gem "philiprehberger-table"
```

Or install directly:

```bash
gem install philiprehberger-table
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

| Method | Description |
|--------|-------------|
| `Table.new(headers:, rows: [], align: {})` | Create a new table grid with headers, optional rows, and column alignment |
| `Grid#render(style: :unicode)` | Render the table as a string (`:unicode`, `:ascii`, `:markdown`, `:compact`) |
| `Grid#to_s` | Render with the default Unicode style |
| `Styles.fetch(name)` | Return a style definition hash; raises `KeyError` for unknown styles |

## Development

```bash
bundle install
bundle exec rspec
bundle exec rubocop
```

## License

MIT
