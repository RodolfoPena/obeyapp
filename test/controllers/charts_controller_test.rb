require 'test_helper'

class ChartsControllerTest < ActionDispatch::IntegrationTest
  test "should get commitment_level" do
    get charts_commitment_level_url
    assert_response :success
  end

end
