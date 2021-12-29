source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.3'
# Fast mime detection by extension or content
gem 'mimemagic', '~> 0.3.5', github: 'mimemagicrb/mimemagic', ref: '01f92d86d15d85cfd0f20dabd025dcbd36a8a60f'
# Use sqlite3 as the database for Active Record
gem 'sqlite3'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
#gem 'mini_racer', platforms: :ruby
gem 'therubyracer'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5.2.0'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# haml
gem 'haml', '~> 5.1', '>= 5.1.2'
# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', github: 'Shopify/bootsnap', branch: 'handle-race-conditions'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'
# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'
# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# RSpec
gem 'rspec', '~> 3.8'
# FactoryBot
gem 'factory_bot_rails'
# Ruby Mail Handler, https://github.com/mikel/mail/
gem 'mail', '~> 2.7', '>= 2.7.1'
# validates email for application use
gem 'valid_email'
# A lightweight mime type lookup toy
gem 'mini_mime', '~> 1.0', '>= 1.0.2'
# Upgrade rubyzip to version 1.3.0 or later (security)
gem "rubyzip", ">= 1.3.0"

# mail-related
gem 'actionview-encoded_mail_to'
gem 'sidekiq'
gem 'redis-rails'
gem 'delayed_job_active_record'

# devise
gem 'devise'
gem 'devise-encryptable'
gem 'devise_invitable'
gem 'devise_invitations'

# twitter-bootstrap-rails
gem "less-rails" #Sprockets (what Rails 3.1 uses for its asset pipeline) supports LESS
gem "twitter-bootstrap-rails"
gem "simple_form"

# Timestamps
gem 'stamp', '~> 0.6.0'

# random token generator
gem 'random_token', '~> 1.1', '>= 1.1.1'

# Securely configure authentication
gem 'figaro', '~> 1.1', '>= 1.1.1'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'mailcatcher'
  # Minitest
  gem 'minitest', '~> 5.12', '>= 5.12.2'
  gem 'minitest-matchers', '~> 1.4', '>= 1.4.1'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'chromedriver-helper'
  gem 'rails-controller-testing'
  gem 'email_spec'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem "rspec-rails", :group => [:development, :test]