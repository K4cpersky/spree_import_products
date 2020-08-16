require 'dry-validation'
require 'dry-schema'
require 'csv'

class Sheet::Validator < Dry::Validation::Contract
  REQUIRED_COLUMNS = ['name', 'description', 'price', 'availability_date', 'slug', 'stock_total', 'category'].freeze

  private_constant :REQUIRED_COLUMNS

  params do
    required(:file)
  end

  rule(:file) do
    key.failure('wrong file content type') unless csv_content_type?(value)
  end

  rule(:file) do
    key.failure('file is empty') unless file_has_data?(value)
  end

  rule(:file) do
    if file_has_data?(value)
      key.failure('some columns are missing') unless required_columns_given?(value)
    end
  end

  rule(:file) do
    if file_has_data?(value)
      key.failure('lack of rows') unless any_row_given?(value)
    end
  end

  private

  def csv_content_type?(value)
    value.content_type == 'text/csv'
  end

  def file_has_data?(value)
    CSV.parse(File.read(value.path), col_sep: ';', headers: true).any?
  end

  def required_columns_given?(value)
    given_columns = CSV.parse(File.read(value.path), col_sep: ';', headers: true).headers
    (REQUIRED_COLUMNS - given_columns).empty?
  end

  def any_row_given?(value)
    CSV.parse(File.read(value.path), col_sep: ';').drop(1).flatten.reject(&:blank?).any?
  end
end
