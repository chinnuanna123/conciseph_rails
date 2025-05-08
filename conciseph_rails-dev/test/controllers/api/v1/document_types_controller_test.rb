require 'test_helper'

class Api::V1::DocumentTypesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_v1_document_types_index_url
    assert_response :success
  end

end
