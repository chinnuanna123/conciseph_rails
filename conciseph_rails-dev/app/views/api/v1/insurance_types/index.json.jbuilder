# frozen_string_literal: true

json.data do
  json.results @insurance_types do |insurance_type|
    json.extract! insurance_type, :name, :code
  end
end
json.status 'success'
