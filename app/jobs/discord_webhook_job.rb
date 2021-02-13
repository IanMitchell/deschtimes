class DiscordWebhookJob < ApplicationJob
  queue_as :default

  def perform(webhook, embed, avatar)
    Discord::Notifier.message embed,
                              username: webhook.name,
                              url: webhook.url,
                              avatar_url: avatar
  end
end
