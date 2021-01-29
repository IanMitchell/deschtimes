require 'test_helper'

class Api::V1::EpisodesControllerTest < ActionDispatch::IntegrationTest
  test "should succeed" do
    group = Group.find_by(name: "Cartel")
    member = group.members.find_by(name: 'Desch')
    show = Show.find_by(name: 'Visible Show')
    show.current_unreleased_episode.staff.each { |staff| staff.update_column(:finished, true) }

    patch api_v1_group_show_episodes_url(group.token, 'Visible Show', member: member.discord), as: :json
    assert_response :success
    assert_equal "Visible Show", response.parsed_body["name"]
  end

  test "should require a valid token" do
    patch api_v1_group_show_episodes_url("invalid token", "Visible"), as: :json
    assert_response :not_found
    assert_equal({"message" => 'Invalid token.' }, response.parsed_body)
  end

  test "should require a valid show" do
    group = Group.find_by(name: "Cartel")

    patch api_v1_group_show_episodes_url(group.token, "invalid show name"), as: :json
    assert_response :not_found
    assert_equal({"message" => 'No matching show found.' }, response.parsed_body)
  end

  test "should require an incomplete show" do
    group = Group.find_by(name: "Cartel")
    member = group.members.find_by(name: 'Desch')
    show = Show.find_by(name: 'Visible Show')
    show.episodes.each { |episode| episode.update(released: true) }

    patch api_v1_group_show_episodes_url(group.token, 'Visible', member: member.discord), as: :json
    assert_response :bad_request
    assert_equal({"message" => 'That show is already complete.' }, response.parsed_body)
  end

  test "should require all positions to be finished" do
    group = Group.find_by(name: "Cartel")
    member = group.members.find_by(name: 'Desch')

    patch api_v1_group_show_episodes_url(group.token, 'Visible Show', member: member.discord), as: :json
    assert_response :bad_request
    assert_equal({
      "message" => "The Translator and Timer positions are still incomplete!"
    }, response.parsed_body)
  end

  test 'should require an admin staff member' do
    group = Group.find_by(name: "Cartel")
    member = group.members.find_by(name: 'Fyurie')

    patch api_v1_group_show_episodes_url(group.token, 'Visible Show'), as: :json
    assert_response :unauthorized
    assert_equal({
      "message" => 'You are not a group member. Please ping an admin and ask to be added.'
    }, response.parsed_body)

    patch api_v1_group_show_episodes_url(group.token, 'Visible Show', member: member.discord), as: :json
    assert_response :unauthorized
    assert_equal({"message" => "You are not a group admin." }, response.parsed_body)
  end

  test "should only search for shows for group" do
    group = Group.find_by(name: "Cartel")

    patch api_v1_group_show_episodes_url(group.token, 'Trinity'), as: :json
    assert_response :not_found
    assert_equal({ "message" => "No matching show found." }, response.parsed_body)
  end

  test "should handle joint shows" do
    group = Group.find_by(name: "Cartel")
    member = group.members.find_by(name: 'Desch')
    show = Show.find_by(name: 'Joint Show')
    show.current_unreleased_episode.staff.each { |staff| staff.update_column(:finished, true) }

    patch api_v1_group_show_episodes_url(group.token, 'Joint Show', member: member.discord), as: :json
    assert_response :success
    assert_equal "Joint Show", response.parsed_body["name"]
  end

  test "should not allow admins from other groups to release joints" do
    group = Group.find_by(name: "Cartel")
    member = Member.find_by(name: 'Levi')
    show = Show.find_by(name: 'Joint Show')
    show.current_unreleased_episode.staff.each { |staff| staff.update_column(:finished, true) }

    patch api_v1_group_show_episodes_url(group.token, 'Joint Show', member: member.discord), as: :json
    assert_response :unauthorized
  end

  test "should handle encoded names" do
    group = Group.find_by(name: "Cartel")
    member = group.members.find_by(name: 'Desch')
    show = Show.find_by(name: 'Visible Show')
    show.update(name: 'Saenai Heroine no Sodatekata ♭')
    show.current_unreleased_episode.staff.each { |staff| staff.update_column(:finished, true) }

    # In JS, run: encodeURIComponent('name')
    encoded_name = 'Saenai%20Heroine%20no%20Sodatekata%20%E2%99%AD'
    patch api_v1_group_show_episodes_url(group.token, encoded_name, member: member.discord), as: :json
    assert_response :success
    assert_equal "Saenai Heroine no Sodatekata ♭", response.parsed_body["name"]
  end

  test 'should only update the latest unreleased episode' do
    group = Group.find_by(name: "Cartel")
    member = group.members.find_by(name: 'Desch')
    show = Show.find_by(name: 'Visible Show')
    show.current_unreleased_episode.staff.each { |staff| staff.update_column(:finished, true) }

    patch api_v1_group_show_episodes_url(group.token, 'Visible Show', member: member.discord), as: :json
    assert_response :success

    assert_equal false, show.current_unreleased_episode.released
    assert_equal 3, show.current_unreleased_episode.number
    assert_equal "Visible Show", response.parsed_body["name"]
  end
end
