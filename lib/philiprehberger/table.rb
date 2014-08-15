# frozen_string_literal: true

require_relative 'table/version'
require_relative 'table/styles'
require_relative 'table/renderer'

module Philiprehberger
  module Table
    ANSI_PATTERN = /\e\[[0-9;]*m/

    def self.new(headers:, rows: [], align: {})
      Grid.new(headers: headers, rows: rows, align: align)
    end

    class Grid
      def initialize(headers:, rows: [], align: {})
        @headers = headers.map { |h| h.nil? ? '' : h.to_s }
        @rows = rows.map { |row| row.map { |cell| cell.nil? ? '' : cell.to_s } }
        @align = align
      end

      def render(style: :unicode)
        style_def = Styles.fetch(style)
        widths = calculate_widths

        Renderer.new(
          headers: @headers,
          rows: @rows,
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

      def visible_length(str)
        str.to_s.gsub(ANSI_PATTERN, '').length
      end

      def calculate_widths
        col_count = @headers.length
        widths = Array.new(col_count, 0)

        @headers.each_with_index do |header, i|
          widths[i] = [widths[i], visible_length(header)].max
        end

        @rows.each do |row|
          row.each_with_index do |cell, i|
            next if i >= col_count

            widths[i] = [widths[i], visible_length(cell)].max
          end
        end

        widths
      end
    end
  end
end
