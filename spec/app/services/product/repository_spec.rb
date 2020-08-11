require 'spec_helper'
# TODO: Add factories
require 'date'

RSpec.describe Product::Repository do
  describe '.call' do
    subject(:call) { described_class.call(products) }

    let!(:shipping_category) { Spree::ShippingCategory.create!(name: "Bags") }

    let(:products) {
      [{
        name: "Ruby on Rails Bag",
        description: "Animi officia aut amet molestiae atque excepturi. Placeat est cum occaecati molestiae quia.",
        price: 22.99,
        available_on: DateTime.now,
        slug: "ruby-on-rails-bag",
        stock_total: 15,
        category: "Bags"
      }]
    }
    # let(:products) {
    #   [{
    #     name: "Ruby on Rails Bag",
    #     description: "Animi officia aut amet molestiae atque excepturi. Placeat est cum occaecati molestiae quia.",
    #     price: 22.99,
    #     available_on: DateTime.now,
    #     slug: "ruby-on-rails-bag",
    #     stock_total: 15,
    #     category: "Bags"
    #   },
    #   {
    #     name: "Spree Bag",
    #     description: "Rerum quaerat autem non nihil quo laborum aut hic. Iure adipisci neque eum qui dolor.",
    #     price: 25.99,
    #     available_on: DateTime.now,
    #     slug: "spree-bag",
    #     stock_total: 5,
    #     category: "Bags"
    #   },
    #   {
    #     name: "Spree Tote",
    #     description: "Consequuntur quibusdam repellendus quia non. Iste et pariatur nulla fugit.",
    #     price: 14.99,
    #     available_on: DateTime.now,
    #     slug: "spree-tote",
    #     stock_total: 20,
    #     category: "Bags"
    #   }]
    # }

    it 'calls spree product' do
      # expect(Spree::Product)
      #   .to receive(:create!)
      #   .with(products)
      #   .and_call_original

      call
    end
  end
end
