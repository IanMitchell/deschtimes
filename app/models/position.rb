# == Schema Information
#
# Table name: positions
#
#  id         :bigint           not null, primary key
#  acronym    :string           not null
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  group_id   :bigint           not null
#
# Indexes
#
#  index_positions_on_acronym   (acronym)
#  index_positions_on_group_id  (group_id)
#  index_positions_on_name      (name)
#
# Foreign Keys
#
#  fk_rails_...  (group_id => groups.id)
#
class Position < ApplicationRecord
  has_many :staff, dependent: :destroy
  belongs_to :group

  validates :name, presence: true,
                   uniqueness: {
                     scope: :group,
                     message: "Position Names must be unique."
                   }

  validates :acronym, presence: true,
                      uniqueness: {
                        scope: :group,
                        message: "Position Acronyms must be unique."
                      }

  def self.find_by_name_or_acronym!(value)
    position = where(
      'lower(name) = ? OR lower(acronym) = ?',
      value.downcase,
      value.downcase
    ).first

    raise PositionNotFoundError if position.nil?
    return position
  end
end
