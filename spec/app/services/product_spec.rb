require 'spec_helper'

RSpec.describe Product do
  describe '.import' do
    subject(:import) { described_class.new.import(sheet) }

    let(:file) { fixture_file_upload('spec/factories/files/sample.csv', 'text/csv') }
    let(:sheet) do
      { file: file }
    end
  end
end
