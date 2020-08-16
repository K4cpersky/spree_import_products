source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'spree', github: 'spree/spree', branch: 'master'
gem 'spree_auth_devise', github: 'spree/spree_auth_devise'
gem 'rails-controller-testing'
gem 'dry-validation', '~> 1.5'
group :test do
  gem 'factory_bot_rails'
  gem 'faker'
end

gemspec
