require 'spec_helper'

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

    context 'when data is valid' do
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

    context 'when data is invalid' do
      context 'when file is missing' do
        let(:file) { nil }

        it_should_behave_like 'products not saved'

        it 'has status 200' do
          post_import

          expect(response.status).to eq(200)
        end
      end
    end
  end
end
