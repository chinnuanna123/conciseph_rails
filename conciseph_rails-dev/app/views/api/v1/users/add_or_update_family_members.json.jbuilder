# frozen_string_literal: true

json.data do
  json.partial! 'user', user: @family_member
end
json.status 'success'
