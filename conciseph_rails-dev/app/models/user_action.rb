# frozen_string_literal: true

class UserAction < ApplicationRecord
  belongs_to :user
  belongs_to :actionable, polymorphic: true
  belongs_to :medication, optional: true
  has_many :user_action_milestones
  has_many :user_action_steps, through: :user_action_milestones
  accepts_nested_attributes_for :user_action_milestones, allow_destroy: true
  accepts_nested_attributes_for :user_action_steps, allow_destroy: true

  def save_user_action_steps(attributes)
    milestone_id = ActionStep.find(attributes[:user_action_steps_attributes].first[:action_step_id]).milestone.id
    user_action_milestone = UserActionMilestone.where(milestone_id: milestone_id,
                                                      user_action_id: id).first_or_initialize
    attributes[:user_action_steps_attributes].each do |step_attributes|
      step_attributes[:user_action_id] ||= id # Ensure user_action_id is set for each step
    end
    user_action_milestone.update(attributes) # hitting this method again with same id will give error as record already exists
  end

  enum status: {
    'Not Started': 0,
    'In Progress': 1,
    'Completed': 2
  }, _prefix: true

  def self.search(params)
    user_actions = UserAction.includes(:user).where(actionable_id: params[:id],
                                                                 actionable_type: params[:controller].singularize.camelcase)
    return user_actions if params[:label].nil?

    label = params[:label]
    dataset_label = params[:datasetLabel]
    value = params[:value]
    status = if dataset_label.include?('Completed')
               2
             elsif dataset_label.include?('In Progress')
               1
             else
               0
             end
    milestone_id = params[:milestone_id].to_i
    user_actions = UserAction.left_joins(:user_action_milestones).where(actionable_id: params[:id], actionable_type: params[:controller].singularize.camelcase).where(
      'user_action_milestones.status = :status AND  user_action_milestones.milestone_id = :milestone_id ', { status: status,
                                                                                                             milestone_id: milestone_id }
    )
  end
end
