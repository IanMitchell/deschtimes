# == Schema Information
#
# Table name: episodes
#
#  id         :bigint           not null, primary key
#  air_date   :datetime
#  number     :integer
#  released   :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  show_id    :bigint           not null
#
# Indexes
#
#  index_episodes_on_released  (released)
#  index_episodes_on_show_id   (show_id)
#
# Foreign Keys
#
#  fk_rails_...  (show_id => shows.id)
#
require 'action_view'
require 'action_view/helpers'
include ActionView::Helpers::DateHelper

class Episode < ApplicationRecord
  has_many :staff, -> { joins(:position).order(rank: :asc) }, dependent: :destroy
  belongs_to :show, touch: true

  after_update :notify_release, if: :saved_change_to_released?

  attr_accessor :update_air_dates

  accepts_nested_attributes_for :staff

  scope :pending, -> { where(released: false) }
  scope :released, -> { where(released: true) }

  validates :show, presence: true

  validates :air_date, presence: true

  validates :number, presence: true,
                     numericality: true,
                     uniqueness: {
                       scope: :show,
                       message: "Show episode number must be unique"
                     }

  def season
    "#{Episode.month_to_season(air_date.month)} #{air_date.year}"
  end

  def aired?
    air_date <= DateTime.now
  end

  def remaining_staff_positions
    unfinished = staff.where(finished: false)

    if unfinished.size > 0
      unfinished.map(&:position).map(&:acronym).to_sentence
    else
      "None!"
    end
  end

  def discord_status_label
    staff.map do |staff|
      key = staff.position.acronym
      staff.finished ? "~~#{key}~~" : "**#{key}**"
    end
  end

  def find_staff_for_member_and_position!(member, positions, finished)
    results = staff.where(position: positions).reorder(id: :asc).distinct
    raise EpisodePositionStaffNotFoundError if results.empty?

    results = results.where(member: member) unless member.admin?

    case results.size
    when 0
      raise StaffNotFoundError
    when 1
      return results.first
    else
      # Prioritize specific job
      job = results.where(member: member, finished: !finished).first
      return job unless job.nil?

      # Prioritize in-group positions
      job = results.includes(:position).where(finished: !finished, position: { group: member.group }).first
      return job unless job.nil?

      # Return first matching results
      return results.where(finished: !finished).first
    end
  end

  private
    def self.month_to_season(month)
      case month
      when 1..3
        "Winter"
      when 4..6
        "Spring"
      when 7..9
        "Summer"
      when 10..12
        "Fall"
      end
    end

    def notify_release
      return unless self.released?
      return unless show.visible?

      released = show.episodes.where(released: true).size
      unreleased = show.episodes.where(released: false).size

      episode = self
      thumbnail = Rails.application.routes.url_helpers.rails_blob_url(episode.show.poster, disposition: "attachment") if episode.show.poster.attached?

      embed = Discord::Embed.new do
        title "#{episode.show.name} Episode ##{episode.number} Released!"
        color 0x008000
        timestamp DateTime.now
        thumbnail url: thumbnail
        author name: 'Deschtimes',
               url: 'https://deschtimes.com'

        description episode.show.status if episode.show.status?
      end

      if show.current_unreleased_episode&.aired?
        embed.add_field name: "Episode ##{show.current_unreleased_episode.number} Status",
                        value: show.current_unreleased_episode.discord_status_label.join(" ")
      elsif show.current_unreleased_episode
        embed.add_field name: 'Next Air Date',
                        value: distance_of_time_in_words(DateTime.now, show.current_unreleased_episode.air_date)
      else
        embed.add_field name: 'Fansub Finished!',
                        value: 'This was the last episode in the series!'
      end

      Webhook.discord.where(group: show.groups).each do |webhook|
        avatar = nil

        if webhook.group.icon.attached?
          avatar = Rails.application.routes.url_helpers.rails_blob_url(webhook.group.icon, disposition: "attachment")
        end

        Discord::Notifier.message embed,
                                  username: webhook.name,
                                  url: webhook.url,
                                  avatar_url: avatar
      end
    end
end
