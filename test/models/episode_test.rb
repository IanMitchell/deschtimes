# == Schema Information
#
# Table name: episodes
#
#  id         :bigint           not null, primary key
#  air_date   :datetime
#  number     :integer
#  released   :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  show_id    :bigint           not null
#
# Indexes
#
#  index_episodes_on_released  (released)
#  index_episodes_on_show_id   (show_id)
#
# Foreign Keys
#
#  fk_rails_...  (show_id => shows.id)
#
require 'test_helper'

class EpisodeTest < ActiveSupport::TestCase
  test "notifies Discord on update" do
    skip 'Unimplemented'
  end

  test "member staff list matches non-admins to role" do
    group = Group.find_by(name: 'Cartel')
    episode = Show.find_by(name: 'Visible Show').current_unreleased_episode
    member = group.members.find_by(name: 'Fyurie')
    position = group.positions.find_by(acronym: 'TL')

    staff = episode.find_staff_for_member_and_position!(member, position, true)
    assert_equal episode, staff.episode
    assert_equal position, staff.position
  end

  test "should require staff for a given position" do
    group = Group.find_by(name: 'Cartel')
    episode = Show.find_by(name: 'Visible Show').current_unreleased_episode
    member = group.members.find_by(name: 'Fyurie')
    position = Position.create(name: 'Unused', acronym: 'NIL', group: group)

    assert_raises EpisodePositionStaffNotFoundError do
      episode.find_staff_for_member_and_position!(member, position, true)
    end
  end

  test "should require non-admin member is staff for a given position" do
    group = Group.find_by(name: 'Cartel')
    episode = Show.find_by(name: 'Visible Show').current_unreleased_episode
    member = group.members.find_by(name: 'Fyurie')
    position = group.positions.find_by(acronym: 'TM')

    assert_raises StaffNotFoundError do
      episode.find_staff_for_member_and_position!(member, position, true)
    end
  end

  test "member staff list matches admins to own position first when episode has multiple staff for a position" do
    finishing = true
    group = Group.find_by(name: 'Cartel')
    episode = Show.find_by(name: 'Visible Show').current_unreleased_episode
    member = group.members.find_by(name: 'Desch')
    position = group.positions.find_by(name: 'Translator')
    Staff.create(position: position, member: member, episode: episode)

    staff = episode.find_staff_for_member_and_position!(member, position, finishing)
    assert_equal member, staff.member

    staff.update(finished: true)
    staff = episode.find_staff_for_member_and_position!(member, position, finishing)
    assert_equal group.members.find_by(name: 'Fyurie'), staff.member
  end
end
