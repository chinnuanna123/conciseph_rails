require 'test_helper'

class CustomTemplatesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @custom_template = custom_templates(:one)
  end

  test "should get index" do
    get custom_templates_url
    assert_response :success
  end

  test "should get new" do
    get new_custom_template_url
    assert_response :success
  end

  test "should create custom_template" do
    assert_difference('CustomTemplate.count') do
      post custom_templates_url, params: { custom_template: { category: @custom_template.category, description: @custom_template.description, icon: @custom_template.icon, name: @custom_template.name, section: @custom_template.section, template_type: @custom_template.template_type } }
    end

    assert_redirected_to custom_template_url(CustomTemplate.last)
  end

  test "should show custom_template" do
    get custom_template_url(@custom_template)
    assert_response :success
  end

  test "should get edit" do
    get edit_custom_template_url(@custom_template)
    assert_response :success
  end

  test "should update custom_template" do
    patch custom_template_url(@custom_template), params: { custom_template: { category: @custom_template.category, description: @custom_template.description, icon: @custom_template.icon, name: @custom_template.name, section: @custom_template.section, template_type: @custom_template.template_type } }
    assert_redirected_to custom_template_url(@custom_template)
  end

  test "should destroy custom_template" do
    assert_difference('CustomTemplate.count', -1) do
      delete custom_template_url(@custom_template)
    end

    assert_redirected_to custom_templates_url
  end
end
