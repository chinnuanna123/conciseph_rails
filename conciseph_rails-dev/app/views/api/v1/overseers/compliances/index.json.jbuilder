# frozen_string_literal: true

json.data do
  json.results @compliances do |compliance|
    json.partial! 'compliance', compliance: compliance
  end

  json.partial! 'api/v1/overseers/shared/paginations', models: @compliances
end

json.status 'success'
