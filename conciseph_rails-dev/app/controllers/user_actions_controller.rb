# frozen_string_literal: true

class UserActionsController < ApplicationController
  before_action :set_user, only: [:show]

  def show
    @user = @user_action.user
    goal = @user_action.actionable

    @milestones = goal.milestones
    @action_steps = goal.action_steps.with_relevant_attachment.order(created_at: :asc).group_by(&:milestone_id)

    @user_milestones = UserActionMilestone.where(milestone_id: @milestones, user_action_id:@user_action.id).pluck(:milestone_id, :status).to_h

    @user_action_steps = UserActionStep.where(action_step_id: goal.action_steps.pluck(:id), user_action_id: @user_action.id).pluck(:action_step_id, :status, :created_at).to_h { |key, *values| [key, values] }
    respond_to(&:js)
  end

  private

  def set_user
    @user_action = UserAction.eager_load(:user).find(params[:id])
  end
end
