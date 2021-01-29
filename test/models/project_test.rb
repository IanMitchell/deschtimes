# == Schema Information
#
# Table name: projects
#
#  id         :bigint           not null, primary key
#  status     :integer          default("pending")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  group_id   :bigint           not null
#  show_id    :bigint           not null
#
# Indexes
#
#  index_projects_on_group_id              (group_id)
#  index_projects_on_group_id_and_show_id  (group_id,show_id) UNIQUE
#  index_projects_on_show_id               (show_id)
#  index_projects_on_status                (status)
#
# Foreign Keys
#
#  fk_rails_...  (group_id => groups.id)
#  fk_rails_...  (show_id => shows.id)
#
require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
