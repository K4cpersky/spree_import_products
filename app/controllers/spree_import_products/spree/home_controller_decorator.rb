module SpreeImportProducts
  module Spree
    module HomeControllerDecorator
      def import
      end
    end
  end
end

Spree::HomeController.prepend SpreeImportProducts::Spree::HomeControllerDecorator
