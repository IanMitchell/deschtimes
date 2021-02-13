# == Schema Information
#
# Table name: shows
#
#  id             :bigint           not null, primary key
#  name           :string
#  projects_count :integer          default(0), not null
#  status         :text
#  visible        :boolean
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_shows_on_name     (name)
#  index_shows_on_visible  (visible)
#
require 'test_helper'

class ShowTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
