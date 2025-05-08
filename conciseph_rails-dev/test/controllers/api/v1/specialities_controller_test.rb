require 'test_helper'

class Api::V1::SpecialitiesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_v1_specialities_index_url
    assert_response :success
  end

end
