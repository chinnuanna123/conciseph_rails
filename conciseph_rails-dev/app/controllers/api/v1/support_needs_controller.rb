# frozen_string_literal: true

module Api
  module V1
    class SupportNeedsController < ApiController
      before_action :set_user, only: %i[create index]
      before_action :set_support_needs, only: %i[destroy]
      def index
        @support_needs = SupportNeed.where(user_id: @user.id)
      end

      def create
        @support_need = SupportNeed.new(support_need_params.merge!(user_id: @user.id))
        return if @support_need.save

        render status: 500, json: { status: 'error', errors: @support_need.errors.full_messages }
      end

      def destroy
        @support_need.destroy

        if @support_need.destroyed?
          render json: { message: 'Records destroyed successfully' }, status: :ok
        else
          render json: { errors: @support_need.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def set_support_needs
        @support_need = SupportNeed.find(params[:id])
      end

      def support_need_params
        params.permit(:code, prefered_days: [], prefered_times: [])
      end

      def set_user
        if params[:family_member_id].present? && !current_user.family_members.pluck(:id).include?(params[:family_member_id].to_i)
          render json: { status: 401, error: 'not a family member of current user' }, status: 401
        end
        @user = User.find_by(id: params[:family_member_id]) || current_user
      end
    end
  end
end
