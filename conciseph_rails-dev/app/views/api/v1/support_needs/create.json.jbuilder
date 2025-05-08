# frozen_string_literal: true

json.data do
  json.results do
    json.partial! 'support_need', support_need: @support_need
  end
end
json.status 'success'
