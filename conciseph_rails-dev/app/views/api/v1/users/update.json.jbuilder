# frozen_string_literal: true

json.data do
  json.partial! 'user', user: @user
end

json.status 'success'
