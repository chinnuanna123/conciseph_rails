# frozen_string_literal: true

json.data do
  json.results @health_events do |health_event|
    json.partial! 'api/v1/overseers/shared/goal', goal: health_event
  end

  json.partial! 'api/v1/overseers/shared/paginations', models: @health_events
end

json.status 'success'
