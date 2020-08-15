require 'spec_helper'

RSpec.describe Product::Importer do
  describe '#import' do
    subject(:product_importer) { described_class.new.import(parse_result) }
  end
end
