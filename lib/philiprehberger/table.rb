# frozen_string_literal: true

require_relative 'table/version'
require_relative 'table/styles'
require_relative 'table/renderer'

module Philiprehberger
  module Table
    ANSI_PATTERN = /\e\[[0-9;]*m/

    def self.new(headers:, rows: [], align: {}, max_width: {})
      Grid.new(headers: headers, rows: rows, align: align, max_width: max_width)
    end

    class Grid
      def initialize(headers:, rows: [], align: {}, max_width: {})
        @headers = headers.map { |h| h.nil? ? '' : h.to_s }
        @rows = rows.map { |row| row.map { |cell| cell.nil? ? '' : cell.to_s } }
        @align = align
        @max_width = resolve_max_width(headers, max_width)
      end

      def render(style: :unicode)
        style_def = Styles.fetch(style)
        widths = calculate_widths
        truncated_headers = apply_truncation(@headers)
        truncated_rows = @rows.map { |row| apply_truncation(row) }

        Renderer.new(
          headers: truncated_headers,
          rows: truncated_rows,
          widths: widths,
          align: @align,
          style: style_def,
          style_name: style
        ).render
      end

      def to_s
        render
      end

      private

      def resolve_max_width(headers, max_width)
        resolved = {}
        max_width.each do |key, value|
          if key.is_a?(String)
            index = headers.index { |h| (h.nil? ? '' : h.to_s) == key }
            resolved[index] = value if index
          else
            resolved[key] = value
          end
        end
        resolved
      end

      def truncate(str, max)
        return str if max.nil? || str.length <= max
        return str[0...max] if max <= 3

        "#{str[0...(max - 3)]}..."
      end

      def apply_truncation(cells)
        cells.each_with_index.map do |cell, i|
          max = @max_width[i]
          max ? truncate(cell, max) : cell
        end
      end

      def visible_length(str)
        str.to_s.gsub(ANSI_PATTERN, '').length
      end

      def calculate_widths
        col_count = @headers.length
        widths = Array.new(col_count, 0)

        @headers.each_with_index do |header, i|
          len = visible_length(header)
          len = [@max_width[i], len].min if @max_width[i]
          widths[i] = [widths[i], len].max
        end

        @rows.each do |row|
          row.each_with_index do |cell, i|
            next if i >= col_count

            len = visible_length(cell)
            len = [@max_width[i], len].min if @max_width[i]
            widths[i] = [widths[i], len].max
          end
        end

        widths
      end
    end
  end
end
