require 'csv'

class Sheet::Processor
  attr_reader :products

  def initialize(sheet)
    @sheet = sheet[:file]
    @products = []
  end

  # TODO: Convert headers to symbols
  # TODO: Should it be here?
  CSV::Converters[:price] = lambda { |value, field_info|
    case field_info.header
    when :price
      value.gsub!(',', '.').to_f
    else
      value
    end
  }
  CSV::Converters[:symbol] = lambda { |value|
    begin
                     value.to_sym
    rescue StandardError
      value
                   end
  }

  def call
    CSV.foreach(@sheet, col_sep: ';', headers: true, header_converters: :symbol, converters: [:date_time, :integer, :price]) do |row|
      row.fields.compact.empty? ? next : push_row(row)
    end
  end

  private

  def push_row(row)
    compact_row(row)

    @products << row.to_hash
  end

  def compact_row(row)
    row.delete_if { |_k, v| v.nil? }
  end
end
