class Product::Repository
  attr_reader :errors, :product_id

  def initialize
    @errors = []
  end

  def create(attributes)
    Spree::Product.where(slug: attributes[:slug]).first_or_initialize(attributes.except(:price, :stock_total, :stock_location, :taxons)) do |product|
      product.price = attributes[:price]
      product.assign_attributes(taxons: attributes[:taxons]) if attributes[:taxons].any?

      if product.valid?
        product.save

        if attributes[:stock_total] && attributes[:stock_location]
          product.stock_items.find_by(stock_location: attributes[:stock_location]).set_count_on_hand attributes[:stock_total]
        end

        @product_id = product.id
      else
        @errors = product.errors.to_h
      end
    end
  end

  def success?
    @errors.empty?
  end
end
