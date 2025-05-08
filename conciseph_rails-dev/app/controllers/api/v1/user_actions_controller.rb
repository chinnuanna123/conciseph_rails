# frozen_string_literal: true

module Api
  module V1
    class UserActionsController < ApiController
      before_action :authenticate_user!
      before_action :set_user, only: %i[update]
      before_action :set_user_or_family_member, only: %i[action_plans announcements feedbacks]

      def action_plans
        @user_actions = UserActions::FetchListingService.new(params, @user, 'action_plans').call

        render status: :ok
      end

      def announcements
        @user_actions = UserActions::FetchListingService.new(params, @user, 'announcements').call

        render status: :ok
      end

      def feedbacks
        @user_actions = UserActions::FetchListingService.new(params, @user, 'feedbacks').call

        render status: :ok
      end

      def update
        # unless @user_action.update(user_action_params)
        unless @user_action.save_user_action_steps(user_action_params)
          render status: 500, json: { status: 'error', errors: @user_action.errors.full_messages }
        end
      rescue ActionController::ParameterMissing => e
        render status: 400, json: { status: 'error', message: e.message }
      end

      def show
        @user_action = UserAction.find(params[:id])
        @user_action.update(acknowledge_at: Date.today) if @user_action.acknowledge_at.blank?
        @actionable = @user_action.actionable
        @action_steps = @actionable.action_steps.order(created_at: :asc)
        @user_action_steps = {}

        @user_action.user_action_steps.each do |user_action_step|
          @user_action_steps[user_action_step.action_step_id] = {
            id: user_action_step.id,
            status: user_action_step.status
          }
        end
      end

      private

      def set_user_or_family_member
        @user = User.find_by(id: params[:family_member_id]).presence || current_user
      end

      def set_user
        @user_action = UserAction.find(params[:id])
      end

      def user_action_params
        params.permit(user_action_steps_attributes: %i[id action_step_id action_taken])
      end
    end
  end
end
