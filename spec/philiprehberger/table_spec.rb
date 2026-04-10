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

  describe 'wide tables' do
    it 'handles many columns' do
      hdrs = (1..10).map { |i| "Col#{i}" }
      data = [(1..10).map(&:to_s)]
      table = described_class.new(headers: hdrs, rows: data)
      output = table.render
      expect(output).to include('Col1')
      expect(output).to include('Col10')
    end

    it 'handles very wide cell content' do
      table = described_class.new(headers: %w[Data], rows: [['x' * 200]])
      output = table.render
      expect(output).to include('x' * 200)
    end
  end

  describe 'many rows' do
    it 'renders 100 rows' do
      data = (1..100).map { |i| [i.to_s, "row#{i}"] }
      table = described_class.new(headers: %w[ID Name], rows: data)
      output = table.render
      lines = output.split("\n")
      data_lines = lines.select { |l| l.include?('row') }
      expect(data_lines.length).to eq(100)
    end
  end

  describe 'numeric alignment with right-align' do
    it 'right-aligns numbers in a column' do
      table = described_class.new(
        headers: %w[Item Price],
        rows: [%w[Apple 1], %w[Banana 200]],
        align: { 1 => :right }
      )
      output = table.render(style: :ascii)
      lines = output.split("\n")
      price_lines = lines.select { |l| l.include?('1') || l.include?('200') }
      expect(price_lines.length).to be >= 2
    end
  end

  describe 'mixed content types' do
    it 'converts integers and symbols to strings' do
      table = described_class.new(headers: %w[A B], rows: [[123, :hello]])
      output = table.render
      expect(output).to include('123')
      expect(output).to include('hello')
    end
  end

  describe 'nil values in cells' do
    it 'handles nil in multiple cells' do
      table = described_class.new(headers: %w[A B C], rows: [[nil, nil, nil]])
      output = table.render(style: :ascii)
      expect(output).to include('|')
    end

    it 'handles nil headers' do
      table = described_class.new(headers: [nil, 'B'], rows: [%w[a b]])
      output = table.render(style: :ascii)
      expect(output).to include('B')
      expect(output).to include('a')
    end
  end

  describe 'markdown output validation' do
    it 'produces valid pipe-separated markdown' do
      table = described_class.new(headers: %w[Name Age], rows: [%w[Alice 30]])
      output = table.render(style: :markdown)
      lines = output.split("\n")
      expect(lines.length).to eq(3)
      lines.each do |line|
        expect(line).to start_with('|')
        expect(line).to end_with('|')
      end
    end

    it 'separator row contains only dashes and pipes' do
      table = described_class.new(headers: %w[A B], rows: [%w[x y]])
      output = table.render(style: :markdown)
      separator = output.split("\n")[1]
      expect(separator).to match(/\A[|\-\s]+\z/)
    end
  end

  describe 'ANSI color width calculation' do
    it 'aligns colored and plain cells to the same column width' do
      colored = "\e[32mGreen\e[0m"
      table = described_class.new(headers: %w[Status], rows: [[colored], ['Plain']])
      output = table.render(style: :ascii)
      expect(output).to include('Green')
      expect(output).to include('Plain')
    end
  end

  describe 'single column table' do
    it 'renders borders correctly for one column' do
      table = described_class.new(headers: %w[Only], rows: [['val']])
      output = table.render(style: :ascii)
      expect(output).to include('Only')
      expect(output).to include('val')
      expect(output.split("\n").first.count('+')).to eq(2)
    end
  end

  describe 'unknown style' do
    it 'raises KeyError' do
      table = described_class.new(headers: %w[A], rows: [['x']])
      expect { table.render(style: :nonexistent) }.to raise_error(KeyError)
    end
  end

  describe 'max_width truncation' do
    it 'truncates long content' do
      table = described_class.new(
        headers: %w[Name Description],
        rows: [['Alice', 'A very long description that should be truncated']],
        max_width: { 1 => 20 }
      )
      output = table.render
      expect(output).to include('A very long descr...')
    end

    it 'does not truncate short content' do
      table = described_class.new(
        headers: ['Name'],
        rows: [['Alice']],
        max_width: { 0 => 20 }
      )
      output = table.render
      expect(output).to include('Alice')
    end

    it 'supports header name keys' do
      table = described_class.new(
        headers: %w[Name Bio],
        rows: [['Alice', 'This is a long biography text']],
        max_width: { 'Bio' => 15 }
      )
      output = table.render
      expect(output).to include('This is a lo...')
    end

    it 'works with multiple styles' do
      table = described_class.new(
        headers: ['Col'],
        rows: [['A very long cell value here']],
        max_width: { 0 => 10 }
      )
      %i[unicode ascii markdown compact].each do |style|
        output = table.render(style: style)
        expect(output).to include('A very ...')
      end
    end
  end

  describe '.from_hashes' do
    it 'builds a table from an array of hashes' do
      data = [
        { name: 'Alice', age: 30 },
        { name: 'Bob', age: 25 }
      ]
      table = described_class.from_hashes(data)
      output = table.render(style: :compact)
      expect(output).to include('Alice')
      expect(output).to include('Bob')
      expect(output).to include('name')
      expect(output).to include('age')
    end

    it 'handles empty data' do
      table = described_class.from_hashes([])
      expect(table.render(style: :compact)).to be_a(String)
    end

    it 'unions keys from all hashes' do
      data = [
        { a: 1 },
        { a: 2, b: 3 }
      ]
      table = described_class.from_hashes(data)
      output = table.render(style: :compact)
      expect(output).to include('a')
      expect(output).to include('b')
    end

    it 'handles missing keys with empty cells' do
      data = [
        { a: 1 },
        { b: 2 }
      ]
      table = described_class.from_hashes(data)
      output = table.render(style: :ascii)
      expect(output).to include('a')
      expect(output).to include('b')
    end

    it 'passes align and max_width options through' do
      data = [{ col: 'value' }]
      table = described_class.from_hashes(data, align: { 0 => :right })
      output = table.render(style: :compact)
      expect(output).to include('value')
    end
  end

  describe '#add_row' do
    it 'appends a row after construction' do
      table = described_class.new(headers: %w[Name Age])
      table.add_row(%w[Alice 30])
      table.add_row(%w[Bob 25])
      output = table.render(style: :compact)
      expect(output).to include('Alice')
      expect(output).to include('Bob')
    end

    it 'returns self for chaining' do
      table = described_class.new(headers: %w[X])
      result = table.add_row(['1'])
      expect(result).to be(table)
    end

    it 'handles nil cells' do
      table = described_class.new(headers: %w[A B])
      table.add_row([nil, 'val'])
      output = table.render(style: :compact)
      expect(output).to include('val')
    end
  end
end
