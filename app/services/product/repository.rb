class Product::Repository
  def self.create(attributes)
    # TODO: do something with category and stock location
    # TODO: fix this first_or_initialize logic is wrong
    product = Spree::Product.where(attributes.except(:price, :stock_total)).first_or_initialize
    product.price = attributes[:price]
    product.save!
    product.stock_items.find_by(stock_location: default_stock_location).set_count_on_hand attributes[:stock_total] if attributes[:stock_total]
  end

  def self.default_stock_location
    Spree::StockLocation.find_or_create_by(name: 'Default')
  end
end
