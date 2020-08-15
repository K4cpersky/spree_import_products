class Product::ImportResult
  attr_reader :sheet_errors, :import_errors

  def initialize(sheet_errors: [], import_errors: [])
    @sheet_errors = sheet_errors
    @import_errors = import_errors
  end

  def success?
    (@sheet_errors + @import_errors).empty?
  end
end
