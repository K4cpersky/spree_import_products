class Sheet
  def parse_rows(sheet)
    errors = Sheet::Validator.new.call(parse_params_to_validator(sheet)).errors.to_a

    return Sheet::ParseResult.new(errors: errors) if errors.any?

    products = Sheet::Processor.new(sheet).call

    Sheet::ParseResult.new(rows: products)
  end

  private

  def parse_params_to_validator(sheet)
    sheet.to_hash.symbolize_keys.delete_if { |_k, v| v.blank? }
  end
end
