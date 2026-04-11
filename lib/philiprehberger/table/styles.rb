# frozen_string_literal: true

module Philiprehberger
  module Table
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
        horizontal: '-', vertical: '|',
        mid_left: '|', mid_right: '|', mid_mid: '|'
      }.freeze

      COMPACT = {}.freeze

      REGISTRY = {
        unicode: UNICODE,
        ascii: ASCII,
        markdown: MARKDOWN,
        compact: COMPACT
      }.freeze

      def self.fetch(name)
        return name if name.is_a?(Hash)

        REGISTRY.fetch(name) { raise KeyError, "Unknown style: #{name}. Use: #{REGISTRY.keys.join(', ')}" }
      end

      def self.style_name_for(style)
        return style unless style.is_a?(Hash)

        REGISTRY.each { |key, value| return key if value == style }
        :custom
      end
    end
  end
end
