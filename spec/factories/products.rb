FactoryBot.modify do
  #TODO: Can i build this better?
  factory :something do
    stock_total { Faker::Number.number(digits: 2) }
    category { "Bags" }
    slug { "ruby-on-rails-bag" }
  end
end
