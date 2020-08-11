class Sheet::Service
  def self.call(sheet)
    Sheet::Validator.new.call(file: sheet)
    @sheet = Sheet::Processor.new(sheet)
    @sheet.call
    @sheet.products
  end
end
