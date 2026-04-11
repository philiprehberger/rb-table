# frozen_string_literal: true

module Philiprehberger
  module Table
    class Renderer
      ANSI_PATTERN = /\e\[[0-9;]*m/

      def initialize(headers:, rows:, widths:, align:, style:, style_name:, separator: false, padding: 1)
        @headers = headers
        @rows = rows
        @widths = widths
        @align = align
        @style = style
        @style_name = style_name
        @separator = separator
        @padding = padding
      end

      def render
        lines = []

        case @style_name
        when :markdown
          lines << render_data_row(@headers)
          lines << render_markdown_separator
          @rows.each { |row| lines << render_data_row(row) }
        when :compact
          lines << render_compact_row(@headers)
          @rows.each { |row| lines << render_compact_row(row) }
        else
          lines << render_border(:top)
          lines << render_data_row(@headers)
          lines << render_border(:mid)
          @rows.each_with_index do |row, i|
            lines << render_border(:mid) if @separator && i.positive?
            lines << render_data_row(row)
          end
          lines << render_border(:bottom)
        end

        lines.join("\n")
      end

      private

      def visible_length(str)
        str.to_s.gsub(ANSI_PATTERN, '').length
      end

      def pad_cell(text, width, col_index)
        text = text.to_s
        padding_needed = width - visible_length(text)
        return text if padding_needed <= 0

        alignment = @align[col_index] || :left

        case alignment
        when :right
          (' ' * padding_needed) + text
        when :center
          left_pad = padding_needed / 2
          right_pad = padding_needed - left_pad
          (' ' * left_pad) + text + (' ' * right_pad)
        else
          text + (' ' * padding_needed)
        end
      end

      def render_data_row(cells)
        v = @style[:vertical]
        pad = ' ' * @padding
        padded = @widths.each_with_index.map do |width, i|
          cell = i < cells.length ? cells[i].to_s : ''
          pad_cell(cell, width, i)
        end

        "#{v}#{pad}#{padded.join("#{pad}#{v}#{pad}")}#{pad}#{v}"
      end

      def render_compact_row(cells)
        pad = ' ' * [@padding, 1].max
        padded = @widths.each_with_index.map do |width, i|
          cell = i < cells.length ? cells[i].to_s : ''
          pad_cell(cell, width, i)
        end

        padded.join(pad * 2)
      end

      def render_border(position)
        h = @style[:horizontal]
        segments = @widths.map { |w| h * (w + (@padding * 2)) }

        case position
        when :top
          "#{@style[:top_left]}#{segments.join(@style[:top_mid])}#{@style[:top_right]}"
        when :mid
          "#{@style[:mid_left]}#{segments.join(@style[:mid_mid])}#{@style[:mid_right]}"
        when :bottom
          "#{@style[:bottom_left]}#{segments.join(@style[:bottom_mid])}#{@style[:bottom_right]}"
        end
      end

      def render_markdown_separator
        segments = @widths.map { |w| @style[:horizontal] * (w + (@padding * 2)) }
        "#{@style[:mid_left]}#{segments.join(@style[:mid_mid])}#{@style[:mid_right]}"
      end
    end
  end
end
