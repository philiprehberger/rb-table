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
      expect(style[:top_left]).to be_nil
    end

    it 'returns compact style' do
      style = described_class.fetch(:compact)
      expect(style[:horizontal]).to be_nil
      expect(style[:vertical]).to be_nil
    end

    it 'raises on unknown style' do
      expect { described_class.fetch(:fancy) }.to raise_error(KeyError)
    end
  end

  describe 'style definitions' do
    it 'has all required keys in unicode' do
      expected_keys = %i[top_left top_right bottom_left bottom_right horizontal vertical
                         top_mid bottom_mid mid_left mid_right mid_mid]
      expect(described_class::UNICODE.keys).to contain_exactly(*expected_keys)
    end

    it 'has all required keys in ascii' do
      expected_keys = %i[top_left top_right bottom_left bottom_right horizontal vertical
                         top_mid bottom_mid mid_left mid_right mid_mid]
      expect(described_class::ASCII.keys).to contain_exactly(*expected_keys)
    end

    it 'freezes all styles' do
      expect(described_class::UNICODE).to be_frozen
      expect(described_class::ASCII).to be_frozen
      expect(described_class::MARKDOWN).to be_frozen
      expect(described_class::COMPACT).to be_frozen
    end
  end
end
