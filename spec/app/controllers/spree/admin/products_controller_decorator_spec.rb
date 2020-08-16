require 'spec_helper'
require 'json'

RSpec.describe Spree::Admin::ProductsController, type: :controller do
  stub_authorization!

  before do
    reset_spree_preferences
    user = build(:admin_user)
    allow(controller).to receive(:try_spree_current_user).and_return(user)
  end

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

      shared_examples 'response with status 200' do
        it 'has status 200' do
          post_import

          expect(response.status).to eq(200)
        end
      end


      context 'when all data is valid' do
        context 'when one product is given' do
          let(:file) { fixture_file_upload('spec/factories/files/one_row_sample.csv', 'text/csv') }

          context 'and it is not existing in database' do
            let(:created_product) { Spree::Product.last }

            it 'saves that product to database' do
              expect { subject }.to change { Spree::Product.count }.by(1)
            end

            it 'contains valid response data' do
              subject

              expect(response_data["product_ids"].first).to eq created_product.id
              expect(response_data["import_errors"]).to be_empty
            end

            it_should_behave_like 'response with status 200'
          end

          context 'and this product already exists' do
            let!(:stock_location) { create(:stock_location, name: "Default") }
            let!(:product) { create(:product, slug: "ruby-on-rails-bag") }

            it_should_behave_like 'products not saved'

            it 'contains valid response data' do
              subject

              expect(response_data["product_ids"]).to be_empty
              expect(response_data["import_errors"]).to be_empty
            end

            it_should_behave_like 'response with status 200'
          end
        end

        context 'when many products are given' do
          let(:file) { fixture_file_upload('spec/factories/files/sample.csv', 'text/csv') }

          context 'and none of them exists in database' do
            let(:created_products) { Spree::Product.last(3).pluck(:id) }

            it 'saves all products to database' do
              expect { subject }.to change { Spree::Product.count }.by(3)
            end

            it 'contains valid response data' do
              subject

              expect(response_data["product_ids"] - created_products).to be_empty
              expect(response_data["import_errors"]).to be_empty
            end

            it_should_behave_like 'response with status 200'
          end

          context 'and some of them exists in database' do
            let(:slug) { "ruby-on-rails-bag" }
            let!(:product) { create(:product, slug: slug) }
            let(:created_products) { Spree::Product.last(2).pluck(:id) }

            it 'saves other products to database' do
              expect { subject }.to change { Spree::Product.count }.by(2)
            end

            it 'contains valid response data' do
              subject

              expect(response_data["product_ids"] - created_products).to be_empty
              expect(response_data["import_errors"]).to be_empty
            end

            it_should_behave_like 'response with status 200'
          end

          context 'and all of them exists in database' do
            let!(:product_one) { create(:product, slug: "ruby-on-rails-bag") }
            let!(:product_two) { create(:product, slug: "spree-bag") }
            let!(:product_three) { create(:product, slug: "spree-tote") }

            it_should_behave_like 'products not saved'

            it 'contains valid response data' do
              subject

              expect(response_data["product_ids"]).to be_empty
              expect(response_data["import_errors"]).to be_empty
            end

            it_should_behave_like 'response with status 200'
          end
        end
      end

      context 'when some data is invalid' do
        context 'when one row is given' do
          context 'when its missing name' do
            let(:file) { fixture_file_upload('spec/factories/files/data_errors/blank_name_sample.csv', 'text/csv') }

            it 'contains valid response data' do
              subject

              expect(response_data["product_ids"]).to be_empty
              expect(response_data["import_errors"].length).to eq 1
              expect(response_data["import_errors"]).to include({"row"=>1, "errors"=>{"name"=>"can't be blank"}})
            end

            it_should_behave_like 'response with status 200'
            it_should_behave_like 'products not saved'
          end

          context 'when its missing name' do
            let(:file) { fixture_file_upload('spec/factories/files/data_errors/blank_name_sample.csv', 'text/csv') }

            it 'contains valid response data' do
              subject

              expect(response_data["product_ids"]).to be_empty
              expect(response_data["import_errors"].length).to eq 1
              expect(response_data["import_errors"]).to include({"row"=>1, "errors"=>{"name"=>"can't be blank"}})
            end

            it_should_behave_like 'response with status 200'
            it_should_behave_like 'products not saved'
          end

          context 'when its missing price' do
            let(:file) { fixture_file_upload('spec/factories/files/data_errors/blank_price_sample.csv', 'text/csv') }

            it 'contains valid response data' do
              subject

              expect(response_data["product_ids"]).to be_empty
              expect(response_data["import_errors"].length).to eq 1
              expect(response_data["import_errors"]).to include({"row"=>1, "errors"=>{"base"=>"Must supply price for variant or master price for product.", "price"=>"can't be blank"}})
            end

            it_should_behave_like 'response with status 200'
            it_should_behave_like 'products not saved'
          end
        end

        context 'when many rows are given' do
          let(:file) { fixture_file_upload('spec/factories/files/mixed_sample.csv', 'text/csv') }
          let(:created_products) { Spree::Product.last(12).pluck(:id) }
          let(:expected_response) do
            [
              {"row"=>2, "errors"=>{"name"=>"can't be blank"}},
              {"row"=>4, "errors"=>{"name"=>"can't be blank"}},
              {"row"=>6, "errors"=>{"name"=>"can't be blank"}},
              {"row"=>8, "errors"=>{"name"=>"can't be blank"}},
              {"row"=>12, "errors"=>{"name"=>"can't be blank"}},
              {"row"=>14, "errors"=>{"name"=>"can't be blank"}},
              {"row"=>18, "errors"=>{"name"=>"can't be blank"}}
            ]
          end

          it 'saves some products to database' do
            expect { subject }.to change { Spree::Product.count }.by(12)
          end

          it 'contains valid response data' do
            subject

            expect(response_data["product_ids"] - created_products).to be_empty
            expect(response_data["import_errors"].length).to eq 7
            expect(response_data["import_errors"]).to match_array(expected_response)
          end
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

          expect(response_data["errors"].length).to eq 1
          expect(response_data["errors"]).to include({"file"=>["is missing"]})
        end
      end

      context 'when file has wrong content type' do
        let(:file) { fixture_file_upload('spec/factories/files/sheet_errors/sample.txt', 'text/plain') }

        it_should_behave_like 'products not saved'
        it_should_behave_like 'unprocessable_entity response status'

        it 'contains valid response data' do
          post_import

          expect(response_data["errors"].length).to eq 1
          expect(response_data["errors"]).to include({"file"=>["wrong file content type"]})
        end
      end

      context 'when file is empty' do
        let(:file) { fixture_file_upload('spec/factories/files/sheet_errors/empty_file_sample.csv', 'text/csv') }

        it_should_behave_like 'products not saved'
        it_should_behave_like 'unprocessable_entity response status'

        it 'contains valid response data' do
          post_import

          expect(response_data["errors"].length).to eq 1
          expect(response_data["errors"]).to include({"file"=>["file is empty"]})
        end
      end

      context 'when some columns are missing' do
        let(:file) { fixture_file_upload('spec/factories/files/sheet_errors/column_missing_sample.csv', 'text/csv') }

        it_should_behave_like 'products not saved'
        it_should_behave_like 'unprocessable_entity response status'

        it 'contains valid response data' do
          post_import

          expect(response_data["errors"].length).to eq 1
          expect(response_data["errors"]).to include({"file"=>["some columns are missing"]})
        end
      end

      context 'when rows are blank' do
        let(:file) { fixture_file_upload('spec/factories/files/sheet_errors/blank_rows_sample.csv', 'text/csv') }

        it_should_behave_like 'products not saved'
        it_should_behave_like 'unprocessable_entity response status'

        it 'contains valid response data' do
          post_import

          expect(response_data["errors"].length).to eq 1
          expect(response_data["errors"]).to include({"file"=>["lack of rows"]})
        end
      end
    end
  end
end
