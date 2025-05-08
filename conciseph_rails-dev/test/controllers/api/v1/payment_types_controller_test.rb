require 'test_helper'

class Api::V1::PaymentTypesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_v1_payment_types_index_url
    assert_response :success
  end

end
