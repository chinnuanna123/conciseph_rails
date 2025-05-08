require 'test_helper'

class Api::V1::AllergiesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_v1_allergies_index_url
    assert_response :success
  end

end
