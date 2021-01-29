Sentry.init do |config|
  config.dsn = 'https://d893c9c36f594926a3c83233273a5b0a@o165375.ingest.sentry.io/5590539'
  config.breadcrumbs_logger = [:active_support_logger]

  config.enabled_environments = %w[production]

  # config.async = lambda { |event|
  #   SentryJob.perform_later(event)
  # }
end
