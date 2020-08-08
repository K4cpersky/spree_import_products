class Sheet::Service
  def self.call(sheet)
    Sheet::Validator.new.call(file: sheet)
    Sheet::Process.call(sheet)
  end
end
