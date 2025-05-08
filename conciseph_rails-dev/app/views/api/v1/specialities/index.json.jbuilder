# frozen_string_literal: true

json.data do
  json.results @specialities do |speciality|
    json.extract! speciality, :name, :code
    json.kind speciality.kind_before_type_cast
  end
end
json.status 'success'
