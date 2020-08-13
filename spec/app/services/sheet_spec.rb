require 'spec_helper'
#TODO: Ogarnij stabowanie i mockowanie
RSpec.describe Sheet do
  describe '.parse_rows' do
    subject(:parse_rows) { described_class.new.parse_rows(sheet) }

    let(:file) { fixture_file_upload('spec/factories/files/sample.csv', 'text/csv') }
    let(:sheet) do
      { file: file }
    end

    # TODO
    # it 'calls validator' do
    #   expect(Sheet::Validator.new)
    #     .to receive(:call)
    #     .with(file: sheet)
    #
    #   parse_rows
    # end
  end
end
