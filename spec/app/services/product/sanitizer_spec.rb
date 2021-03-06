require 'spec_helper'

RSpec.describe Product::Sanitizer do
  describe '#sanitize' do
    subject(:sanitize) { described_class.new.sanitize(params) }

    PERMITTED_ATTRIBUTES = [:name, :description, :price, :available_on, :slug, :stock_total, :shipping_category, :stock_location, :taxons].freeze

    let(:shipping_category) { Spree::ShippingCategory.find_by(name: "Default") }
    let(:stock_location) { Spree::StockLocation.find_by(name: "Default") }
    let(:taxon_name) { "Bags" }
    let(:taxon) { Spree::Taxon.find_by(name: taxon_name) }

    let(:params) { {} }

    it 'adds shipping category to params' do
      expect(sanitize).to include(shipping_category: shipping_category)
    end

    it 'adds stock_location to params' do
      expect(sanitize).to include(stock_location: stock_location)
    end

    it 'removes category from attributes' do
      expect(sanitize).not_to include(params)
    end

    context 'when category param is given' do
      let(:params) { {category: taxon_name} }

      it 'adds taxons key with found object' do
        expect(sanitize).to include(taxons: [taxon])
      end

      context 'when taxon is found' do
        let!(:taxon) { create(:taxon, name: taxon_name) }

        it 'does not create additional taxon' do
          expect { sanitize }.to change { Spree::Taxon.count }.by(0)
        end
      end

      context 'when taxon is not found' do
        it 'creates new taxon by provided name' do
          expect { sanitize }.to change { Spree::Taxon.count }.by(1)
        end
      end
    end

    context 'when category param is not given' do
      let(:params) { {category: nil} }

      it 'adds taxons key with nil value' do
        expect(sanitize).to include(taxons: [nil])
      end
    end

    context 'when shipping_category is found' do
      let!(:shipping_category) { create(:shipping_category, name: "Default") }

      it 'does not create additional taxon' do
        expect { sanitize }.to change { Spree::ShippingCategory.count }.by(0)
      end
    end

    context 'when shipping_category is not found' do
      it 'creates new taxon by provided name' do
        expect { sanitize }.to change { Spree::ShippingCategory.count }.by(1)
      end
    end

    context 'when params contain additional attributes' do
      let(:product) { attributes_for(:product) }
      let(:params) do
        {
          name: product[:name],
          description: product[:description],
          price: product[:price],
          available_on: product[:available_on],
          slug: "ruby-on-rails-bag",
          stock_total: 7,
          category: "Bags",
          additional_attribute: "Some data"
        }
      end

      it 'removes unwanted attributes' do
        expect(sanitize).not_to include(additional_attribute: "Some data")
      end

      it 'returns no more than defined set of attributes' do
        expect(PERMITTED_ATTRIBUTES - sanitize.keys).to be_empty
      end
    end
  end
end
