require 'test_helper'

class DocumentationControllerTest < ActionDispatch::IntegrationTest
  test "should get documentation list" do
    get documentation_url
    assert_response :success
  end

  test "should get discord documentation" do
    get documentation_discord_url
    assert_response :success
  end

  test "should get web api documentation" do
    get documentation_api_url
    assert_response :success
  end

  test "should get webhook documentation" do
    get documentation_webhooks_url
    assert_response :success
  end
end
