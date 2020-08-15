module SpreeImportProducts
  module Spree
    module ProductsControllerDecorator
      def import
        result = product_service.import(import_params)

        if result.success?
          head :ok
        else
          render json: { errors: result.sheet_errors }, status: :unprocessable_entity
        end
      end

      private

      def product_service
        @product_service ||= Product.new
      end

      def import_params
        params.require(:data).require(:attributes).permit(:file)
      end
    end
  end
end

Spree::ProductsController.prepend SpreeImportProducts::Spree::ProductsControllerDecorator if
  ::Spree::ProductsController.included_modules.exclude?(SpreeImportProducts::Spree::ProductsControllerDecorator)
