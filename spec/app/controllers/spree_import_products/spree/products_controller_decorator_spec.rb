require 'spec_helper'
require 'json'

RSpec.describe Spree::ProductsController, type: :controller do
  describe 'POST #import' do
    subject(:post_import) do
      post :import, params: { data: { attributes: { file: file } } }
    end

    shared_examples 'products not saved' do
      it 'does not save any product to database' do
        expect { subject }.to change { Spree::Product.count }.by(0)
      end
    end

    let(:response_data) { JSON.parse(response.body) }

    context 'when file is valid' do
      let(:file) { fixture_file_upload('spec/factories/files/sample.csv', 'text/csv') }

      it 'has status 200' do
        post_import

        expect(response.status).to eq(200)
      end

      context 'when one product is given' do
        let(:file) { fixture_file_upload('spec/factories/files/one_row_sample.csv', 'text/csv') }

        context 'and it is not existing in database' do
          it 'saves that product to database' do
            expect { subject }.to change { Spree::Product.count }.by(1)
          end
        end

        context 'and this product already exists' do
          #TODO ActiveRecord::ConnectionAdapters::SQLite3Adapter does not support skipping duplicates
          let!(:stock_location) { create(:stock_location, name: "Default") }
          let!(:product) { create(:product, slug: "ruby-on-rails-bag") }

          it_should_behave_like 'products not saved'
        end
      end

      context 'when many products are given' do
        let(:file) { fixture_file_upload('spec/factories/files/sample.csv', 'text/csv') }

        context 'and none of them exists in database' do
          it 'saves all products to database' do
            expect { subject }.to change { Spree::Product.count }.by(3)
          end
        end

        context 'and some of them exists in database' do
          let!(:product) { create(:product, slug: "ruby-on-rails-bag") }

          it 'saves other products to database' do
            expect { subject }.to change { Spree::Product.count }.by(2)
          end
        end

        context 'and all of them exists in database' do
          let!(:product_one) { create(:product, slug: "ruby-on-rails-bag") }
          let!(:product_two) { create(:product, slug: "spree-bag") }
          let!(:product_three) { create(:product, slug: "spree-tote") }

          it_should_behave_like 'products not saved'
        end
      end
    end

    context 'when file is invalid' do
      shared_examples 'unprocessable_entity response status' do
        it 'has status 422' do
          post_import

          expect(response.status).to eq(422)
        end
      end

      context 'when file is missing' do
        let(:file) { nil }

        it_should_behave_like 'products not saved'
        it_should_behave_like 'unprocessable_entity response status'

        it 'contains valid response data' do
          post_import

          expect(response_data["errors"]).to include({"file"=>["is missing"]})
        end
      end

      context 'when file has wrong content type' do
        let(:file) { fixture_file_upload('spec/factories/files/sample.txt', 'text/plain') }

        it_should_behave_like 'products not saved'
        it_should_behave_like 'unprocessable_entity response status'

        it 'contains valid response data' do
          post_import

          expect(response_data["errors"]).to include({"file"=>["wrong file content type"]})
        end
      end

      context 'when file is empty' do
        let(:file) { fixture_file_upload('spec/factories/files/empty_file_sample.csv', 'text/csv') }

        it_should_behave_like 'products not saved'
        it_should_behave_like 'unprocessable_entity response status'

        it 'contains valid response data' do
          post_import

          expect(response_data["errors"]).to include({"file"=>["file is empty"]})
        end
      end

      context 'when some columns are missing' do
        let(:file) { fixture_file_upload('spec/factories/files/column_missing_sample.csv', 'text/csv') }

        it_should_behave_like 'products not saved'
        it_should_behave_like 'unprocessable_entity response status'

        it 'contains valid response data' do
          post_import

          expect(response_data["errors"]).to include({"file"=>["some columns are missing"]})
        end
      end

      context 'when rows are blank' do
        let(:file) { fixture_file_upload('spec/factories/files/blank_rows_sample.csv', 'text/csv') }

        it_should_behave_like 'products not saved'
        it_should_behave_like 'unprocessable_entity response status'

        it 'contains valid response data' do
          post_import

          expect(response_data["errors"]).to include({"file"=>["lack of rows"]})
        end
      end
    end
  end
end
