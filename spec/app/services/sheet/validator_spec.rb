# frozen_string_literal: true
# TODO: to keep frozen_string_literal or not to keep?

require 'spec_helper'

RSpec.describe Sheet::Validator do
  subject(:call) { described_class.new.call(data) }

  let(:sheet) do
    { file: file }
  end

  context 'when data is valid' do
    let(:file) { fixture_file_upload('spec/factories/files/sample.csv', 'text/csv') }
    let(:data) do
      { file: sheet }
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
      let(:file) { fixture_file_upload('spec/factories/files/sample.txt', 'text/plain') }
      let(:data) do
        { file: sheet }
      end

      it 'returns file has wrong content type error' do
        expect(subject.success?).to be false
        expect(subject.errors[:file][0]).to eq 'wrong file content type'
      end
    end

    context 'when file is empty' do
      let(:file) { fixture_file_upload('spec/factories/files/empty_file_sample.csv', 'text/csv') }
      let(:data) do
        { file: sheet }
      end

      it 'returns file is empty error' do
        expect(subject.success?).to be false
        expect(subject.errors[:file][0]).to eq 'file is empty'
      end
    end

    context 'when some columns are missing' do
      let(:file) { fixture_file_upload('spec/factories/files/column_missing_sample.csv', 'text/csv') }
      let(:data) do
        { file: sheet }
      end

      it 'returns some columns are missing error' do
        expect(subject.success?).to be false
        expect(subject.errors[:file][0]).to eq 'some columns are missing'
      end
    end

    context 'when rows are empty' do
      let(:file) { fixture_file_upload('spec/factories/files/empty_rows_sample.csv', 'text/csv') }
      let(:data) do
        { file: sheet }
      end

      it 'returns empty rows error' do
        expect(subject.success?).to be false
        expect(subject.errors[:file][0]).to eq 'file has empty rows'
      end
    end
  end
end
