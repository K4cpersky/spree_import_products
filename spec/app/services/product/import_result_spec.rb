require 'spec_helper'

RSpec.describe Product::ImportResult do
  describe '#success?' do
    subject(:success?) { described_class.new(sheet_errors: sheet_errors, import_errors: import_errors).success? }

    context 'when there are no errors' do
      let(:sheet_errors) { [] }
      let(:import_errors) { [] }

      it { is_expected.to eq true }
    end

    context 'when there are errors' do
      context 'when sheet_erros are present' do
        let(:sheet_errors) { ["File is empty"] }
        let(:import_errors) { [] }

        it { is_expected.to eq false }
      end

      context 'when import errors are present' do
        let(:sheet_errors) { [] }
        let(:import_errors) { ["Row 4 is invalid"] }

        it { is_expected.to eq false }
      end

      context 'when both sheet and import errors are present' do
        let(:sheet_errors) { ["File is empty"] }
        let(:import_errors) { ["Row 4 is invalid"] }

        it { is_expected.to eq false }
      end
    end
  end
end
