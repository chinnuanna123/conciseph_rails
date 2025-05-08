# frozen_string_literal: true

json.data do
  json.results @member_feedbacks do |member_feedback|
    json.partial! 'api/v1/overseers/shared/goal', goal: member_feedback
  end

  json.partial! 'api/v1/overseers/shared/paginations', models: @member_feedbacks
end

json.status 'success'
