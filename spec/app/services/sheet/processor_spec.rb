require 'spec_helper'

RSpec.describe Sheet::Processor do
  describe '.call' do
    subject(:call) { described_class.new(data) }

    WHITELISTED_COLUMNS = [:name, :description, :price, :available_on, :slug, :stock_total, :category].freeze

    let(:file) { fixture_file_upload('spec/factories/files/sample.csv', 'text/csv') }
    let(:data) do
      { file: file }
    end
    let(:table) { CSV.parse(File.read(data[:file]), col_sep: ';', headers: true) }

    let(:string_headers) { table.headers.compact.all? { |element| element.class == String } }
    let(:headers_parsed_to_symbols) { subject.products.map { |product| product.keys.all? { |key| key.class == Symbol } }.uniq.first }
    let(:parsed_headers) { subject.products.map(&:keys).flatten.uniq }

    let(:availability_date_presence) { subject.products.map(&:keys).map{ |keys| keys.include?(:availability_date)}.uniq.first }
    let(:available_on_presence) { subject.products.map(&:keys).map{ |keys| keys.include?(:available_on)}.uniq.first }
    #TODO: Czy moze tak byc ze atrybut zmienia nazwe, testy nie sa odizolowane
    let(:availability_date_column_type) { table.by_col["availability_date"].compact.all? { |element| element.class == String } }
    let(:parsed_availability_date_column_type) { subject.products.map { |p| p[:available_on].class == DateTime }.uniq.first }

    let(:stock_total_column) { table.by_col["stock_total"].compact.all? { |element| element.class == String } }
    let(:parsed_stock_total_column) { subject.products.map { |p| p[:stock_total].class == Integer }.uniq.first }

    let(:price_column) { table.by_col["price"].compact.all? { |element| element.class == String } }
    let(:parsed_price_column) { subject.products.map { |p| p[:price].class == Float }.uniq.first }

    let(:table_length) { 21 }
    let(:products_amount) { 3 }
    let(:parsed_row_length) { 7 }
    let(:parsed_products_amount) { subject.products.length }

    it 'converts headers to symbols' do
      expect(string_headers).to be true
      expect(subject.products).to be_empty

      subject.call

      expect(headers_parsed_to_symbols).to be true
    end

    it 'renames available_on column' do
      expect(table.headers).to include "availability_date"
      expect(table.headers).not_to include "available_on"

      subject.call

      expect(availability_date_presence).to be false
      expect(available_on_presence).to be true
    end

    it 'converts available_on column to datetime' do
      expect(availability_date_column_type).to be true
      expect(subject.products).to be_empty

      subject.call

      expect(parsed_availability_date_column_type).to be true
    end

    it 'converts stock_total to integer' do
      expect(stock_total_column).to be true
      expect(subject.products).to be_empty

      subject.call

      expect(parsed_stock_total_column).to be true
    end

    it 'converts price to float number' do
      expect(price_column).to be true
      expect(subject.products).to be_empty

      subject.call

      expect(parsed_price_column).to be true
    end

    it 'removes blank rows' do
      expect(table.length).to eq table_length

      subject.call

      expect(parsed_products_amount).to eq products_amount
    end

    it 'does not reject blank values from rows' do
      subject.call

      expect(subject.products.second.length).to eq parsed_row_length
    end

    it 'takes only whitelisted columns' do
      subject.call

      expect(parsed_headers.length).to eq WHITELISTED_COLUMNS.length
      expect(parsed_headers - WHITELISTED_COLUMNS).to be_empty
    end

    it 'returns same amount of objects' do
      subject.call

      expect(products_amount).to eq parsed_products_amount
    end
  end
end
