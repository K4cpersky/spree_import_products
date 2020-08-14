require 'spec_helper'

RSpec.describe Sheet::ParseResult do
  describe 'success?' do
    subject(:success?) { described_class.new(rows: rows, errors: errors).success? }

    let(:rows) { double(:rows) }

    context 'when there are no errors' do
      let(:errors) { [] }

      it { is_expected.to eq true }
    end

    context 'when there are errors' do
      let(:errors) { [name: 'cannot be blank'] }

      it { is_expected.to eq false }
    end
  end
end
