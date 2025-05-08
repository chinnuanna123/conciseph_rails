# frozen_string_literal: true

class UserActionMilestone < ApplicationRecord
  belongs_to :user_action
  belongs_to :milestone
  has_many :user_action_steps, dependent: :destroy
  after_save :mark_user_action_in_progress
  after_save :change_user_action_status

  accepts_nested_attributes_for :user_action_steps, allow_destroy: true

  validates :milestone_id, uniqueness: { scope: :user_action_id }

  enum status: {
    'Not Started': 0,
    'In Progress': 1,
    'Completed': 2
  }, _prefix: true

  def mark_user_action_in_progress
    return if user_action.present? && ['In Progress', 'Completed'].include?(user_action.status)
    user_action.update(status: 'In Progress') if status === 'In Progress'
  end

  def change_user_action_status
    return unless user_action.present? && user_action.user_action_milestones.present?

    completed_steps_count = user_action.user_action_milestones.where(status: 'Completed').count
    total_steps_count = user_action&.actionable&.milestones&.size || 0
    if completed_steps_count == total_steps_count
      user_action.update(status: 'Completed', completion_date: Time.zone.now)
    end
  rescue StandardError => e
    Rails.logger.error("Error creating user goals: #{e.message}")
  end
end
