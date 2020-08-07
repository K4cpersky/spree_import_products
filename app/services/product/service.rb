class Product::Service
  def self.call(sheet)
    Sheet::Service.call(sheet)
    # implement solution to crate products here
  end
end
