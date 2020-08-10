# frozen_string_literal: true

require 'dry-validation'
require 'dry-schema'
require 'csv'

class Sheet::Validator < Dry::Validation::Contract
  # TODO: Sprawdzic czy input jest plikiem
  # TODO: - niech csv bedzie tworzony przy uzyciu factories
  params do
    required(:file)
  end

  rule(:file) do
    key.failure('wrong file content type') unless csv_content_type?(value)
  end

  rule(:file) do
    key.failure('file is empty') unless file_has_data?(value)
  end
  # TODO: Nie do konca podoba mi sie ten blok if unless, ale w tym przypadku pasuje chyba
  rule(:file) do
    if file_has_data?(value)
      key.failure('some columns are missing') unless required_columns_given?(value)
    end
  end

  rule(:file) do
    if file_has_data?(value)
      key.failure('file has empty rows') unless any_row_given?(value)
    end
  end

  private

  def csv_content_type?(value)
    value[:file].content_type == 'text/csv'
  end

  def file_has_data?(value)
    CSV.parse(File.read(value[:file])).any?
  end

  def required_columns_given?(value)
    required_columns = ['name', 'description', 'price', 'availability_date', 'slug', 'stock_total', 'category']
    given_columns = CSV.parse(File.read(value[:file]), col_sep: ';', headers: true).headers
    (required_columns - given_columns).empty?
  end

  def any_row_given?(value)
    CSV.parse(File.read(value[:file]), col_sep: ';').drop(1).flatten.compact.any?
  end
end
