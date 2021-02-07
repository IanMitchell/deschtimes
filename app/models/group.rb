# == Schema Information
#
# Table name: groups
#
#  id         :bigint           not null, primary key
#  acronym    :string           not null
#  name       :string           not null
#  slug       :string
#  token      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_groups_on_acronym  (acronym) UNIQUE
#  index_groups_on_name     (name) UNIQUE
#  index_groups_on_slug     (slug) UNIQUE
#  index_groups_on_token    (token) UNIQUE
#
class Group < ApplicationRecord
  extend FriendlyId

  before_validation :generate_token, on: :create
  after_create :create_default_positions
  before_destroy :destroy_icon

  has_many :authorized_users, dependent: :destroy
  has_many :users, through: :authorized_users
  has_many :projects, dependent: :destroy
  has_many :all_shows, through: :projects
  has_many :positions, -> { order(rank: :asc) }, dependent: :destroy
  has_many :members, dependent: :destroy
  has_many :webhooks, dependent: :destroy
  has_one_attached :icon

  validates :name, presence: true,
                   uniqueness: true

  validates :acronym, presence: true,
                      uniqueness: true

  validates :token, presence: true,
                    uniqueness: true

  validates :icon, blob: {
                    content_type: :image,
                    size_range: 0..1.megabytes }

  friendly_id :name, use: :slugged


  def generate_token
    new_token = loop do
      token = SecureRandom.urlsafe_base64
      break token unless Group.exists?(token: token)
    end

    self.token = new_token
  end

  def fullname
    "[#{acronym}] #{name}"
  end

  def shows
    Show.joins(:projects).where(projects: { group: self, status: :accepted })
  end

  def priority_show_search!(name)
    result = shows.visible.joins(:terms).where('lower(terms.name) = ?', name.downcase).first
    return result unless result.nil?

    results = shows.visible.where('lower(shows.name) LIKE ?', "%#{ApplicationRecord::sanitize_sql_like(name.downcase)}%")

    case results.length
    when 0
      raise ShowNotFoundError
    when 1
      return results.first
    else
      return results.airing.first if results.airing.length == 1
      return results.active.first if results.active.length == 1

      names = results.map(&:name).to_sentence
      raise MultipleMatchingShowsError, "Multiple show matches: #{names}"
    end
  end

  private
    def create_default_positions
      Position.create([
        { name: "Translator", acronym: "TL", group: self },
        { name: "Editor", acronym: "ED", group: self },
        { name: "Timer", acronym: "TM", group: self },
        { name: "Typesetter", acronym: "TS", group: self },
        { name: "Encoder", acronym: "ENC", group: self },
        { name: "Quality Control", acronym: "QC", group: self }
      ])
    end

    def destroy_icon
      icon.purge_later
    end
end
