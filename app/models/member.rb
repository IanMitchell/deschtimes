# == Schema Information
#
# Table name: members
#
#  id         :bigint           not null, primary key
#  admin      :boolean          default(FALSE)
#  discord    :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  group_id   :bigint           not null
#
# Indexes
#
#  index_members_on_group_id  (group_id)
#
# Foreign Keys
#
#  fk_rails_...  (group_id => groups.id)
#
class Member < ApplicationRecord
  has_many :staff, dependent: :destroy
  belongs_to :group

  validates :discord, presence: true,
                      uniqueness: { scope: :group, message: "Member Discord IDs should be unique" }

  validates :name, presence: true,
                   uniqueness: { scope: :group, message: "Member names should be unique" }
end
