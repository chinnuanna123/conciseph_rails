# frozen_string-literal: true

class SendFcmMessagesJob < ApplicationJob
  queue_as :default

  def perform(user_action)
    user = user_action.user
    title = TITLE[user_action.actionable_type.to_sym]
    body = user_action.actionable.name
    data = {
      page: title.downcase.gsub(' ', '_'),
      section: user_action.actionable.section,
      id: user_action.id.to_s
    }
    ::FcmService::SendFcm.new(user, title, body, data).call
  rescue StandardError => e
    Rails.logger.error("Error sending Fcm message: #{e.message}")
  end
end
