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
require 'test_helper'

class MemberTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
