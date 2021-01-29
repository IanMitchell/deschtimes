# == Schema Information
#
# Table name: authorized_users
#
#  id         :bigint           not null, primary key
#  owner      :boolean          default(FALSE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  group_id   :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_authorized_users_on_group_id              (group_id)
#  index_authorized_users_on_group_id_and_user_id  (group_id,user_id) UNIQUE
#  index_authorized_users_on_user_id               (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (group_id => groups.id)
#  fk_rails_...  (user_id => users.id)
#
class AuthorizedUser < ApplicationRecord
  belongs_to :user
  belongs_to :group
end
