# frozen_string_literal: true

actionable = user_action.actionable

json.user_action_id user_action.id
json.extract! user_action, :actionable_id
json.extract! actionable, :name, :description
json.icon actionable.icon_url

json.status user_action.status
json.section actionable.section_before_type_cast
