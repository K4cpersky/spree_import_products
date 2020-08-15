class Product::Importer
  attr_reader :saved_records, :invalid_records

  def initialize
    @saved_records = []
    @invalid_records = []
  end

  def import(parse_result)
    parse_result.each_with_index do |element, index|
      product_repository = Product::Repository.new
      product_repository.create(product_sanitizer.sanitize(element))

      if product_repository.success?
        @saved_records << product_repository.product_id
      else
        @invalid_records << { row: index + 1, errors: product_repository.errors }
      end
    end
  end

  def product_sanitizer
    Product::Sanitizer.new
  end
end
