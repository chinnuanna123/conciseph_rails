# frozen_string_literal: true

module UserActionsCounter
  extend ActiveSupport::Concern

  def user_actions_count
    user_actions.presence&.count || UserActions::CreateService.new(self, counter: true).call || 0
  end
end
