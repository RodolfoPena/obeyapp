require 'test_helper'

class Teams::Targets::CommitmentsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get teams_targets_commitments_create_url
    assert_response :success
  end

  test "should get show" do
    get teams_targets_commitments_show_url
    assert_response :success
  end

  test "should get edit" do
    get teams_targets_commitments_edit_url
    assert_response :success
  end

  test "should get update" do
    get teams_targets_commitments_update_url
    assert_response :success
  end

  test "should get destroy" do
    get teams_targets_commitments_destroy_url
    assert_response :success
  end

end
