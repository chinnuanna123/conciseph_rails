# frozen_string_literal: true

json.data do
  json.results do
    json.partial! 'vital', vital: @vital
  end
end
json.status 'success'
