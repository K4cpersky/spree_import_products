require 'spec_helper'

RSpec.describe Product::Service do
  describe '.call' do
    subject(:call) { described_class.call(sheet) }

    let(:file) { fixture_file_upload('spec/factories/files/sample.csv', 'text/csv') }
    let(:sheet) do
      { file: file }
    end
    let(:table) { Sheet::Service.call(sheet) }

    it 'calls sheet service' do
      expect(Sheet::Service)
        .to receive(:call)
        .with(sheet)
        .and_call_original

      call
    end

    it 'product repository' do
      expect(Product::Repository)
        .to receive(:call)
        .with(table)
        .and_call_original

      call
    end
  end
end
