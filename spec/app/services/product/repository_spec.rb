require 'spec_helper'

RSpec.describe Product::Repository do
  describe '.call' do
    subject(:call) { described_class.call(products) }

    let!(:shipping_category) { create(:shipping_category, name: "Bags") }
    let!(:stock_location) { create(:stock_location) }

    context 'when data is valid' do
      context 'when one product is imported' do
        let(:product) { build(:product) }
        let(:products) {
          [{
            name: product.name,
            description: product.description,
            price: product.price,
            available_on: product.available_on,
            slug: "ruby-on-rails-bag",
            stock_total: 15,
            category: "Bags"
          }]
        }

        it 'saves product to database' do
          expect { subject }.to change { Spree::Product.count }.by(products.length)
        end

        it 'uses existing shipping category record' do
          expect { subject }.to change { Spree::ShippingCategory.count }.by(0)
        end
      end

      context 'when imported product already exists' do
        let!(:product) { create(:product) }
        let(:products) {
          [{
            name: product.name,
            description: product.description,
            price: product.price,
            available_on: product.available_on,
            slug: product.slug,
            stock_total: 15,
            category: "Bags"
          }]
        }

        it 'does not save product again' do
          call

          expect { subject }.to change { Spree::Product.count }.by(0)
        end
      end

      context 'when imported product has unwanted columns' do
        let!(:product) { build(:product) }
        let(:products) {
          [{
            name: product.name,
            description: product.description,
            price: product.price,
            available_on: product.available_on,
            slug: product.slug,
            stock_total: 15,
            category: "Bags",
            some_unwanted_column: "Spam",
            another_unwanted_column: "Spam"
          }]
        }

        it 'selects only whitelisted columns and saves product to database' do
          expect { subject }.to change { Spree::Product.count }.by(products.length)
        end
      end

      context 'when imported product has empty description, available_on, slug and stock_total attributes' do
        let!(:product) { build(:product) }
        let(:products) {
          [{
            name: product.name,
            description: nil,
            price: product.price,
            available_on: nil,
            slug: nil,
            stock_total: nil,
            category: "Bags"
          }]
        }

        it 'saves product to database anyway because these attributes are optional' do
          expect { subject }.to change { Spree::Product.count }.by(products.length)
        end
      end

      context 'when imported product has unexisting category in database' do
        let!(:product) { build(:product) }
        let(:products) {
          [{
            name: product.name,
            description: product.description,
            price: product.price,
            available_on: product.available_on,
            slug: "ruby-on-rails-bag",
            stock_total: 15,
            category: "Glass"
          }]
        }

        it 'creates new shipping category record' do
          expect { subject }.to change { Spree::ShippingCategory.count }.by(1)
        end

        it 'saves product to database' do
          expect { subject }.to change { Spree::Product.count }.by(products.length)
        end
      end

      context 'when many products are imported' do
        let(:products) {
          [{
            name: attributes_for(:product)[:name],
            description: attributes_for(:product)[:description],
            price: attributes_for(:product)[:price],
            available_on: attributes_for(:product)[:available_on],
            slug: "ruby-on-rails-bag",
            stock_total: 15,
            category: "Bags"
          },
          {
            name: attributes_for(:product)[:name],
            description: attributes_for(:product)[:description],
            price: attributes_for(:product)[:price],
            available_on: attributes_for(:product)[:available_on],
            slug: "spree-bag",
            stock_total: 5,
            category: "Bags"
          },
          {
            name: attributes_for(:product)[:name],
            description: attributes_for(:product)[:description],
            price: attributes_for(:product)[:price],
            available_on: attributes_for(:product)[:available_on],
            slug: "spree-tote",
            stock_total: 20,
            category: "Bags"
          }]
        }

        it 'saves products to database' do
          expect { subject }.to change { Spree::Product.count }.by(products.length)
        end
      end

      context 'when some of imported products already exists' do
        let!(:product) { create(:product) }
        let(:products) {
          [{
            name: product.name,
            description: product.description,
            price: product.price,
            available_on: product.available_on,
            slug: product.slug,
            stock_total: 15,
            category: "Bags"
          },
          {
            name: attributes_for(:product)[:name],
            description: attributes_for(:product)[:description],
            price: attributes_for(:product)[:price],
            available_on: attributes_for(:product)[:available_on],
            slug: "spree-bag",
            stock_total: 5,
            category: "Bags"
          },
          {
            name: attributes_for(:product)[:name],
            description: attributes_for(:product)[:description],
            price: attributes_for(:product)[:price],
            available_on: attributes_for(:product)[:available_on],
            slug: "spree-tote",
            stock_total: 20,
            category: "Bags"
          }]
        }

        it 'does not save only existing product to database' do
          expect { subject }.to change { Spree::Product.count }.by(products.length - 1)
        end
      end

      context 'when every imported product already exists' do
        let!(:product_one) { create(:product) }
        let!(:product_two) { create(:product) }
        let!(:product_three) { create(:product) }
        let(:products) {
          [{
            name: product_one.name,
            description: product_one.description,
            price: product_one.price,
            available_on: product_one.available_on,
            slug: product_one.slug,
            stock_total: 15,
            category: "Bags"
          },
          {
            name: product_two.name,
            description: product_two.description,
            price: product_two.price,
            available_on: product_two.available_on,
            slug: product_two.slug,
            stock_total: 5,
            category: "Bags"
          },
          {
            name: product_three.name,
            description: product_three.description,
            price: product_three.price,
            available_on: product_three.available_on,
            slug: product_three.slug,
            stock_total: 20,
            category: "Bags"
          }]
        }

        it 'does not save any product to database' do
          expect { subject }.to change { Spree::Product.count }.by(0)
        end
      end
    end

    context 'when data is invalid' do
      let(:product) { build(:product) }

      context 'when name attribute is missing' do
        let(:products) {
          [{
            name: nil,
            description: product.description,
            price: product.price,
            available_on: product.available_on,
            slug: "ruby-on-rails-bag",
            stock_total: 15,
            category: "Bags"
          }]
        }

        it 'raises name must be present error' do
          expect { subject }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Name can't be blank")
        end
      end

      context 'when price attribute is missing' do
        let(:products) {
          [{
            name: product.name,
            description: product.description,
            price: nil,
            available_on: product.available_on,
            slug: "ruby-on-rails-bag",
            stock_total: 15,
            category: "Bags"
          }]
        }

        it 'raises price must be present error' do
          expect { subject }.to raise_error(ActiveRecord::RecordInvalid,
            "Validation failed: Must supply price for variant or master price for product., Price can't be blank")
        end
      end

      context 'when category attribute is missing' do
        let(:products) {
          [{
            name: product.name,
            description: product.description,
            price: product.price,
            available_on: product.available_on,
            slug: "ruby-on-rails-bag",
            stock_total: 15,
            category: nil
          }]
        }

        it 'raises category must be present error' do
          expect { subject }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Shipping Category can't be blank")
        end
      end
    end
  end
end
