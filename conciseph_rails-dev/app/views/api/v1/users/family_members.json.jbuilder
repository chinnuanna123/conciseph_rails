# frozen_string_literal: true

json.data do
  json.family_members @family_members do |family_member|
    json.partial! 'user', user: family_member
  end
end
json.status 'success'
