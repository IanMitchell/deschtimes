# == Schema Information
#
# Table name: terms
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  show_id    :bigint           not null
#
# Indexes
#
#  index_terms_on_show_id  (show_id)
#
# Foreign Keys
#
#  fk_rails_...  (show_id => shows.id)
#
class Term < ApplicationRecord
  belongs_to :show, touch: true

  validates :name, presence: true,
                   uniqueness: {
                     scope: :show,
                     message: "Show terms must be unique"
                   }
end
