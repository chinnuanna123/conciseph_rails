# frozen_string_literal: true

json.data do
  json.results @support_needs do |support_need|
    json.partial! 'support_need', support_need: support_need
  end
end
json.status 'success'
