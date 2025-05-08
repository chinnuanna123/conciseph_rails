# frozen_string_literal: true

json.data do
  json.results @symptoms do |symptom|
    json.extract! symptom, :name, :code
    json.kind symptom.kind_before_type_cast
  end
end
json.status 'success'
