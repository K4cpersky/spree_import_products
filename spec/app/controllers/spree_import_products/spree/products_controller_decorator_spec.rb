require 'spec_helper'

RSpec.describe Spree::ProductsController, type: :controller do
  describe 'POST #import' do
    subject(:post_import) do
      post :import, params: { data: { attributes: { file: file } } }
    end

    shared_examples 'product service called' do
      it 'calls product service' do
        post_import
      end
    end

    context 'when products are created' do
      let(:file) { fixture_file_upload('spec/factories/files/sample.csv', 'text/csv') }

      it_should_behave_like 'product service called'

      it 'has status 200' do
        post_import

        expect(response.status).to eq(200)
      end
    end

    # context 'when products are not created' do
    #   let(:file) { fixture_file_upload('spec/factories/files/invalid_attributes_sample.csv', 'text/csv') }
    #
    #   it_should_behave_like 'product service called'
    #
    #   it 'throws an error' do
    #   end
    # end
  end
end
