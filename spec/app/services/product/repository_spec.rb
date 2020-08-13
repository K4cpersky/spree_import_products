require 'spec_helper'

RSpec.describe Product::Repository do
  describe '.create' do
    subject(:product_repository) { described_class.create(products) }

    let(:stock_total) { 7 }
    let!(:shipping_category) { create(:shipping_category, name: "Default") }
    let!(:stock_location) { create(:stock_location, name: "Default") }
    let(:taxon) { create(:taxon) }

    context 'when data is valid' do
      context 'when product is imported' do
        let(:product) { build(:product) }
        let(:products) {
          {
            name: product.name,
            description: product.description,
            price: product.price,
            available_on: product.available_on,
            slug: "ruby-on-rails-bag",
            stock_total: stock_total,
            shipping_category: shipping_category,
            stock_location: stock_location,
            taxons: [taxon]
          }
        }

        it 'saves product to database' do
          expect { subject }.to change { Spree::Product.count }.by(1)
        end
      end

      context 'when imported product already exists' do
        let!(:product) { create(:product) }
        let(:products) {
          {
            name: product.name,
            description: product.description,
            price: product.price,
            available_on: product.available_on,
            slug: product.slug,
            stock_total: stock_total,
            shipping_category: shipping_category,
            stock_location: stock_location,
            taxons: [taxon]
          }
        }

        it 'does not save product again' do
          subject

          expect { subject }.to change { Spree::Product.count }.by(0)
        end
      end

      context 'when imported product has empty description, available_on, slug, stock_total and taxons attributes' do
        let!(:product) { build(:product) }
        let(:products) {
          {
            name: product.name,
            description: nil,
            price: product.price,
            available_on: nil,
            slug: nil,
            stock_total: nil,
            shipping_category: shipping_category,
            stock_location: stock_location,
            taxons: nil
          }
        }

        it 'saves product to database anyway because these attributes are optional' do
          expect { subject }.to change { Spree::Product.count }.by(1)
        end
      end

      context 'when stock_total and stock_location are given' do
        let!(:product) { build(:product) }
        let!(:additional_stock_location) { create(:stock_location) }
        let(:products) {
          {
            name: product.name,
            description: product.description,
            price: product.price,
            available_on: product.available_on,
            slug: product.slug,
            stock_total: stock_total,
            shipping_category: shipping_category,
            stock_location: stock_location,
            taxons: [taxon]
          }
        }
        let(:created_product) { Spree::Product.find_by(products.slice(:name, :description, :available_on, :shipping_category)) }

        it 'assigns stock_total as count_on_hand to default location' do
          subject

          expect(created_product.stock_items.find_by(stock_location: stock_location).count_on_hand).to eq products[:stock_total]
        end

        it 'does not assign stock_total to any other location than default' do
          subject

          expect(created_product.stock_items.find_by(stock_location: additional_stock_location).count_on_hand).to eq 0
        end
      end

      context 'when stock_total is not given' do
        let!(:product) { build(:product) }
        let(:products) {
          {
            name: product.name,
            description: product.description,
            price: product.price,
            available_on: product.available_on,
            slug: product.slug,
            stock_total: nil,
            shipping_category: shipping_category,
            stock_location: stock_location,
            taxons: [taxon]
          }
        }
        let(:created_product) { Spree::Product.find_by(products.slice(:name, :description, :available_on, :shipping_category)) }

        it 'does not assign stock_total as count_on_hand to default location' do
          subject

          expect(created_product.stock_items.find_by(stock_location: stock_location).count_on_hand).to eq 0
        end
      end

      context 'when stock_location is not given' do
        let!(:product) { build(:product) }
        let(:products) {
          {
            name: product.name,
            description: product.description,
            price: product.price,
            available_on: product.available_on,
            slug: product.slug,
            stock_total: stock_total,
            shipping_category: shipping_category,
            stock_location: nil,
            taxons: [taxon]
          }
        }
        let(:created_product) { Spree::Product.find_by(products.slice(:name, :description, :available_on, :shipping_category)) }

        it 'does not assign stock_total as count_on_hand to default location' do
          subject

          expect(created_product.stock_items.find_by(stock_location: stock_location).count_on_hand).to eq 0
        end
      end
    end

    context 'when data is invalid' do
      let(:product) { build(:product) }

      context 'when name attribute is missing' do
        let(:products) {
          {
            name: nil,
            description: product.description,
            price: product.price,
            available_on: product.available_on,
            slug: "ruby-on-rails-bag",
            stock_total: stock_total,
            shipping_category: shipping_category,
            stock_location: stock_location,
            taxons: [taxon]
          }
        }

        it 'raises name must be present error' do
          expect { subject }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Name can't be blank")
        end
      end

      context 'when price attribute is missing' do
        let(:products) {
          {
            name: product.name,
            description: product.description,
            price: nil,
            available_on: product.available_on,
            slug: "ruby-on-rails-bag",
            stock_total: stock_total,
            shipping_category: shipping_category,
            stock_location: stock_location,
            taxons: [taxon]
          }
        }

        it 'raises price must be present error' do
          expect { subject }.to raise_error(ActiveRecord::RecordInvalid,
            "Validation failed: Must supply price for variant or master price for product., Price can't be blank")
        end
      end

      context 'when shipping_category attribute is missing' do
        let(:products) {
          {
            name: product.name,
            description: product.description,
            price: product.price,
            available_on: product.available_on,
            slug: "ruby-on-rails-bag",
            stock_total: stock_total,
            shipping_category: nil,
            stock_location: stock_location,
            taxons: [taxon]
          }
        }

        it 'raises category must be present error' do
          expect { subject }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Shipping Category can't be blank")
        end
      end
    end
  end
end
