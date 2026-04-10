# philiprehberger-table

[![Tests](https://github.com/philiprehberger/rb-table/actions/workflows/ci.yml/badge.svg)](https://github.com/philiprehberger/rb-table/actions/workflows/ci.yml)
[![Gem Version](https://badge.fury.io/rb/philiprehberger-table.svg)](https://rubygems.org/gems/philiprehberger-table)
[![Last updated](https://img.shields.io/github/last-commit/philiprehberger/rb-table)](https://github.com/philiprehberger/rb-table/commits/main)

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
require "philiprehberger/table"

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

### Column Truncation

```ruby
require "philiprehberger/table"

table = Philiprehberger::Table.new(
  headers: ["Name", "Description"],
  rows: [["Alice", "A very long description that should be truncated"]],
  max_width: { "Description" => 20 }
)
puts table.render
```

### Building from Hashes

Build a table directly from an array of hashes — headers are derived from the keys:

```ruby
require "philiprehberger/table"

data = [
  { name: "Alice", age: 30, city: "NYC" },
  { name: "Bob", age: 25, city: "LA" }
]

puts Philiprehberger::Table.from_hashes(data).render
```

### Adding Rows Incrementally

```ruby
table = Philiprehberger::Table.new(headers: %w[Name Age])
table.add_row(%w[Alice 30])
table.add_row(%w[Bob 25])
puts table.render
```

### ANSI Colors

ANSI escape sequences are stripped for width measurement but preserved in output, so colored text renders correctly.

## API

| Method | Description |
|--------|-------------|
| `Table.new(headers:, rows: [], align: {}, max_width: {})` | Create a new table grid with headers, optional rows, column alignment, and max column widths |
| `Table.from_hashes(data, align: {}, max_width: {})` | Build a table from an array of hashes; headers derived from keys |
| `Grid#add_row(row)` | Append a row after construction (returns self for chaining) |
| `Grid#render(style: :unicode)` | Render the table as a string (`:unicode`, `:ascii`, `:markdown`, `:compact`) |
| `Grid#to_s` | Render with the default Unicode style |
| `Styles.fetch(name)` | Return a style definition hash; raises `KeyError` for unknown styles |

## Development

```bash
bundle install
bundle exec rspec
bundle exec rubocop
```

## Support

If you find this project useful:

⭐ [Star the repo](https://github.com/philiprehberger/rb-table)

🐛 [Report issues](https://github.com/philiprehberger/rb-table/issues?q=is%3Aissue+is%3Aopen+label%3Abug)

💡 [Suggest features](https://github.com/philiprehberger/rb-table/issues?q=is%3Aissue+is%3Aopen+label%3Aenhancement)

❤️ [Sponsor development](https://github.com/sponsors/philiprehberger)

🌐 [All Open Source Projects](https://philiprehberger.com/open-source-packages)

💻 [GitHub Profile](https://github.com/philiprehberger)

🔗 [LinkedIn Profile](https://www.linkedin.com/in/philiprehberger)

## License

[MIT](LICENSE)
