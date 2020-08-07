Spree::Core::Engine.add_routes do
  # Add your extension routes here
  post '/import' => 'products#import'
end
