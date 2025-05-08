# frozen_string_literal: true

json.data do
  json.results @announcements do |announcement|
    json.partial! 'api/v1/overseers/shared/goal', goal: announcement
  end

  json.partial! 'api/v1/overseers/shared/paginations', models: @announcements
end

json.status 'success'
