# frozen_string_literal: true

module Api
  module V1
    class TimelyRecoveryGoalsController < ApiController
      before_action :set_timely_recovery_goal
      def create
        @user_action = @timely_recovery_goal.user_actions.build(timely_recovery_goal_params)
        existing_action_milestones = @user_action.user_action_milestones.pluck(:milestone_id)
        @timely_recovery_goal.milestones.each do |milestone|
          next if existing_action_milestones.include?(milestone.id)

          @user_action.user_action_milestones.build(milestone_id: milestone.id)
        end
        
        if @user_action.save
          SendFcmMessagesJob.perform_later(@user_action)
          return
        end

        render status: 500, json: { status: 'error', errors: @user_action.errors.full_messages }
      end

      def set_timely_recovery_goal
        @timely_recovery_goal = TimelyRecoveryGoal.find_by(timely_recovery_goal_category: params[:timely_recovery_goal_category])
      end

      def timely_recovery_goal_params
        params.permit(:user_id, :medication_id)
      end
    end
  end
end
