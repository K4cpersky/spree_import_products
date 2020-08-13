class Product::ImportResult
  def initialize(sheet_errors: [], import_errors: [])
    @sheet_errors = sheet_errors
    @import_errors = import_errors
  end

  def success?
    (@sheet_errors + @empty_erros).empty?
  end
end
