module Spree
  module Admin
    module ProductsControllerDecorator
      def import
        result = product_service.import(import_params)

        if result.success?
          render json: { product_ids: result.saved_records, import_errors: result.import_errors }, status: :ok
        else
          render json: { errors: result.sheet_errors }, status: :unprocessable_entity
        end
      end

      private

      def product_service
        @product_service ||= ProductService.new
      end

      def import_params
        params.require(:data).require(:attributes).permit(:file)
      end
    end
  end
end

Spree::Admin::ProductsController.prepend Spree::Admin::ProductsControllerDecorator if
  ::Spree::Admin::ProductsController.included_modules.exclude?(Spree::Admin::ProductsControllerDecorator)
