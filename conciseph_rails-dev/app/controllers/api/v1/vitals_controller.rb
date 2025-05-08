# frozen_string_literal: true

module Api
  module V1
    class VitalsController < ApiController
      before_action :current_user_or_its_family_member, only: [:create]
      before_action :set_vital, only: :destroy
      def create
        @vital = Vital.new(vital_params)
        return if @vital.save

        render status: 500, json: { status: 'error', errors: @vital.errors.full_messages }
      end

      def destroy
        @vital.destroy

        if @vital.destroyed?
          render json: { message: 'Records destroyed successfully' }, status: :ok
        else
          render json: { errors: @vital.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def set_vital
        @vital = @user.vitals.find(params[:id])
      end

      def vital_params
        params.permit(:vital_type, :user_id, :type1, :type2, :type3, :vital_date, :value, :unit)
      end

      def current_user_or_its_family_member
        @user = User.find(params[:user_id])
        return if @user == current_user || current_user.family_members.include?(@user)

        render status: 500,
               json: { status: 'error',
                       errors: "user of id: #{params[:user_id]} is neither current user nor current_user's family_member" }
      end
    end
  end
end
