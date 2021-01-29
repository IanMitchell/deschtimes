require 'test_helper'

class DonationsControllerTest < ActionDispatch::IntegrationTest
  test "should get donations page" do
    get donations_url
    assert_response :success
  end
end
