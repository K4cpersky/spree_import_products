require 'spec_helper'

RSpec.describe Sheet::Validator do
  subject(:call) { described_class.new.call(data) }

  context 'when data is valid' do
    let(:file) { fixture_file_upload('spec/factories/files/sample.csv', 'text/csv') }
    let(:data) do
      { file: file }
    end

    it 'returns no errors' do
      expect(subject.success?).to be true
      expect(subject.errors).to be_empty
    end
  end

  context 'when data is invalid' do
    context 'when file is missing' do
      let(:data) do
        { }
      end

      it 'returns file is missing error' do
        expect(subject.success?).to be false
        expect(subject.errors[:file][0]).to eq 'is missing'
      end
    end

    context 'when data has wrong content type' do
      let(:file) { fixture_file_upload('spec/factories/files/sheet_errors/sample.txt', 'text/plain') }
      let(:data) do
        { file: file }
      end

      it 'returns file has wrong content type error' do
        expect(subject.success?).to be false
        expect(subject.errors[:file][0]).to eq 'wrong file content type'
      end
    end

    context 'when file is empty' do
      let(:file) { fixture_file_upload('spec/factories/files/sheet_errors/empty_file_sample.csv', 'text/csv') }
      let(:data) do
        { file: file }
      end

      it 'returns file is empty error' do
        expect(subject.success?).to be false
        expect(subject.errors[:file][0]).to eq 'file is empty'
      end
    end

    context 'when some columns are missing' do
      let(:file) { fixture_file_upload('spec/factories/files/sheet_errors/column_missing_sample.csv', 'text/csv') }
      let(:data) do
        { file: file }
      end

      it 'returns some columns are missing error' do
        expect(subject.success?).to be false
        expect(subject.errors[:file][0]).to eq 'some columns are missing'
      end
    end

    context 'when rows are blank' do
      let(:file) { fixture_file_upload('spec/factories/files/sheet_errors/blank_rows_sample.csv', 'text/csv') }
      let(:data) do
        { file: file }
      end

      it 'returns lack of rows error' do
        expect(subject.success?).to be false
        expect(subject.errors[:file][0]).to eq 'lack of rows'
      end
    end
  end
end
