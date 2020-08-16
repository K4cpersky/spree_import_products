Spree::Core::Engine.add_routes do
  # Add your extension routes here
  post '/admin/products/import' => 'admin/products#import'
end
