require 'net/http'

class VercelWebhookJob < ApplicationJob
  queue_as :default

  def perform(webhook)
    Net::HTTP.post(URI(webhook.url), nil)
  end
end
