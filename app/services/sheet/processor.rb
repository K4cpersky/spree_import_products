require 'csv'

class Sheet::Processor
  COLUMNS_WHITELIST = [:name, :description, :price, :available_on, :slug, :stock_total, :category].freeze

  attr_reader :products

  def initialize(sheet)
    @sheet = sheet[:file]
    @products = []
  end
  # TODO: Should it be here?
  # Radek folder tools, w lamdzie do endy
  CSV::Converters[:price] = lambda do |value, field_info|
    case field_info.header
    when :price
      value.blank? ? value : value.gsub!(',', '.').to_f
    else
      value
    end
  end
  CSV::HeaderConverters[:map_headers] = lambda do |header|
    header == 'availability_date' ? 'available_on' : header
  end
  CSV::Converters[:symbol] = lambda do |value|
    value.to_sym
  rescue StandardError
    value
  end

  def call
    CSV.foreach(@sheet, col_sep: ';', headers: true, header_converters: [:map_headers, :symbol], converters: [:date_time, :integer, :price]) do |row|
      push_row(row) unless row.fields.all?(&:blank?)
    end

    @products
  end

  private

  def push_row(row)
    @products << row.to_hash.slice(*COLUMNS_WHITELIST)
  end
end
