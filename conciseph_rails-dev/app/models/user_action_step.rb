# frozen_string_literal: true

class UserActionStep < ApplicationRecord
  before_save :set_status_to_complete
  belongs_to :action_step
  belongs_to :user_action
  belongs_to :user_action_milestone, optional: true
  after_save :mark_user_milestone_completed
  after_save :mark_user_milestone_in_progress

  validates :action_step_id, uniqueness: { scope: :user_action_id }
  validates :action_taken, inclusion: { in: %w[Ok Yes No], message: "must be 'Ok', 'Yes', or 'No'" }

  enum status: {
    'In Progress': 0,
    'Completed': 1
  }, _prefix: true

  enum action_taken: {
    'Ok': 0,
    'Yes': 1,
    'No': 2
  }

  def set_status_to_complete
    self.status = 'Completed' if action_taken.present?
  end

  def mark_user_milestone_in_progress
    return if ['In Progress', 'Completed'].include?(user_action_milestone.status)

    user_action_milestone.update(status: 'In Progress')
  end

  def mark_user_milestone_completed
    return unless user_action_milestone.present?

    completed_steps_count = user_action_milestone.user_action_steps.where(status: :Completed).count
    total_steps_count = user_action_milestone&.milestone&.action_steps&.size || 0
    user_action_milestone.update(status: 'Completed') if completed_steps_count == total_steps_count
  rescue StandardError => e
    Rails.logger.error("Error creating user goals: #{e.message}")
  end
end
