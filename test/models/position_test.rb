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
require 'test_helper'

class PositionTest < ActiveSupport::TestCase
  test "should match against acronyms" do
    position = Group.find_by(name: 'Cartel').positions.where_name_or_acronym_equals!("TL").first
    assert_equal "Translator", position.name
    assert_equal "TL", position.acronym
  end

  test "should match against names" do
    position = Group.find_by(name: 'Cartel').positions.where_name_or_acronym_equals!("Timer").first
    assert_equal "Timer", position.name
    assert_equal "TM", position.acronym
  end

  test "should raise an exception when no position found" do
    assert_raises PositionNotFoundError do
      Group.find_by(name: 'Cartel').positions.where_name_or_acronym_equals!("Nonexistant")
    end
  end

  test "should find all matches" do
    positions = Position.where_name_or_acronym_equals!("Timer")
    assert_equal 2, positions.size
  end

  test "should not allow spaces in acronym" do
    assert Position.new(name: 'Invalid', acronym: 'No Spaces', group: Group.first).invalid?
  end
end
