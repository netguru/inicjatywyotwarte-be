# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.5'

# Admin Panel
gem 'activeadmin'

gem 'acts-as-taggable-on', '~> 6.0'
gem 'aws-sdk-s3', require: false
gem 'cancan'
gem 'crono'
gem 'daemons'
gem 'devise'
gem 'fast_jsonapi'
gem 'grape'
gem 'grape-swagger', '>= 0.34.2'
gem 'grape-swagger-rails'
gem 'haml'
gem 'http'
gem 'kaminari'
gem 'pg', '>= 0.18', '< 2.0'
gem 'pg_search'
gem 'puma', '~> 4.3'
gem 'rack-cors'
gem 'rails', '~> 6.0.3', '>= 6.0.3.1'
gem 'rollbar'
gem 'sidekiq'
gem 'sinatra', require: nil

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails'
  gem 'ffaker'
  gem 'pry'
  gem 'rspec-rails', '~> 4.0.0.beta4'
end

group :test do
  gem 'brakeman', require: false
  gem 'bundle-audit', require: false
  gem 'rspec-sidekiq'
  gem 'rspec_junit_formatter', '~> 0.2.3'
  gem 'shoulda-matchers'
end

group :development do
  gem 'bullet'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'rubocop', '~> 0.80.1', require: false
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :staging do
  gem 'rack_password'
end
