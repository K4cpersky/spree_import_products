module SpreeImportProducts
  module Spree
    module ProductsControllerDecorator
      # def self.prepended(base)
      #   base.before_action :load_data, only: :some_action
      # end

      def import
        Product::Service.call(import_permitted_params)

        head :ok
      end

      private

      def import_permitted_params
        params.require(:data).require(:attributes).permit(:file)
      end
    end
  end
end

Spree::ProductsController.prepend SpreeImportProducts::Spree::ProductsControllerDecorator if
  ::Spree::ProductsController.included_modules.exclude?(SpreeImportProducts::Spree::ProductsControllerDecorator)
