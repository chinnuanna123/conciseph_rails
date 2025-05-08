# frozen_string_literal: true

json.data do
  json.results @immunizations do |immunization|
    json.extract! immunization, :name, :code
    json.kind immunization.kind_before_type_cast
  end
end
json.status 'success'
