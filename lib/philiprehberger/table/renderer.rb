# frozen_string_literal: true

module Philiprehberger
  module Table
    # Renders table content with borders and alignment
    class Renderer
      ANSI_PATTERN = /\e\[[0-9;]*m/

      # @param headers [Array<String>] column headers
      # @param rows [Array<Array<String>>] row data
      # @param widths [Array<Integer>] column widths
      # @param align [Hash{Integer => Symbol}] column alignment overrides
      # @param style [Hash] border style definition
      def initialize(headers:, rows:, widths:, align:, style:)
        @headers = headers
        @rows = rows
        @widths = widths
        @align = align
        @style = style
      end

      # Render the full table as a string
      #
      # @return [String]
      def render
        lines = []

        case style_name
        when :markdown
          lines << render_row(@headers)
          lines << render_markdown_separator
          @rows.each { |row| lines << render_row(row) }
        when :compact
          lines << render_compact_row(@headers)
          @rows.each { |row| lines << render_compact_row(row) }
        else
          lines << render_border(:top)
          lines << render_row(@headers)
          lines << render_border(:mid)
          @rows.each { |row| lines << render_row(row) }
          lines << render_border(:bottom)
        end

        lines.join("\n")
      end

      private

      def style_name
        return :markdown if @style == Styles::MARKDOWN
        return :compact if @style == Styles::COMPACT

        :bordered
      end

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

      def render_row(cells)
        v = @style[:vertical]
        padded = cells.each_with_index.map { |cell, i| pad_cell(cell, @widths[i], i) }

        if v
          "#{v} #{padded.join(" #{v} ")} #{v}"
        else
          padded.join('  ')
        end
      end

      def render_compact_row(cells)
        padded = cells.each_with_index.map { |cell, i| pad_cell(cell, @widths[i], i) }
        padded.join('  ')
      end

      def render_border(position)
        h = @style[:horizontal]
        segments = @widths.map { |w| h * (w + 2) }

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
        segments = @widths.map do |w|
          @style[:horizontal] * (w + 2)
        end
        "#{@style[:mid_left]}#{segments.join(@style[:mid_mid])}#{@style[:mid_right]}"
      end
    end
  end
end
