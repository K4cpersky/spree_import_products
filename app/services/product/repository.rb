class Product::Repository
  def self.call(table)
    # TODO: do something with category and stock location
    # Spree::StockLocation.find_or_create_by(name: 'Central Port in Washington')
    Spree::Product.transaction do
      table.each do |element|
        attributes = element.slice(:name, :description, :available_on, :slug).merge(shipping_category: shipping_category(element))
        product = Spree::Product.where(attributes).first_or_initialize
        product.price = element[:price]
        product.save!
        product.stock_items.first.set_count_on_hand element[:stock_total] if element[:stock_total]
      end
    end
  end

  def self.shipping_category(element)
    Spree::ShippingCategory.find_or_create_by(name: element[:category])
  end
end
