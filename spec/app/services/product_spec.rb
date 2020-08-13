require 'spec_helper'

RSpec.describe Product do
  describe '.import' do
    subject(:import) { described_class.new.import(sheet) }

    let(:file) { fixture_file_upload('spec/factories/files/sample.csv', 'text/csv') }
    let(:sheet) do
      { file: file }
    end
    # let(:table) { Sheet.call(sheet) }

    # TODO
    # it 'calls sheet service' do
    #   expect(Sheet.new)
    #     .to receive(:parse_rows)
    #     .with(sheet)
    #     .and_call_original
    #
    #   import
    # end

    # TODO
    # it 'product repository' do
    #   expect(Product::Repository)
    #     .to receive(:call)
    #     .with(table)
    #     .and_call_original
    #
    #   import
    # end
  end
end
