# frozen_string_literal: true

require_relative 'lib/philiprehberger/table/version'

Gem::Specification.new do |spec|
  spec.name          = 'philiprehberger-table'
  spec.version       = Philiprehberger::Table::VERSION
  spec.authors       = ['Philip Rehberger']
  spec.email         = ['me@philiprehberger.com']

  spec.summary       = 'Terminal table formatting with Unicode borders, alignment, and multiple styles'
  spec.description   = 'Format data as terminal tables with Unicode, ASCII, or Markdown borders. ' \
                        'Supports column alignment, auto-sizing, ANSI color-safe width calculation, ' \
                        'and truncation for long values.'
  spec.homepage      = 'https://github.com/philiprehberger/rb-table'
  spec.license       = 'MIT'

  spec.required_ruby_version = '>= 3.1.0'

  spec.metadata['homepage_uri']          = spec.homepage
  spec.metadata['source_code_uri']       = spec.homepage
  spec.metadata['changelog_uri']         = "#{spec.homepage}/blob/main/CHANGELOG.md"
  spec.metadata['bug_tracker_uri']       = "#{spec.homepage}/issues"
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files         = Dir['lib/**/*.rb', 'LICENSE', 'README.md', 'CHANGELOG.md']
  spec.require_paths = ['lib']
end
