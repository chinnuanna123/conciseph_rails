require "application_system_test_case"

class GoalsTest < ApplicationSystemTestCase
  setup do
    @goal = goals(:one)
  end

  test "visiting the index" do
    visit goals_url
    assert_selector "h1", text: "Goals"
  end

  test "creating a Goal" do
    visit goals_url
    click_on "New Goal"

    fill_in "Criteria type", with: @goal.criteria_type
    fill_in "Criterial value", with: @goal.criterial_value
    fill_in "End date", with: @goal.end_date
    fill_in "Goal category", with: @goal.goal_category
    fill_in "Goal type", with: @goal.goal_type
    fill_in "Name", with: @goal.name
    fill_in "Start date", with: @goal.start_date
    fill_in "Status", with: @goal.status
    click_on "Create Goal"

    assert_text "Goal was successfully created"
    click_on "Back"
  end

  test "updating a Goal" do
    visit goals_url
    click_on "Edit", match: :first

    fill_in "Criteria type", with: @goal.criteria_type
    fill_in "Criterial value", with: @goal.criterial_value
    fill_in "End date", with: @goal.end_date
    fill_in "Goal category", with: @goal.goal_category
    fill_in "Goal type", with: @goal.goal_type
    fill_in "Name", with: @goal.name
    fill_in "Start date", with: @goal.start_date
    fill_in "Status", with: @goal.status
    click_on "Update Goal"

    assert_text "Goal was successfully updated"
    click_on "Back"
  end

  test "destroying a Goal" do
    visit goals_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Goal was successfully destroyed"
  end
end
