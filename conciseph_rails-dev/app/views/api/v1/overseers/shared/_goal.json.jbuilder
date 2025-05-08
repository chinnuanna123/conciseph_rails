json.extract! goal, :name, "#{goal.class&.to_s&.underscore}_category".to_sym, :status
if !goal.instance_of?(TimelyRecoveryGoal)
  json.start_date format_date(goal.start_date)
  json.end_date format_date(goal.end_date)
end

json.members goal.user_actions.eager_load(:user) do |user_action|
   
    json.member_name user_action.user.name || ''
    json.goal_status user_action.actionable.status
    json.acknowledgment_date format_date_time(user_action.acknowledge_at) || ''
    json.action_name user_action.actionable.name
    json.action_status user_action.status
    json.member_last_action_date format_date_time(user_action.user.last_seen_at) || ''

end