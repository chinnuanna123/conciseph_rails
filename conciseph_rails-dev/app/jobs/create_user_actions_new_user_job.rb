# frozen_string_literal: true

class CreateUserActionsNewUserJob < ApplicationJob
  def perform(user)
    ::UserActions::CreateServiceNewUser.new(user).call
  end
end
