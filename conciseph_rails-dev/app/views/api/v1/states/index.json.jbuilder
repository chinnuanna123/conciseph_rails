# frozen_string_literal: true

json.data do
  json.results @states do |state|
    json.extract! state, :name
  end
end
json.status 'success'
