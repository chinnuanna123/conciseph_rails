require 'test_helper'

class Api::V1::InsuranceTypeControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_v1_insurance_type_index_url
    assert_response :success
  end

end
