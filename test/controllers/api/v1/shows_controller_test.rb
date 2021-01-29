require 'test_helper'

class Api::V1::ShowsControllerTest < ActionDispatch::IntegrationTest
  test "should succeed" do
    group = Group.find_by(name: 'Cartel')
    get api_v1_group_show_url(group.token, "public"), as: :json
    assert_response :success
    assert_equal("Visible Show", response.parsed_body["name"])
  end

  test "should require a valid token" do
    get api_v1_group_show_url("invalid token", "Visible Show"), as: :json
    assert_response :not_found
    assert_equal({"message" => 'Invalid token.' }, response.parsed_body)
  end

  test "should require a valid show" do
    group = Group.find_by(name: 'Cartel')
    get api_v1_group_show_url(group.token, "Nonexistant"), as: :json
    assert_response :not_found
    assert_equal({"message" => 'No matching show found.' }, response.parsed_body)
  end

  test "should only search for shows for group" do
    group = Group.find_by(name: 'Cartel')
    get api_v1_group_show_url(group.token, "Trinity"), as: :json
    assert_response :not_found
    assert_equal({"message" => 'No matching show found.' }, response.parsed_body)
  end

  test "should handle joint shows" do
    group = Group.find_by(name: 'Trinity')
    get api_v1_group_show_url(group.token, "Joint Show"), as: :json
    assert_response :success
    assert_equal("Joint Show", response.parsed_body["name"])
  end

  test "should handle encoded names" do
    group = Group.find_by(name: "Cartel")
    member = group.members.find_by(name: 'Desch')
    show = Show.find_by(name: 'Visible Show')
    show.update(name: 'Saenai Heroine no Sodatekata ♭')

    # In JS, run: encodeURIComponent('name')
    encoded_name = 'Saenai%20Heroine%20no%20Sodatekata%20%E2%99%AD'

    get api_v1_group_show_url(group.token, encoded_name), as: :json
    assert_response :success
    assert_equal "Saenai Heroine no Sodatekata ♭", response.parsed_body["name"]
  end
end
