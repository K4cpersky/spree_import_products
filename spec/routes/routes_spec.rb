# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Routing', type: :routing do
  it {
    expect(:post => "/import").to route_to(
      :controller => "spree/products",
      :action => "import"
    )
  }
end
