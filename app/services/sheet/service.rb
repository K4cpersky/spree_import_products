class Sheet::Service
  def self.call(sheet)
    Sheet::Validator.new.call(file: sheet)
    Sheet::Processor.new(sheet).call
  end
end
