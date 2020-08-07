class Sheet::Service
  def self.call(sheet)
    Sheet::Validator.new.call(sheet: sheet)
    Sheet::Process.call(sheet)
  end
end
