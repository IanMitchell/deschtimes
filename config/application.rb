require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Deschtimes
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Background jobs
    config.active_job.queue_adapter = :sidekiq

    # Disable generated helper files
    config.generators.assets = false
    config.generators.helper = false

    # Allow Wordpress widget requests
    # config.middleware.insert_before 0, Rack::Cors do
    #   allow do
    #     origins '*'
    #     resource '*', :headers => :any, :methods => [:get, :post, :options]
    #   end
    # end

    # Set default timezone to JST
    config.time_zone = 'Japan'

    # Enable CDN
    config.active_storage.resolve_model_to_route = :cdn_proxy if ENV['ACTIVE_STORAGE_CDN'].present?
  end
end
