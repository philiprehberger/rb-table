# frozen_string_literal: true

module Philiprehberger
  module Table
    # Predefined table border styles
    module Styles
      UNICODE = {
        top_left: "\u250C", top_right: "\u2510", bottom_left: "\u2514", bottom_right: "\u2518",
        horizontal: "\u2500", vertical: "\u2502",
        top_mid: "\u252C", bottom_mid: "\u2534",
        mid_left: "\u251C", mid_right: "\u2524", mid_mid: "\u253C"
      }.freeze

      ASCII = {
        top_left: '+', top_right: '+', bottom_left: '+', bottom_right: '+',
        horizontal: '-', vertical: '|',
        top_mid: '+', bottom_mid: '+',
        mid_left: '+', mid_right: '+', mid_mid: '+'
      }.freeze

      MARKDOWN = {
        top_left: nil, top_right: nil, bottom_left: nil, bottom_right: nil,
        horizontal: '-', vertical: '|',
        top_mid: nil, bottom_mid: nil,
        mid_left: '|', mid_right: '|', mid_mid: '|'
      }.freeze

      COMPACT = {
        top_left: nil, top_right: nil, bottom_left: nil, bottom_right: nil,
        horizontal: nil, vertical: nil,
        top_mid: nil, bottom_mid: nil,
        mid_left: nil, mid_right: nil, mid_mid: nil
      }.freeze

      REGISTRY = {
        unicode: UNICODE,
        ascii: ASCII,
        markdown: MARKDOWN,
        compact: COMPACT
      }.freeze

      # Look up a style by name
      #
      # @param name [Symbol] :unicode, :ascii, :markdown, or :compact
      # @return [Hash] style definition
      # @raise [KeyError] if style is not found
      def self.fetch(name)
        REGISTRY.fetch(name) { raise KeyError, "Unknown style: #{name}. Use: #{REGISTRY.keys.join(', ')}" }
      end
    end
  end
end
