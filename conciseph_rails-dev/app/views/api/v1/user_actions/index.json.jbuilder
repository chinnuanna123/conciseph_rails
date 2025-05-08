# frozen_string_literal: true

json.data do
  json.results @user_actions do |user_action|
    json.partial! 'user_action', user_action: user_action
  end

  json.partial! 'paginations', user_actions: @user_actions
 
end

json.status 'success'
