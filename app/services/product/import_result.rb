class Product::ImportResult
  attr_reader :import_errors

  def initialize(sheet_errors: [], import_errors: [])
    @sheet_errors = sheet_errors
    @import_errors = import_errors
  end

  def success?
    @sheet_errors.empty?
  end

  def sheet_errors
    @sheet_errors.map(&:to_h)
  end
end
