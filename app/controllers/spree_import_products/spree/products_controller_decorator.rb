module SpreeImportProducts
  module Spree
    module ProductsControllerDecorator
      def import
        Sheet::Process.call(import_permitted_params)

        head :ok
      end

      private

      def import_permitted_params
        params.require(:data).require(:attributes).permit(:file)
      end
    end
  end
end

Spree::ProductsController.prepend SpreeImportProducts::Spree::ProductsControllerDecorator
