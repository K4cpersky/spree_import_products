require 'spec_helper'

RSpec.describe Product::ImportResult do
  describe '#success?' do
    subject(:success?) { described_class.new(sheet_errors: sheet_errors).success? }

    context 'when there is no sheet errors' do
      let(:sheet_errors) { [] }

      it { is_expected.to eq true }
    end

    context 'when there are sheet errors' do
      let(:sheet_errors) { ["File is empty"] }

      it { is_expected.to eq false }
    end
  end
end
