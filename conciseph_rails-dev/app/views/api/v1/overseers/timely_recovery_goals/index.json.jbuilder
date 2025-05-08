# frozen_string_literal: true

json.data do
  json.results @timely_recovery_goals do |timely_recovery_goal|
    json.partial! 'api/v1/overseers/shared/goal', goal: timely_recovery_goal
  end

  json.partial! 'api/v1/overseers/shared/paginations', models: @timely_recovery_goals
end

json.status 'success'
