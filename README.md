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

### Custom Styles

Pass a custom style hash to define your own border characters:

```ruby
custom = {
  top_left: '*', top_right: '*', bottom_left: '*', bottom_right: '*',
  horizontal: '=', vertical: '!',
  top_mid: '*', bottom_mid: '*',
  mid_left: '*', mid_right: '*', mid_mid: '*'
}
puts table.render(style: custom)
```

### Row Separators

Add horizontal dividers between data rows for improved readability:

```ruby
puts table.render(separator: true)
# ┌───────┬─────┬──────┐
# │ Name  │ Age │ City │
# ├───────┼─────┼──────┤
# │ Alice │ 30  │ NYC  │
# ├───────┼─────┼──────┤
# │ Bob   │ 25  │ LA   │
# └───────┴─────┴──────┘
```

### Cell Padding

Control the spacing around cell content:

```ruby
puts table.render(padding: 2)   # wider cells
puts table.render(padding: 0)   # no padding
```

### CSV Export

```ruby
table = Philiprehberger::Table.new(
  headers: %w[Name Age City],
  rows: [%w[Alice 30 NYC], %w[Bob 25 LA]]
)

puts table.to_csv
# Name,Age,City
# Alice,30,NYC
# Bob,25,LA
```

Values containing commas or newlines are automatically quoted.

### HTML Export

```ruby
puts table.to_html
# <table>
#   <thead>
#     <tr>
#       <th>Name</th>
#       <th>Age</th>
#       <th>City</th>
#     </tr>
#   </thead>
#   <tbody>
#     <tr>
#       <td>Alice</td>
#       <td>30</td>
#       <td>NYC</td>
#     </tr>
#     ...
#   </tbody>
# </table>
```

HTML special characters (`<`, `>`, `&`, `"`) are escaped in the output.

### Sorting

```ruby
sorted = table.sort_by('Age')               # ascending by column name
sorted = table.sort_by(1, direction: :desc)  # descending by column index
```

Returns a new Grid without mutating the original.

### Filtering

```ruby
filtered = table.filter { |row| row[1].to_i >= 30 }
```

Returns a new Grid containing only rows where the block returns truthy.

### Import from CSV

```ruby
csv_string = "Name,Age,City\nAlice,30,NYC\nBob,25,LA"
table = Philiprehberger::Table.from_csv(csv_string)
puts table.render
```

The first row is treated as headers.

### ANSI Colors

ANSI escape sequences are stripped for width measurement but preserved in output, so colored text renders correctly.

## API

| Method | Description |
|--------|-------------|
| `Table.new(headers:, rows: [], align: {}, max_width: {})` | Create a new table grid with headers, optional rows, column alignment, and max column widths |
| `Table.from_hashes(data, align: {}, max_width: {})` | Build a table from an array of hashes; headers derived from keys |
| `Table.from_csv(string, align: {}, max_width: {})` | Parse a CSV string (first row as headers) and construct a Grid |
| `Grid#add_row(row)` | Append a row after construction (returns self for chaining) |
| `Grid#render(style: :unicode, separator: false, padding: 1)` | Render the table as a string; style accepts `:unicode`, `:ascii`, `:markdown`, `:compact`, or a custom hash |
| `Grid#to_s` | Render with the default Unicode style |
| `Grid#to_csv` | Export table data as a CSV string; values with commas or newlines are quoted |
| `Grid#to_html` | Export as HTML `<table>` with `<thead>` and `<tbody>`; special characters are escaped |
| `Grid#sort_by(column, direction: :asc)` | Return a new Grid sorted by column name (String) or index (Integer) |
| `Grid#filter { \|row\| }` | Return a new Grid with only rows where block returns truthy |
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
