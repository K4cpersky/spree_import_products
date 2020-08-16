require 'spec_helper'

RSpec.describe SheetService do
  describe '.parse_rows' do
    subject(:parse_rows) { described_class.new.parse_rows(sheet) }

    let(:file) { fixture_file_upload('spec/factories/files/sample.csv', 'text/csv') }
    let(:sheet) do
      { file: file }
    end
  end
end
