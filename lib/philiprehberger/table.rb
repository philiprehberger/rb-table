# frozen_string_literal: true

require 'csv'
require_relative 'table/version'
require_relative 'table/styles'
require_relative 'table/renderer'

module Philiprehberger
  module Table
    ANSI_PATTERN = /\e\[[0-9;]*m/

    def self.new(headers:, rows: [], align: {}, max_width: {})
      Grid.new(headers: headers, rows: rows, align: align, max_width: max_width)
    end

    def self.from_hashes(data, align: {}, max_width: {})
      return Grid.new(headers: [], rows: [], align: align, max_width: max_width) if data.empty?

      headers = data.each_with_object([]) do |hash, keys|
        hash.each_key { |k| keys << k unless keys.include?(k) }
      end

      rows = data.map { |hash| headers.map { |h| hash[h] } }
      Grid.new(headers: headers.map(&:to_s), rows: rows, align: align, max_width: max_width)
    end

    def self.from_csv(string, align: {}, max_width: {})
      parsed = CSV.parse(string)
      return Grid.new(headers: [], rows: [], align: align, max_width: max_width) if parsed.empty?

      headers = parsed.first.map { |h| h.nil? ? '' : h.to_s }
      rows = parsed.drop(1).map { |row| row.map { |cell| cell.nil? ? '' : cell.to_s } }
      Grid.new(headers: headers, rows: rows, align: align, max_width: max_width)
    end

    class Grid
      def initialize(headers:, rows: [], align: {}, max_width: {})
        @headers = headers.map { |h| h.nil? ? '' : h.to_s }
        @rows = rows.map { |row| row.map { |cell| cell.nil? ? '' : cell.to_s } }
        @align = align
        @max_width = resolve_max_width(headers, max_width)
      end

      def add_row(row)
        @rows << row.map { |cell| cell.nil? ? '' : cell.to_s }
        self
      end

      def render(style: :unicode, separator: false, padding: 1)
        style_def = Styles.fetch(style)
        style_name = Styles.style_name_for(style)
        widths = calculate_widths
        truncated_headers = apply_truncation(@headers)
        truncated_rows = @rows.map { |row| apply_truncation(row) }

        Renderer.new(
          headers: truncated_headers,
          rows: truncated_rows,
          widths: widths,
          align: @align,
          style: style_def,
          style_name: style_name,
          separator: separator,
          padding: padding
        ).render
      end

      def to_s
        render
      end

      def to_csv
        lines = []
        lines << CSV.generate_line(@headers).chomp
        @rows.each { |row| lines << CSV.generate_line(row).chomp }
        lines.join("\n")
      end

      def to_html
        lines = []
        lines << '<table>'
        lines << '  <thead>'
        lines << '    <tr>'
        @headers.each { |h| lines << "      <th>#{escape_html(h)}</th>" }
        lines << '    </tr>'
        lines << '  </thead>'
        lines << '  <tbody>'
        @rows.each do |row|
          lines << '    <tr>'
          row.each { |cell| lines << "      <td>#{escape_html(cell)}</td>" }
          lines << '    </tr>'
        end
        lines << '  </tbody>'
        lines << '</table>'
        lines.join("\n")
      end

      def sort_by(column, direction: :asc)
        col_index = resolve_column_index(column)
        sorted = @rows.sort_by { |row| row[col_index].to_s }
        sorted = sorted.reverse if direction == :desc
        Grid.new(headers: @headers.dup, rows: sorted, align: @align.dup, max_width: @max_width.dup)
      end

      def filter(&)
        filtered = @rows.select(&)
        Grid.new(headers: @headers.dup, rows: filtered, align: @align.dup, max_width: @max_width.dup)
      end

      private

      def escape_html(str)
        str.to_s
           .gsub('&', '&amp;')
           .gsub('<', '&lt;')
           .gsub('>', '&gt;')
           .gsub('"', '&quot;')
      end

      def resolve_column_index(column)
        if column.is_a?(Integer)
          raise ArgumentError, "Column index #{column} out of range" if column.negative? || column >= @headers.length

          column
        else
          index = @headers.index(column.to_s)
          raise ArgumentError, "Unknown column: #{column}" unless index

          index
        end
      end

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
