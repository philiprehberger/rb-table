# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.5.0] - 2026-04-14

### Added
- `Grid#to_csv` exports table data as a CSV string with proper quoting
- `Grid#to_html` exports table as HTML `<table>` with `<thead>` and `<tbody>`, with HTML escaping
- `Grid#sort_by(column, direction: :asc)` returns a new sorted Grid by column name or index
- `Grid#filter { |row| }` returns a new Grid containing only rows where block returns truthy
- `Table.from_csv(string)` parses a CSV string (first row as headers) and constructs a Grid

## [0.4.0] - 2026-04-10

### Added
- Custom styles: pass a hash of border characters to `render(style:)` instead of a preset symbol
- Row separators: `render(separator: true)` adds horizontal dividers between data rows
- Configurable cell padding: `render(padding: N)` controls spacing around cell content

### Fixed
- Double blank line in CHANGELOG between v0.1.7 and v0.1.6

## [0.3.0] - 2026-04-09

### Added
- `Table.from_hashes(data)` builds a table from an array of hashes, deriving headers from keys
- `Grid#add_row(row)` appends rows after construction for incremental table building

### Fixed
- Gemspec author and email to match standard template
- Gemspec `required_ruby_version` format to `'>= 3.1.0'`

## [0.2.0] - 2026-04-04

### Added
- `max_width` option for column truncation with `...` suffix
- GitHub issue template gem version field
- Feature request "Alternatives considered" field

## [0.1.9] - 2026-03-31

### Added
- Add GitHub issue templates, dependabot config, and PR template

## [0.1.8] - 2026-03-31

### Changed
- Standardize README badges, support section, and license format

## [0.1.7] - 2026-03-26

### Changed
- Add Sponsor badge to README
- Fix License section format

## [0.1.6] - 2026-03-24

### Fixed
- Standardize README code examples to use double-quote require statements

## [0.1.5] - 2026-03-24

### Fixed
- Standardize README API section to table format

## [0.1.4] - 2026-03-23

### Fixed
- Standardize README to match template (installation order, code fences, license section, one-liner format)
- Update gemspec summary to match README description

## [0.1.3] - 2026-03-22

### Changed
- Fix README badges to match template (Tests, Gem Version, License)

## [0.1.2] - 2026-03-22

### Added
- Expanded test suite from 21 to 30+ examples covering wide tables, many rows, numeric alignment, mixed types, nil headers, markdown validation, ANSI width calculation, and unknown style errors

## [0.1.0] - 2026-03-22

### Added

- Table rendering with Unicode, ASCII, Markdown, and compact styles
- Column alignment: left (default), right, and center
- Auto-sizing columns to fit widest content
- ANSI color-safe width calculation
- Nil cell handling (rendered as empty strings)
- `Renderer` class for border drawing and layout
- `Styles` module with predefined style definitions

[0.5.0]: https://github.com/philiprehberger/rb-table/releases/tag/v0.5.0
[0.4.0]: https://github.com/philiprehberger/rb-table/releases/tag/v0.4.0
[0.3.0]: https://github.com/philiprehberger/rb-table/releases/tag/v0.3.0
[0.2.0]: https://github.com/philiprehberger/rb-table/releases/tag/v0.2.0
[0.1.9]: https://github.com/philiprehberger/rb-table/releases/tag/v0.1.9
[0.1.8]: https://github.com/philiprehberger/rb-table/releases/tag/v0.1.8
[0.1.7]: https://github.com/philiprehberger/rb-table/releases/tag/v0.1.7
[0.1.6]: https://github.com/philiprehberger/rb-table/releases/tag/v0.1.6
[0.1.5]: https://github.com/philiprehberger/rb-table/releases/tag/v0.1.5
[0.1.4]: https://github.com/philiprehberger/rb-table/releases/tag/v0.1.4
[0.1.3]: https://github.com/philiprehberger/rb-table/releases/tag/v0.1.3
[0.1.2]: https://github.com/philiprehberger/rb-table/releases/tag/v0.1.2
[0.1.0]: https://github.com/philiprehberger/rb-table/releases/tag/v0.1.0
