require 'rails_helper'
require 'json'

RSpec.describe "Products importer", type: :request do
  subject(:post_import) do
    post "/admin/products/import", params: { "data": { "attributes": { "file": file } } }
  end

  let(:user) { create(:admin_user) }
  before(:each) do
    login_as(user, scope: :spree_user)
  end
  let(:response_data) { JSON.parse(response.body) }

  context 'when file contains 3 correct products' do
    let(:file) { fixture_file_upload('spec/factories/files/sample.csv', 'text/csv') }

    it "imports 3 products" do
      post_import

      expect(response_data["product_ids"].length).to eq 3
    end

    it "it returns no errors" do
      post_import

      expect(response_data["import_errors"]).to be_empty
    end
  end

  context 'when file does not contain any valid product' do
    let(:file) { fixture_file_upload('spec/factories/files/data_errors/blank_name_sample.csv', 'text/csv') }

    it "does not import any product" do
      post_import

      expect(response_data["product_ids"]).to be_empty
    end

    it "it returns errors" do
      post_import

      expect(response_data["import_errors"]).to include({"row"=>1, "errors"=>{"name"=>"can't be blank"}})
    end
  end

  context 'when file contains mixed valid and invalid products' do
    let(:file) { fixture_file_upload('spec/factories/files/mixed_sample.csv', 'text/csv') }

    it "imports 12 products" do
      post_import

      expect(response_data["product_ids"].length).to eq 12
    end

    it "it returns 7 invalid rows" do
      post_import

      expect(response_data["import_errors"].length).to eq 7
    end
  end

  context 'when file is missing' do
    let(:file) { nil }

    it "it returns sheet errors" do
      post_import

      expect(response_data).to include({"errors"=>{"file"=>["is missing"]}})
    end
  end

  context 'when file has wrong content type' do
    let(:file) { fixture_file_upload('spec/factories/files/sheet_errors/sample.txt', 'text/plain') }

    it "it returns sheet errors" do
      post_import

      expect(response_data).to include({"errors"=>{"file"=>["wrong file content type"]}})
    end
  end

  context 'when file is empty' do
    let(:file) { fixture_file_upload('spec/factories/files/sheet_errors/empty_file_sample.csv', 'text/csv') }

    it "it returns sheet errors" do
      post_import

      expect(response_data).to include({"errors"=>{"file"=>["file is empty"]}})
    end
  end

  context 'when some columns are missing' do
    let(:file) { fixture_file_upload('spec/factories/files/sheet_errors/column_missing_sample.csv', 'text/csv') }

    it "it returns sheet errors" do
      post_import

      expect(response_data).to include({"errors"=>{"file"=>["some columns are missing"]}})
    end
  end

  context 'when rows are blank' do
    let(:file) { fixture_file_upload('spec/factories/files/sheet_errors/blank_rows_sample.csv', 'text/csv') }

    it "it returns sheet errors" do
      post_import

      expect(response_data).to include({"errors"=>{"file"=>["lack of rows"]}})
    end
  end
end
