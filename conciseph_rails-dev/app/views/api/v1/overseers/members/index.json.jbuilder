# frozen_string_literal: true

json.data do
  json.results @members do |member|
    json.partial! 'member', member: member
  end

  json.partial! 'api/v1/overseers/shared/paginations', models: @members
end

json.status 'success'
