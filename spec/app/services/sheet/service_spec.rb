require 'spec_helper'

RSpec.describe Sheet::Service do
  describe '.call' do
    subject(:call) { described_class.call(sheet) }

    let(:file) { fixture_file_upload('spec/factories/files/sample.csv', 'text/csv') }
    let(:sheet) do
      { file: file }
    end

    it 'creates instance ' do
      expect(Sheet::Validator)
        .to receive_message_chain(:new, :call)
        .with(sheet: sheet)

      call
    end

    it 'calls sheet processor' do
      expect(Sheet::Process)
        .to receive(:call)
        .with(sheet)
        .and_call_original

      call
    end
  end
end
