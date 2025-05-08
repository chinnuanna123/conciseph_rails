# frozen_string_literal: true

json.data do
  json.results @document_types do |document_type|
    json.extract! document_type, :name, :code

    json.kind document_type.kind_before_type_cast
  end
end
json.status 'success'
