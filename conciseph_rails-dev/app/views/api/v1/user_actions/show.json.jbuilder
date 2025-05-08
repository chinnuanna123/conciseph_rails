# frozen_string_literal: true

json.data do
  json.results do
    json.partial! 'user_action', user_action: @user_action

    json.action_steps @action_steps do |action_step|
      user_action_step = @user_action_steps[action_step.id]
      json.action_step_id action_step.id

      if user_action_step.present?
        json.user_action_step_id user_action_step[:id]
        json.status user_action_step[:status]
      else
        json.user_action_step_id 0
        json.status "Not Started"
      end

      json.extract! action_step, :name, :message, :action, :interaction, :artifact_type, :artifact_url
      if action_step.artifact_type == 'document'
        json.artifact_url action_step.artifact_document.attached? ? Rails.application.routes.url_helpers.url_for(action_step.artifact_document) : ''
      elsif action_step.artifact_type == 'video'
        json.artifact_url action_step.artifact_video.attached? ? Rails.application.routes.url_helpers.url_for(action_step.artifact_video) : ''
      end
    end
  end
end
json.status 'success'
