# frozen_string-literal: true

class CreateUserActionsJob < ApplicationJob
  queue_as :default

  def perform(actionable)
    ::UserActions::CreateService.new(actionable).call
  rescue StandardError => e
    Rails.logger.error("Error creating user goals: #{e.message}")
  end
end
