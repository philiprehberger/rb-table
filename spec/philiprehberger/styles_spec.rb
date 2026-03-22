# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Philiprehberger::Table::Styles do
  describe '.fetch' do
    it 'returns unicode style' do
      style = described_class.fetch(:unicode)
      expect(style[:horizontal]).to eq("\u2500")
      expect(style[:vertical]).to eq("\u2502")
    end

    it 'returns ascii style' do
      style = described_class.fetch(:ascii)
      expect(style[:horizontal]).to eq('-')
      expect(style[:vertical]).to eq('|')
    end

    it 'returns markdown style' do
      style = described_class.fetch(:markdown)
      expect(style[:horizontal]).to eq('-')
      expect(style[:vertical]).to eq('|')
    end

    it 'returns compact style' do
      style = described_class.fetch(:compact)
      expect(style).to be_a(Hash)
    end

    it 'raises on unknown style' do
      expect { described_class.fetch(:fancy) }.to raise_error(KeyError)
    end
  end
end
