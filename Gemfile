source "https://rubygems.org"

gem "rails", "~> 7.2.2", ">= 7.2.2.2"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "tzinfo-data", platforms: %i[ windows jruby ]

gem 'bcrypt', '~> 3.1'
gem 'jwt'

gem "bootsnap", require: false

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'faker'
end
