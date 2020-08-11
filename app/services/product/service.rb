class Product::Service
  def self.call(sheet)
    @table = Sheet::Service.call(sheet)
    Product::Repository.call(@table)
  end
end
