class Product::ImportResult
  attr_reader :import_errors, :saved_records, :sheet_errors

  def initialize(sheet_errors: [], import_errors: [], saved_records: [])
    @sheet_errors = sheet_errors
    @import_errors = import_errors
    @saved_records = saved_records
  end

  def success?
    @sheet_errors.empty?
  end
end
