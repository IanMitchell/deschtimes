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
require 'test_helper'

class StaffTest < ActiveSupport::TestCase
  test "notifies Discord on update" do
    skip 'Unimplemented'
  end
end
