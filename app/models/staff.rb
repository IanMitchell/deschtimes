# == Schema Information
#
# Table name: staff
#
#  id          :bigint           not null, primary key
#  finished    :boolean          default(FALSE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  episode_id  :bigint           not null
#  member_id   :bigint           not null
#  position_id :bigint           not null
#
# Indexes
#
#  index_staff_on_episode_id   (episode_id)
#  index_staff_on_member_id    (member_id)
#  index_staff_on_position_id  (position_id)
#
# Foreign Keys
#
#  fk_rails_...  (episode_id => episodes.id)
#  fk_rails_...  (member_id => members.id)
#  fk_rails_...  (position_id => positions.id)
#
class Staff < ApplicationRecord
  belongs_to :member
  belongs_to :episode, touch: true
  belongs_to :position

  after_update :notify_update, if: :saved_change_to_finished?

  def title(include_group = false)
    title = ""

    if include_group
      title = "[#{member.group.acronym}]"
    end

    "#{title}[#{position.acronym}] #{member.name}"
  end

  private
    def notify_update
      return unless episode.show.visible?

      staff = self
      thumbnail = Rails.application.routes.url_helpers.rails_blob_url(episode.show.poster, disposition: "attachment") if episode.show.poster.attached?
      title = staff.finished ? "✅ #{staff.position.name}" : "❌ #{staff.position.name}"

      embed = Discord::Embed.new do
        title "#{staff.episode.show.name} Episode ##{staff.episode.number}"
        color staff.finished ? 0x008000 : 0x800000
        timestamp DateTime.now
        thumbnail url: thumbnail
        author name: 'Deschtimes',
               url: 'https://deschtimes.com'

        description staff.episode.show.status if staff.episode.show.status?

        add_field name: title,
                  value: staff.episode.discord_status_label.join(" ")
      end

      Webhook.discord.where(group: episode.show.groups).each do |webhook|
        avatar = nil

        if webhook.group.icon.attached?
          avatar = Rails.application.routes.url_helpers.rails_blob_url(webhook.group.icon, disposition: "attachment")
        end

        DiscordWebhookJob.perform_later(webhook, embed, avatar)
      end
    end
end
