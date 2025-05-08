# frozen_string_literal: true

class UserGoalsController < ApplicationController
  before_action :set_user, only: [:show]

  def show
    @user = @user_goal.user
    @goal_action_step_user_goals = @user_goal.goal_action_step_user_goals
    respond_to do |format|
      format.js
    end
  end

  private

  def set_user
    @user_goal = UserGoal.find(params[:id])
  end
end
