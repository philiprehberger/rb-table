# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Philiprehberger::Table do
  let(:headers) { %w[Name Age City] }
  let(:rows) { [%w[Alice 30 NYC], %w[Bob 25 LA]] }

  it 'has a version number' do
    expect(Philiprehberger::Table::VERSION).not_to be_nil
  end

  describe '.new' do
    it 'creates a table grid' do
      table = described_class.new(headers: headers, rows: rows)
      expect(table).to be_a(Philiprehberger::Table::Grid)
    end

    it 'raises on non-array headers' do
      expect { described_class.new(headers: 'not array') }.to raise_error(Philiprehberger::Table::Error)
    end

    it 'accepts empty rows' do
      table = described_class.new(headers: headers)
      expect(table.render).to include('Name')
    end
  end

  describe '#render with :unicode style' do
    it 'renders with unicode borders' do
      table = described_class.new(headers: headers, rows: rows)
      output = table.render(style: :unicode)
      expect(output).to include("\u2502")
      expect(output).to include("\u2500")
      expect(output).to include('Alice')
      expect(output).to include('Bob')
    end

    it 'renders as default style' do
      table = described_class.new(headers: headers, rows: rows)
      output = table.render
      expect(output).to include("\u2502")
    end

    it 'auto-sizes columns to fit content' do
      table = described_class.new(headers: %w[Short LongHeaderName], rows: [%w[a b]])
      output = table.render
      expect(output).to include('LongHeaderName')
    end
  end

  describe '#render with :ascii style' do
    it 'renders with ASCII borders' do
      table = described_class.new(headers: headers, rows: rows)
      output = table.render(style: :ascii)
      expect(output).to include('+')
      expect(output).to include('-')
      expect(output).to include('|')
      expect(output).to include('Alice')
    end
  end

  describe '#render with :markdown style' do
    it 'renders valid markdown table' do
      table = described_class.new(headers: headers, rows: rows)
      output = table.render(style: :markdown)
      lines = output.split("\n")

      expect(lines[0]).to include('| Name')
      expect(lines[1]).to match(/\|[-\s]+\|/)
      expect(lines[2]).to include('Alice')
    end

    it 'does not include top or bottom borders' do
      table = described_class.new(headers: headers, rows: rows)
      output = table.render(style: :markdown)
      expect(output).not_to include('+')
    end
  end

  describe '#render with :compact style' do
    it 'renders without borders' do
      table = described_class.new(headers: headers, rows: rows)
      output = table.render(style: :compact)
      expect(output).not_to include('|')
      expect(output).not_to include('+')
      expect(output).to include('Name')
      expect(output).to include('Alice')
    end

    it 'aligns columns with spaces' do
      table = described_class.new(headers: %w[Name Age], rows: [%w[Alice 30]])
      output = table.render(style: :compact)
      lines = output.split("\n")
      expect(lines.length).to eq(2)
    end
  end

  describe 'column alignment' do
    it 'aligns columns to the right' do
      table = described_class.new(headers: %w[Name Amount], rows: [%w[Alice 100]], align: { 1 => :right })
      output = table.render(style: :ascii)
      lines = output.split("\n")
      data_line = lines.find { |l| l.include?('100') }
      expect(data_line).to include(' 100')
    end

    it 'aligns columns to the center' do
      table = described_class.new(headers: %w[Name Status], rows: [['Alice', 'OK']], align: { 1 => :center })
      output = table.render(style: :ascii)
      expect(output).to include('OK')
    end

    it 'defaults to left alignment' do
      table = described_class.new(headers: %w[Name], rows: [['Hi']])
      output = table.render(style: :ascii)
      expect(output).to include('Hi')
    end
  end

  describe 'ANSI color support' do
    it 'calculates width correctly with ANSI codes' do
      colored = "\e[31mRed\e[0m"
      table = described_class.new(headers: %w[Color], rows: [[colored]])
      output = table.render(style: :ascii)
      expect(output).to include("\e[31mRed\e[0m")
    end
  end

  describe 'edge cases' do
    it 'handles empty rows' do
      table = described_class.new(headers: headers, rows: [])
      output = table.render
      expect(output).to include('Name')
    end

    it 'handles single column' do
      table = described_class.new(headers: %w[Item], rows: [['apple'], ['banana']])
      output = table.render
      expect(output).to include('apple')
      expect(output).to include('banana')
    end

    it 'handles long cell values' do
      table = described_class.new(headers: %w[Key Value], rows: [['name', 'a' * 50]])
      output = table.render
      expect(output).to include('a' * 50)
    end

    it 'converts non-string values to strings' do
      table = described_class.new(headers: %w[Num], rows: [[42]])
      output = table.render
      expect(output).to include('42')
    end
  end

  describe '#to_s' do
    it 'renders the default style' do
      table = described_class.new(headers: headers, rows: rows)
      expect(table.to_s).to eq(table.render)
    end
  end
end
