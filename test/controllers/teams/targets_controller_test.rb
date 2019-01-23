require 'test_helper'

class Teams::TargetsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get teams_targets_create_url
    assert_response :success
  end

  test "should get edit" do
    get teams_targets_edit_url
    assert_response :success
  end

  test "should get update" do
    get teams_targets_update_url
    assert_response :success
  end

end
