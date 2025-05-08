require "application_system_test_case"

class CustomTemplatesTest < ApplicationSystemTestCase
  setup do
    @custom_template = custom_templates(:one)
  end

  test "visiting the index" do
    visit custom_templates_url
    assert_selector "h1", text: "Custom Templates"
  end

  test "creating a Custom template" do
    visit custom_templates_url
    click_on "New Custom Template"

    fill_in "Category", with: @custom_template.category
    fill_in "Description", with: @custom_template.description
    fill_in "Icon", with: @custom_template.icon
    fill_in "Name", with: @custom_template.name
    fill_in "Section", with: @custom_template.section
    fill_in "Template type", with: @custom_template.template_type
    click_on "Create Custom template"

    assert_text "Custom template was successfully created"
    click_on "Back"
  end

  test "updating a Custom template" do
    visit custom_templates_url
    click_on "Edit", match: :first

    fill_in "Category", with: @custom_template.category
    fill_in "Description", with: @custom_template.description
    fill_in "Icon", with: @custom_template.icon
    fill_in "Name", with: @custom_template.name
    fill_in "Section", with: @custom_template.section
    fill_in "Template type", with: @custom_template.template_type
    click_on "Update Custom template"

    assert_text "Custom template was successfully updated"
    click_on "Back"
  end

  test "destroying a Custom template" do
    visit custom_templates_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Custom template was successfully destroyed"
  end
end
