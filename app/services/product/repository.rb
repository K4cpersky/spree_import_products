class Product::Repository
  def self.create(attributes)
    Spree::Product.find_or_initialize_by(attributes.except(:price, :stock_total, :stock_location, :taxons)) do |product|
      product.price = attributes[:price]
      # binding.pry
      product.assign_attributes(taxons: attributes[:taxons]) if attributes[:taxons]
      product.save!
      product.stock_items.find_by(stock_location: attributes[:stock_location]).set_count_on_hand attributes[:stock_total] if attributes[:stock_total] && attributes[:stock_location]
    end
  end
end
