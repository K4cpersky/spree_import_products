require 'spec_helper'
#TODO: Ogarnij stabowanie i mockowanie
RSpec.describe Sheet::Service do
  describe '.call' do
    subject(:call) { described_class.call(sheet) }

    let(:file) { fixture_file_upload('spec/factories/files/sample.csv', 'text/csv') }
    let(:sheet) do
      { file: file }
    end

    it 'calls validator' do
      expect(Sheet::Validator)
        .to receive_message_chain(:new, :call)
        .with(file: sheet)

      call
    end
  end
end
