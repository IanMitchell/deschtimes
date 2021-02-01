source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.0'
gem 'rexml' # Temporary until next version of rails

gem 'rails', '~> 6.1.1'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 5.1'

gem 'sass-rails', '>= 6'
gem 'webpacker', '~> 5.2'
gem 'turbolinks', '~> 5'

gem 'jbuilder', '~> 2.7'

gem 'devise'
gem 'friendly_id'

gem 'local_time'

gem 'redis'
gem 'sidekiq'
# gem 'image_optim'
# gem 'image_optim_pack'

gem 'skylight'
gem 'sentry-ruby'
gem 'sentry-rails'
gem 'discord-notifier'
gem 'activestorage-validator'
gem "aws-sdk-s3", require: false

# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

gem 'bootsnap', '>= 1.4.2', require: false

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'annotate'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  gem 'webdrivers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
