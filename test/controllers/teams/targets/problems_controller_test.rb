require 'test_helper'

class Teams::Targets::ProblemsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get teams_targets_problems_create_url
    assert_response :success
  end

  test "should get show" do
    get teams_targets_problems_show_url
    assert_response :success
  end

  test "should get edit" do
    get teams_targets_problems_edit_url
    assert_response :success
  end

  test "should get update" do
    get teams_targets_problems_update_url
    assert_response :success
  end

  test "should get destroy" do
    get teams_targets_problems_destroy_url
    assert_response :success
  end

end
