# frozen_string_literal: true

require_relative 'table/version'
require_relative 'table/styles'
require_relative 'table/renderer'

module Philiprehberger
  module Table
    class Error < StandardError; end

    ANSI_PATTERN = /\e\[[0-9;]*m/

    # Create a new table
    #
    # @param headers [Array<String>] column headers
    # @param rows [Array<Array<String>>] row data
    # @param align [Hash{Integer => Symbol}] column alignment (:left, :right, :center)
    # @return [Grid] a renderable table
    # @raise [Error] if headers is not an Array
    def self.new(headers:, rows: [], align: {})
      Grid.new(headers: headers, rows: rows, align: align)
    end

    # A table grid that can be rendered in multiple styles
    class Grid
      # @param headers [Array<String>] column headers
      # @param rows [Array<Array<String>>] row data
      # @param align [Hash{Integer => Symbol}] column alignment overrides
      def initialize(headers:, rows: [], align: {})
        raise Error, 'Headers must be an Array' unless headers.is_a?(Array)

        @headers = headers.map(&:to_s)
        @rows = rows.map { |row| row.map(&:to_s) }
        @align = align
      end

      # Render the table as a string
      #
      # @param style [Symbol] :unicode (default), :ascii, :markdown, or :compact
      # @return [String]
      def render(style: :unicode)
        style_def = Styles.fetch(style)
        widths = calculate_widths

        Renderer.new(
          headers: @headers,
          rows: @rows,
          widths: widths,
          align: @align,
          style: style_def
        ).render
      end

      # @return [String]
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
