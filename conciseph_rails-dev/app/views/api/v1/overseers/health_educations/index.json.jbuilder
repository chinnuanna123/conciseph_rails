# frozen_string_literal: true

json.data do
  json.results @health_educations do |health_education|
    json.partial! 'api/v1/overseers/shared/goal', goal: health_education
  end

  json.partial! 'api/v1/overseers/shared/paginations', models: @health_educations
end

json.status 'success'
