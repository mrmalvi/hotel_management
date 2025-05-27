source "https://rubygems.org"

ruby "3.2.2"

# Core gems
gem "rails", "~> 7.1.0"
gem "mysql2", "~> 0.5"
gem "puma", ">= 5.0"
gem "bootsnap", require: false
gem "jbuilder"
gem "tzinfo-data", platforms: %i[ windows jruby ]
gem "bcrypt", "~> 3.1.7"
# gem "sprockets-rails"

# Authentication & Authorization
gem "devise"
gem "cancancan"

# UI & Frontend
gem "tailwindcss-rails"
gem "kaminari"
gem "font-awesome-rails"

gem "jsbundling-rails", "~> 0.1.0"
gem "sprockets-rails", ">= 3.4.1"

# File Upload & Storage
gem "aws-sdk-s3", require: false
gem "image_processing", "~> 1.2"

# Background Jobs & Scheduling
gem "sidekiq"
gem "whenever", require: false

# API & External Services
gem "twilio-ruby"
gem "stripe"

# Development & Testing
group :development, :test do
  gem "debug", platforms: %i[ mri windows ]
  gem "rspec-rails"
  gem "factory_bot_rails"
  gem "faker"
end

group :development do
  gem "web-console"
  gem "better_errors"
  gem "binding_of_caller"
  gem "annotate"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
end

# Pagination
gem 'pagy'

# Modern Rails features
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "pg", "~> 1.1"
gem "redis", ">= 4.0.1"

gem "cssbundling-rails", "~> 1.4"
