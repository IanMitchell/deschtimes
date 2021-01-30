# == Schema Information
#
# Table name: shows
#
#  id         :bigint           not null, primary key
#  name       :string
#  status     :text
#  visible    :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_shows_on_name     (name)
#  index_shows_on_visible  (visible)
#
class Show < ApplicationRecord
  include PgSearch::Model

  after_create :create_episodes
  before_save :touch_groups
  before_destroy :destroy_poster

  attr_accessor :new_show_episode_count
  attr_accessor :new_show_episode_air_date
  attr_accessor :new_show_episode_number_start
  attr_accessor :new_show_staff
  attr_accessor :new_show_group

  has_many :projects, dependent: :destroy
  has_many :all_groups, through: :projects
  has_many :terms, dependent: :destroy
  has_many :episodes, dependent: :destroy
  has_one_attached :poster

  pg_search_scope :search, against: [:name]

  validates :name, presence: true

  validates :poster, blob: {
                      content_type: :image,
                      size_range: 0..1.megabytes }

  scope :visible, -> { where(visible: true) }

  scope :active, -> {
    includes(:episodes)
      .where(episodes: { released: false })
      .order("episodes.air_date DESC")
  }

  scope :finished, -> {
    where.not(id: Episode.select(:show_id).where(released: false))
  }

  scope :airing, -> {
    joins(:episodes)
      .merge(
        Episode.where('air_date >= :current_date', current_date: DateTime.now)
      )
      .distinct
  }

  def groups
    Group.joins(:projects).where(projects: { show: self, status: :accepted })
  end

  def next_airing_episode
    episodes.where('air_date >= :current_date', current_date: DateTime.now)
      .order(number: :asc)
      .first
  end

  def first_episode
    episodes.order(air_date: :asc).first
  end

  def last_episode
    episodes.order(air_date: :desc).first
  end

  def reschedule_episodes(episode)
    episodes.where("number > ?", episode.number).order(number: :asc).each_with_index do |ep, index|
      ep.update(air_date: episode.air_date + (1 + index).weeks)
    end
  end

  def season
    season_start = first_episode.season
    season_end = last_episode.season

    if season_start == season_end
      season_start
    else
      "#{season_start} to #{season_end}"
    end
  end

  def current_unreleased_episode
    episodes.pending.order("episodes.number ASC").first
  end

  def progress_label
    if airing?
      "Airing"
    elsif finished?
      "Complete"
    else
      "Incomplete"
    end
  end

  def airing?
    episodes.where('air_date >= :current_date', current_date: DateTime.now).any?
  end

  def joint?
    groups.count > 1
  end

  def finished?
    current_unreleased_episode.nil?
  end

  private
    # When a show is finished, we need to update counters on various UI elements.
    # To do this, we need to bust the cache
    def touch_groups
      if finished?
        groups.find_each(batch_size: 100) { |group| group.touch }
      end
    end

    def destroy_poster
      poster.purge_later
    end

    def create_episodes
      group = new_show_group
      offset = new_show_episode_number_start.to_i.abs

      # Switch from UTC to JST
      air_date = Time.find_zone("JST").parse(new_show_episode_air_date) || DateTime.now

      new_show_episode_count.to_i.clamp(0, 5_000).times do |index|
        episode = episodes.build(
          number: index + offset,
          air_date: air_date + 1.week * index
        )

        new_show_staff.each do |staff|
          episode.staff.build(
            member: group.members.find(staff["member"].to_i),
            position: group.positions.find(staff["position"].to_i)
          )
        end
      end

      save
    end
end
