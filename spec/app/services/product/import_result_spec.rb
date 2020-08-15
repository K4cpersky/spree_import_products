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

        it { is_expected.to eq true }
      end

      context 'when both sheet and import errors are present' do
        let(:sheet_errors) { ["File is empty"] }
        let(:import_errors) { ["Row 4 is invalid"] }

        it { is_expected.to eq false }
      end
    end
  end

  describe '#sheet_errors' do
    subject(:sheet_errors) { described_class.new(sheet_errors: sheet_errors, import_errors: import_errors).sheet_errors }

    let(:import_errors) { double(:import_errors) }

    context 'when there are no sheet errors' do
      let(:sheet_errors) { [] }

      it { is_expected.to eq [] }
    end

    context 'when there is sheet error' do
      let(:sheet_result) { Sheet::Validator.new.call(nil) }
      let(:sheet_errors) { sheet_result.errors }

      it { is_expected.to eq [{:file=>["is missing"]}] }
    end
  end
end
