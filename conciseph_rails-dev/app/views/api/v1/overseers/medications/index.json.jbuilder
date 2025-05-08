# frozen_string_literal: true

json.data do
  json.results @medications do |medication|
    json.partial! 'medication', medication: medication
  end

  json.partial! 'api/v1/overseers/shared/paginations', models: @medications
end

json.status 'success'
