require 'spec_helper'

RSpec.describe 'Routing', type: :routing do
  it {
    expect(:post => "/admin/products/import").to route_to(
      :controller => "spree/admin/products",
      :action => "import"
    )
  }
end
