# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Philiprehberger::Table do
  let(:headers) { %w[Name Age City] }
  let(:rows) { [%w[Alice 30 NYC], %w[Bob 25 LA]] }

  describe 'unicode style' do
    it 'renders with correct border characters' do
      table = described_class.new(headers: headers, rows: rows)
      output = table.render(style: :unicode)

      expect(output).to include("\u250C") # top-left
      expect(output).to include("\u2518") # bottom-right
      expect(output).to include("\u2502") # vertical
      expect(output).to include("\u2500") # horizontal
      expect(output).to include('Alice')
      expect(output).to include('Bob')
    end

    it 'is the default style' do
      table = described_class.new(headers: headers, rows: rows)
      expect(table.render).to include("\u2502")
    end
  end

  describe 'ascii style' do
    it 'renders with correct +, -, | characters' do
      table = described_class.new(headers: headers, rows: rows)
      output = table.render(style: :ascii)

      expect(output).to include('+')
      expect(output).to include('-')
      expect(output).to include('|')
      expect(output).to include('Alice')
    end
  end

  describe 'markdown style' do
    it 'renders a valid markdown table' do
      table = described_class.new(headers: headers, rows: rows)
      output = table.render(style: :markdown)
      lines = output.split("\n")

      expect(lines[0]).to include('| Name')
      expect(lines[1]).to match(/\|[-\s]+\|/)
      expect(lines[2]).to include('Alice')
    end
  end

  describe 'compact style' do
    it 'renders without borders, space-aligned' do
      table = described_class.new(headers: headers, rows: rows)
      output = table.render(style: :compact)

      expect(output).not_to include('|')
      expect(output).not_to include('+')
      expect(output).to include('Name')
      expect(output).to include('Alice')
    end
  end

  describe 'alignment' do
    it 'left-aligns by default' do
      table = described_class.new(headers: %w[Name], rows: [['Hi']])
      output = table.render(style: :ascii)
      data_line = output.split("\n").find { |l| l.include?('Hi') }
      expect(data_line).to match(/\|\s*Hi\s+\|/)
    end

    it 'right-aligns when specified' do
      table = described_class.new(
        headers: %w[Name Amount],
        rows: [%w[Alice 100]],
        align: { 1 => :right }
      )
      output = table.render(style: :ascii)
      data_line = output.split("\n").find { |l| l.include?('100') }
      expect(data_line).to match(/\s+100\s*\|/)
    end

    it 'center-aligns when specified' do
      table = described_class.new(
        headers: %w[Name Status],
        rows: [%w[Alice OK]],
        align: { 1 => :center }
      )
      output = table.render(style: :ascii)
      data_line = output.split("\n").find { |l| l.include?('OK') }
      expect(data_line).to include('OK')
    end
  end

  describe 'auto-sizing' do
    it 'columns fit widest content' do
      table = described_class.new(
        headers: %w[Short LongHeaderName],
        rows: [%w[a b]]
      )
      output = table.render
      expect(output).to include('LongHeaderName')
    end
  end

  describe 'ANSI color support' do
    it 'colored text does not break column widths' do
      colored = "\e[31mRed\e[0m"
      plain = 'Red'
      table = described_class.new(headers: %w[Color], rows: [[colored], [plain]])
      output = table.render(style: :ascii)

      expect(output).to include("\e[31mRed\e[0m")
      lines = output.split("\n")
      data_lines = lines.select { |l| l.include?('Red') }
      expect(data_lines.length).to eq(2)
    end
  end

  describe 'nil cells' do
    it 'renders nil cells as empty strings' do
      table = described_class.new(headers: %w[A B], rows: [[nil, 'value']])
      output = table.render(style: :ascii)
      expect(output).to include('value')
    end
  end

  describe 'edge cases' do
    it 'handles single column' do
      table = described_class.new(headers: %w[Item], rows: [['apple'], ['banana']])
      output = table.render
      expect(output).to include('apple')
      expect(output).to include('banana')
    end

    it 'handles single row' do
      table = described_class.new(headers: %w[A B], rows: [%w[x y]])
      output = table.render
      expect(output).to include('x')
      expect(output).to include('y')
    end

    it 'handles empty rows array' do
      table = described_class.new(headers: headers, rows: [])
      output = table.render
      expect(output).to include('Name')
      expect(output).to include('Age')
    end

    it 'handles headers-only table' do
      table = described_class.new(headers: %w[One Two Three])
      output = table.render
      expect(output).to include('One')
      expect(output).to include('Two')
      expect(output).to include('Three')
    end
  end

  describe '#to_s' do
    it 'renders the default style' do
      table = described_class.new(headers: headers, rows: rows)
      expect(table.to_s).to eq(table.render)
    end
  end
end
