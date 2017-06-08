# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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
