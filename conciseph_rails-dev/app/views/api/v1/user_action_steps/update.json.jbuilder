# frozen_string_literal: true

json.data do
  json.extract! @user_action_step, :id, :status
end
json.status 'success'
