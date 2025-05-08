require 'test_helper'

class Api::V1::SymptomsControllerTest < ActionDispatch::IntegrationTest
  test "should get :index" do
    get api_v1_symptoms_:index_url
    assert_response :success
  end

end
