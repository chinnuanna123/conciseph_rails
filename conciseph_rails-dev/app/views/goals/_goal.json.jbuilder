json.extract! goal, :id, :name, :goal_type, :goal_category, :status, :start_date, :end_date, :criteria_type, :criterial_value, :created_at, :updated_at
json.url goal_url(goal, format: :json)
