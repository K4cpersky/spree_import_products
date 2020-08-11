require 'spec_helper'

RSpec.describe Spree::ProductsController, type: :controller do
  describe 'POST #import' do
    let(:file) { fixture_file_upload('spec/factories/files/sample.csv', 'text/csv') }
    let!(:stock_location) { create(:stock_location) }

    subject(:post_import) do
      post :import, params: { data: { attributes: { file: file } } }
    end

    it 'calls product service' do
      ActionController::Parameters.permit_all_parameters = true
      import_permitted_params = ActionController::Parameters.new(file: file)

      expect(Product::Service).to receive(:call).and_call_original
      # TODO: How to add .with(import_permitted_params)?
      post_import
    end

    it 'has status 200' do
      post_import

      expect(response.status).to eq(200)
    end
  end
end
