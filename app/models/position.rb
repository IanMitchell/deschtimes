# == Schema Information
#
# Table name: positions
#
#  id         :bigint           not null, primary key
#  acronym    :string           not null
#  name       :string           not null
#  rank       :integer
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

  acts_as_list scope: :group, column: :rank

  validates :name, presence: true,
                   uniqueness: {
                     scope: :group,
                     message: "Position Names must be unique."
                   }

  validates :acronym, presence: true,
                      format: { with: /\A[a-zA-Z0-9]+\Z/ },
                      uniqueness: {
                        scope: :group,
                        message: "Position Acronyms must be unique."
                      }

  def self.where_name_or_acronym_equals!(value)
    positions = where(
      'lower(name) = ? OR lower(acronym) = ?',
      value.downcase,
      value.downcase
    )

    raise PositionNotFoundError if positions.size == 0
    return positions
  end
end
