class Sheet
  def parse_rows(sheet)
    errors = Sheet::Validator.new.call(file: sheet).errors.to_a

    return Sheet::ParseResult.new(errors: errors) if errors.any?

    products = Sheet::Processor.new(sheet).call

    Sheet::ParseResult.new(rows: products)
  end
end
