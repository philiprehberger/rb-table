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
gem 'philiprehberger-table'
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
  align: { 1 => :right }
)
```

Supported alignments: `:left` (default), `:right`, `:center`.

## API

### `Philiprehberger::Table`

| Method | Description |
|--------|-------------|
| `.new(headers:, rows:, align:)` | Create a new table grid |

### `Philiprehberger::Table::Grid`

| Method | Description |
|--------|-------------|
| `#render(style:)` | Render the table (`:unicode`, `:ascii`, `:markdown`, `:compact`) |
| `#to_s` | Render with the default Unicode style |

### `Philiprehberger::Table::Styles`

| Constant | Description |
|----------|-------------|
| `UNICODE` | Box-drawing characters |
| `ASCII` | `+`, `-`, `\|` characters |
| `MARKDOWN` | Valid Markdown table format |
| `COMPACT` | Space-aligned, no borders |

## Development

```bash
bundle install
bundle exec rspec      # Run tests
bundle exec rubocop    # Check code style
```

## License

MIT
