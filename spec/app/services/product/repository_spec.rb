require 'spec_helper'

RSpec.describe Product::Repository do
  describe '.create' do
    subject(:product_repository) { described_class.create(products) }

    let!(:shipping_category) { create(:shipping_category, name: "Bags") }
    let!(:stock_location) { create(:stock_location, name: "Default") }

    context 'when data is valid' do
      context 'when one product is imported' do
        let(:product) { build(:product) }
        let(:products) {
          {
            name: product.name,
            description: product.description,
            price: product.price,
            available_on: product.available_on,
            slug: "ruby-on-rails-bag",
            stock_total: 15,
            shipping_category: shipping_category
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
            stock_total: 15,
            shipping_category: shipping_category
          }
        }

        it 'does not save product again' do
          subject

          expect { subject }.to change { Spree::Product.count }.by(0)
        end
      end

      context 'when imported product has empty description, available_on, slug and stock_total attributes' do
        let!(:product) { build(:product) }
        let(:products) {
          {
            name: product.name,
            description: nil,
            price: product.price,
            available_on: nil,
            slug: nil,
            stock_total: nil,
            shipping_category: shipping_category
          }
        }

        it 'saves product to database anyway because these attributes are optional' do
          expect { subject }.to change { Spree::Product.count }.by(1)
        end
      end

      context 'when stock_total is given' do
        let!(:product) { build(:product) }
        let!(:additional_stock_location) { create(:stock_location) }
        let(:products) {
          {
            name: product.name,
            description: product.description,
            price: product.price,
            available_on: product.available_on,
            slug: product.slug,
            stock_total: 7,
            shipping_category: shipping_category
          }
        }
        let(:created_product) { Spree::Product.find_by(products.except(:price, :stock_total, :slug)) }

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
            shipping_category: shipping_category
          }
        }
        let(:created_product) { Spree::Product.find_by(products.except(:price, :stock_total, :slug)) }

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
            stock_total: 15,
            shipping_category: shipping_category
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
            stock_total: 15,
            shipping_category: shipping_category
          }
        }

        it 'raises price must be present error' do
          expect { subject }.to raise_error(ActiveRecord::RecordInvalid,
            "Validation failed: Must supply price for variant or master price for product., Price can't be blank")
        end
      end

      context 'when category attribute is missing' do
        let(:products) {
          {
            name: product.name,
            description: product.description,
            price: product.price,
            available_on: product.available_on,
            slug: "ruby-on-rails-bag",
            stock_total: 15,
            shipping_category: nil
          }
        }

        it 'raises category must be present error' do
          expect { subject }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Shipping Category can't be blank")
        end
      end
    end
  end
end
