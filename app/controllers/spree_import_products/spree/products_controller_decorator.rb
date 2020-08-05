module SpreeImportProducts
  module Spree
    module ProductsControllerDecorator
      def import
      end
    end
  end
end

Spree::ProductsController.prepend SpreeImportProducts::Spree::ProductsControllerDecorator
