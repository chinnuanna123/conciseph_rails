# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApiController
      # skip_before_action :authenticate_user!, :only=>[:send_otp]
      before_action :set_user, only: [:update]
      before_action :set_family_member, only: [:add_or_update_family_members]
      def send_otp
        unless current_user.present?
          render status: 500, json: { status: 'error', errors: ['user does not exist'] }
          return true
        end
        current_user.save_and_send_generated_otp
      end

      def verify_otp
        unless current_user.present?
          render status: 500, json: { status: 'error', errors: ['user does not exist'] }
          return true
        end

        otp = RedisStorage.new.get(current_user.id)
        if otp.present? && otp.to_s == params[:otp_number].to_s
          current_user.update(otp_verified: true)
        else
          render status: 422, json: { status: 'error', errors: ['otp does not match'] }
          true
        end
      end

      def reset_password; end

      def update
        unless current_user.present? || (@user != current_user)
          render status: 500, json: { status: 'error', errors: ['user does not exist'] }
          return true
        end

        unless @user.update(user_params.merge!(birth_date_hash))
          render status: 422, json: { status: 'error', errors: @user.errors.full_messages }
          return true
        end
        @user.is_new_user = false
      end

      def family_members
        @family_head = current_user
        @family_members = @family_head.family_members
      end

      def add_or_update_family_members
        unless current_user.family_head_id.blank?
          render status: 500,
                 json: { status: 'error',
                         errors: 'current user is not family_head, only family_head can add family members' }
          return true
        end

        if @family_member.new_record?
          @family_member.family_head_id = current_user.id
          @family_member.password = (SecureRandom.base64(8))
          @family_member.email = user_params[:email].presence || "guest+#{rand(10_000_000...99_999_999)}@mail.com"
        end

        @family_member.assign_attributes(user_params.except(:email))

        return if @family_member.save

        render status: 422, json: { status: 'error', errors: @family_member.errors.full_messages }
      end

      private

      def set_user
        @user = User.find_by_id(params[:id])
      end

      def user_params
        params.permit(:name, :email, :phone, :gender, :gender_on_birth_certificates, :ethnicity,
                      :preferred_language, :zip_code, :height_ft, :height_inch, :blood_group, :fcm_token,
                      :onboarding_steps_completed)
      end

      def set_family_member
        @family_member = User.find_by(id: params[:id]).presence || User.find_by(email: user_params[:email]) || User.new
      end

      def birth_date_hash
        return {} unless params[:birth_date].present?

        birth_year = Date.parse(params[:birth_date]).year
        reporting_age = Date.today.year - birth_year
        {
          age_updated_at: Time.zone.now,
          reporting_age: reporting_age
        }
      end
    end
  end
end
