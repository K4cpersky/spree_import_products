class Product::Importer
  def self.import(parse_result)
    parse_result.each do |element|
      Product::Repository.create(product_sanitizer.sanitize(element))
    end
  end

  def self.product_sanitizer
    @product_sanitizer ||= Product::Sanitizer.new
  end
end
