require 'test_helper'

class Api::V1::StaffControllerTest < ActionDispatch::IntegrationTest
  test "should succeed at marking complete" do
    group = Group.find_by(name: "Cartel")
    member = group.members.find_by(name: 'Desch')
    show = Show.find_by(name: 'Visible Show')

    patch api_v1_group_show_staff_url(group.token, 'Visible Show', member: member.discord, position: 'TM', finished: true), as: :json
    assert_response :success
    assert_equal "Visible Show", response.parsed_body["name"]

    episode = response.parsed_body["episodes"].find { |item| item["number"] == 2 }
    tl_staff = episode["staff"].find { |item| item["position"]["acronym"] == "TL" }
    tm_staff = episode["staff"].find { |item| item["position"]["acronym"] == "TM" }

    assert_equal true, tm_staff["finished"]
    assert_equal false, tl_staff["finished"]
  end

  test "should succeed at marking incomplete" do
    group = Group.find_by(name: "Cartel")
    member = group.members.find_by(name: 'Desch')
    show = Show.find_by(name: 'Visible Show')

    show.current_unreleased_episode.staff.where(member: member).each do |staff|
      staff.update(finished: true)
    end

    patch api_v1_group_show_staff_url(group.token, 'Visible Show', member: member.discord, position: 'TM', finished: false), as: :json
    assert_response :success
    assert_equal "Visible Show", response.parsed_body["name"]

    episode = response.parsed_body["episodes"].find { |item| item["number"] == 2 }
    tl_staff = episode["staff"].find { |item| item["position"]["acronym"] == "TL" }
    tm_staff = episode["staff"].find { |item| item["position"]["acronym"] == "TM" }

    assert_equal false, tm_staff["finished"]
    assert_equal false, tl_staff["finished"]
  end

  test "should require a valid token" do
    group = Group.find_by(name: "Cartel")
    member = group.members.find_by(name: 'Desch')
    show = Show.find_by(name: 'Visible Show')

    patch api_v1_group_show_staff_url("invalid token", 'Visible Show', member: member.discord, position: 'TL', finished: true), as: :json
    assert_response :not_found
    assert_equal({"message" => 'Invalid token.' }, response.parsed_body)
  end

  test "should require the finished parameter" do
    group = Group.find_by(name: "Cartel")
    member = group.members.find_by(name: 'Desch')
    show = Show.find_by(name: 'Visible Show')

    patch api_v1_group_show_staff_url(group.token, 'Visible Show', member: member.discord, position: 'TL'), as: :json
    assert_response :bad_request
    assert_equal({"message" => 'Please provide the finished parameter.' }, response.parsed_body)
  end

  test "should require a show staff member" do
    group = Group.find_by(name: "Cartel")
    member = group.members.create(name: 'light', discord: 'light')
    show = Show.find_by(name: 'Visible Show')

    patch api_v1_group_show_staff_url(group.token, 'Visible Show', member: member.discord, position: 'TL', finished: true), as: :json
    assert_response :bad_request
    assert_equal({"message" => "You don't have permission to modify that position." }, response.parsed_body)
  end

  test "should require non-admin staff member to have position" do
    group = Group.find_by(name: "Cartel")
    member = group.members.find_by(name: 'Fyurie')
    show = Show.find_by(name: 'Visible Show')

    patch api_v1_group_show_staff_url(group.token, 'Visible Show', member: member.discord, position: 'TM', finished: true), as: :json
    assert_response :bad_request
    assert_equal({"message" => "You don't have permission to modify that position." }, response.parsed_body)
  end

  test "should require valid position" do
    group = Group.find_by(name: "Cartel")
    member = group.members.find_by(name: 'Desch')
    show = Show.find_by(name: 'Visible Show')

    patch api_v1_group_show_staff_url(group.token, 'Visible Show', member: member.discord, position: 'TLC', finished: true), as: :json
    assert_response :not_found
    assert_equal({"message" => "Unknown position." }, response.parsed_body)
  end

  test "should allow admin staff member to mark any position" do
    group = Group.find_by(name: "Cartel")
    member = group.members.find_by(name: 'Desch')
    show = Show.find_by(name: 'Visible Show')

    patch api_v1_group_show_staff_url(group.token, 'Visible Show', member: member.discord, position: 'TL', finished: true), as: :json
    assert_response :success
    assert_equal "Visible Show", response.parsed_body["name"]

    episode = response.parsed_body["episodes"].find { |item| item["number"] == 2 }
    tl_staff = episode["staff"].find { |item| item["position"]["acronym"] == "TL" }
    tm_staff = episode["staff"].find { |item| item["position"]["acronym"] == "TM" }

    assert_equal true, tl_staff["finished"]
    assert_equal false, tm_staff["finished"]
  end

  test "should prioritize admin position, then non-admin position" do
    group = Group.find_by(name: "Cartel")
    member = group.members.find_by(name: 'Desch')
    show = Show.find_by(name: 'Visible Show')
    show.current_unreleased_episode.staff.create(position: group.positions.find_by(acronym: 'TL'), member: member)

    # First done should be admin role
    patch api_v1_group_show_staff_url(group.token, 'Visible Show', member: member.discord, position: 'TL', finished: true), as: :json
    assert_response :success

    episode = response.parsed_body["episodes"].find { |item| item["number"] == 2 }
    staff = episode["staff"].select { |item| item["position"]["acronym"] == "TL" }
    admin_position = staff.find { |item| item["member"]["name"] == member.name }
    member_position = staff.find { |item| item["member"]["name"] != member.name }

    assert_equal true, admin_position["finished"]
    assert_equal false, member_position["finished"]

    # Second should be regular member role
    patch api_v1_group_show_staff_url(group.token, 'Visible Show', member: member.discord, position: 'TL', finished: true), as: :json
    assert_response :success

    episode = response.parsed_body["episodes"].find { |item| item["number"] == 2 }
    staff = episode["staff"].select { |item| item["position"]["acronym"] == "TL" }
    admin_position = staff.find { |item| item["member"]["name"] == member.name }
    member_position = staff.find { |item| item["member"]["name"] != member.name }

    assert_equal true, admin_position["finished"]
    assert_equal true, member_position["finished"]
  end

  test "should not allow non-staff to update from joint server" do
    group = Group.find_by(name: "Trinity")
    member = Group.find_by(name: "Cartel").members.find_by(name: 'Desch')
    show = Show.find_by(name: 'Joint Show')

    patch api_v1_group_show_staff_url(group.token, 'Joint Show', member: member.discord, position: 'TL', finished: true), as: :json
    assert_response :unauthorized
    assert_equal({"message" => "You are not a group member. Please ping an admin and ask to be added." }, response.parsed_body)
  end

  test "should require position to not already be marked" do
    group = Group.find_by(name: "Cartel")
    member = group.members.find_by(name: 'Fyurie')
    show = Show.find_by(name: 'Visible Show')

    patch api_v1_group_show_staff_url(group.token, 'Visible Show', member: member.discord, position: 'TL', finished: false), as: :json
    assert_response :bad_request
    assert_equal({"message" => "Your position is already marked as incomplete." }, response.parsed_body)

    show.current_unreleased_episode.staff.where(member: member).each do |staff|
      staff.update(finished: true)
    end

    patch api_v1_group_show_staff_url(group.token, 'Visible Show', member: member.discord, position: 'TL', finished: true), as: :json
    assert_response :bad_request
    assert_equal({"message" => "Your position is already marked as complete." }, response.parsed_body)
  end

  test "should require episode to have aired" do
    group = Group.find_by(name: "Cartel")
    member = group.members.find_by(name: 'Desch')
    show = Show.find_by(name: 'Visible Show')

    show.current_unreleased_episode.update(air_date: DateTime.now + 1.week)

    patch api_v1_group_show_staff_url(group.token, 'Visible Show', member: member.discord, position: 'TM', finished: true), as: :json
    assert_response :bad_request
    assert_equal({"message" => "The current episode has not aired yet." }, response.parsed_body)
  end

  test "should only search for shows for group" do
    group = Group.find_by(name: "Cartel")
    member = group.members.find_by(name: 'Desch')

    patch api_v1_group_show_staff_url(group.token, 'Trinity', member: member.discord, position: 'TM', finished: true), as: :json
    assert_response :not_found
    assert_equal({"message" => "No matching show found." }, response.parsed_body)
  end

  test "should handle joint shows" do
    group = Group.find_by(name: "Cartel")
    member = group.members.find_by(name: 'Desch')
    show = Show.find_by(name: 'Joint Show')

    patch api_v1_group_show_staff_url(group.token, 'Joint Show', member: member.discord, position: 'TL', finished: true), as: :json
    assert_response :success
  end

  test "should succeed for future aired episodes" do
    group = Group.find_by(name: "Cartel")
    member = group.members.find_by(name: 'Desch')
    show = Show.find_by(name: 'Visible Show')
    show.episodes.find_by(number: 3).update(air_date: DateTime.now - 3.seconds)

    patch api_v1_group_show_staff_url(group.token, 'Visible Show', member: member.discord, position: 'TM', finished: true, episode_number: 3), as: :json
    assert_response :success
    assert_equal "Visible Show", response.parsed_body["name"]

    episode = response.parsed_body["episodes"].find { |item| item["number"] == 2 }
    tl_staff = episode["staff"].find { |item| item["position"]["acronym"] == "TL" }
    tm_staff = episode["staff"].find { |item| item["position"]["acronym"] == "TM" }

    assert_equal false, tm_staff["finished"]
    assert_equal false, tl_staff["finished"]

    episode = response.parsed_body["episodes"].find { |item| item["number"] == 3 }
    tl_staff = episode["staff"].find { |item| item["position"]["acronym"] == "TL" }
    tm_staff = episode["staff"].find { |item| item["position"]["acronym"] == "TM" }

    assert_equal true, tm_staff["finished"]
    assert_equal false, tl_staff["finished"]
  end
end
