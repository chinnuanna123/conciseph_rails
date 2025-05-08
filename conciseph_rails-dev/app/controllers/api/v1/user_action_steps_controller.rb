# app/controllers/api/v1/user_actions_controller.rb

# frozen_string_literal: true

module Api
  module V1
    class UserActionStepsController < ApiController
      before_action :authenticate_user!

      def update
        @user_action_step = UserActionStep.find(params[:id])

        unless @user_action_step.update(user_action_step_params)
          render status: 500, json: { status: 'error', errors: @user_action_step.errors.full_messages }
        end
        mark_in_progress(@user_action_step)
      rescue StandardError => e
        render status: 422, json: { status: 'error', error: [e] }
      end

      def mark_in_progress(step)
        user_action = step.user_action
        first_added_step = user_action.user_action_steps.first
        user_action.update(status: 'In Progress') if step == first_added_step
      end

      def user_action_step_params
        params.require(:user_action_step).permit(:action_taken).merge!(status: 'Completed')
      end
    end
  end
end
