class ProductService
  def import(sheet)
    parse_result = sheet_service.parse_rows(sheet)

    return Product::ImportResult.new(sheet_errors: parse_result.errors) unless parse_result.success?

    product_importer.import(parse_result.rows)

    Product::ImportResult.new(saved_records: product_importer.saved_records, import_errors: product_importer.invalid_records)
  end

  private

  def sheet_service
    @sheet_service ||= SheetService.new
  end

  def product_importer
    @product_importer ||= Product::Importer.new
  end
end
