# frozen_string_literal: true

class Product::Sanitizer
  def sanitize(params)
    params.except(:category).merge(shipping_category: default_shipping_category, stock_location: default_stock_location, taxons: [taxon(params)])
  end

  private

  def default_shipping_category
    Spree::ShippingCategory.find_or_create_by(name: 'Default')
  end

  def default_stock_location
    Spree::StockLocation.find_or_create_by(name: 'Default')
  end

  def taxon(params)
    Spree::Taxon.find_or_create_by(name: params[:category]) unless params[:category].blank?
  end
end
