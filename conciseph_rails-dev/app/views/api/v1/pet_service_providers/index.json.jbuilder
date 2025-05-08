# frozen_string_literal: true

json.data do
  json.results @pet_sevice_providers do |pet_sevice_provider|
    json.extract! pet_sevice_provider, :name, :code
    json.kind pet_sevice_provider.kind_before_type_cast
  end
end
json.status 'success'
