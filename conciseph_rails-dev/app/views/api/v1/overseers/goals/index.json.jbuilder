# frozen_string_literal: true

json.data do
  json.results @goals do |goal|
    json.partial! 'api/v1/overseers/shared/goal', goal: goal
  end

  json.partial! 'api/v1/overseers/shared/paginations', models: @goals
end

json.status 'success'
