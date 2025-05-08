# frozen_string_literal: true

json.data do
  json.results @payment_types do |payment_type|
    json.extract! payment_type, :name, :code
    json.kind payment_type.kind_before_type_cast
  end
end
json.status 'success'
