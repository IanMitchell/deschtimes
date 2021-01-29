require 'test_helper'

class Api::V1::GroupsControllerTest < ActionDispatch::IntegrationTest
  test "should get list of groups" do
    get api_v1_groups_url, as: :json
    assert_response :success
  end

  test "should require a valid token" do
    get api_v1_group_url("invalid token"), as: :json
    assert_response :not_found
    assert_equal({"message" => 'Invalid token.' }, response.parsed_body)
  end

  test "should get group information" do
    get api_v1_group_url(Group.find_by(name: "Cartel").token), as: :json
    assert_response :success
  end

  test "should not display hidden shows" do
    get api_v1_group_url(Group.find_by(name: "Cartel").token), as: :json
    assert_response :success

    shows = response.parsed_body["shows"].map { |show| show["name"] }
    assert_not shows.include? "invisible"
  end
end
