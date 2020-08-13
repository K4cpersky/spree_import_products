class Product
  def import(sheet)
    parse_result = sheet_service.parse_rows(sheet)
    return Product::ImportResult.new(sheet_errors: parse_result.errors) unless parse_result.success?

    Product::Importer.import(parse_result.rows)
    Product::ImportResult.new(import_errors: parse_result.errors)
  end

  private

  def sheet_service
    @sheet_service ||= Sheet.new
  end
end
