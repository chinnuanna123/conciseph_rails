# frozen_string_literal: true

# see http://www.emilsoman.com/blog/2013/05/18/building-a-tested/
module DeviseTokenAuth
  class SessionsController < DeviseTokenAuth::ApplicationController
    before_action :downcase_params
    before_action :set_user_by_token, only: [:destroy]
    after_action :reset_session, only: [:destroy]

    def new
      render_new_error
    end

    def create
      render_create_error_bad_credentials
      # # Check
      # field = (resource_params.keys.map(&:to_sym) & [:phone]).first
      # # .
      # @resource = nil
      # if field
      #   q_value = get_case_insensitive_field_from_resource_params(field)

      #   field = (field == :phone) ? :phone : field
      #   @resource = find_resource(field, q_value)

      # end
      # if @resource && valid_params?(field, q_value) && (!@resource.respond_to?(:active_for_authentication?) || @resource.active_for_authentication?)
      #   valid_password = (resource_params[:otp_number] == @resource.otp_number)

      #   if (@resource.respond_to?(:valid_for_authentication?) && !@resource.valid_for_authentication? { valid_password }) || !valid_password
      #     return render_create_error_bad_credentials
      #   end

      #   @token = @resource.create_token
      #   @resource.otp_verified =true
      #   @resource.save

      #   sign_in(:user, @resource, store: false, bypass: false)

      #   yield @resource if block_given?

      #   render_create_success
      # elsif @resource && !(!@resource.respond_to?(:active_for_authentication?) || @resource.active_for_authentication?)
      #   if @resource.respond_to?(:locked_at) && @resource.locked_at
      #     render_create_error_account_locked
      #   else
      #     render_create_error_not_confirmed
      #   end
      # else
      #   render_create_error_bad_credentials
      # end
    end

    def destroy
      # remove auth instance variables so that after_action does not run
      #
      user = remove_instance_variable(:@resource) if @resource
      client = @token.client if @token.client
      @token.clear!

      if user && client && user.tokens[client]
        user.tokens.delete(client)
        user.fcm_token = nil
        user.save!

        yield user if block_given?

        render_destroy_success
      else
        render_destroy_error
      end
    end

    protected

    def valid_params?(key, val)
      (resource_params[:password] && key && val) || (resource_params[:otp_number] && key && val)
    end

    def get_auth_params
      auth_key = nil
      auth_val = nil

      # iterate thru allowed auth keys, use first found
      resource_class.authentication_keys.each do |k|
        next unless resource_params[k]

        auth_val = resource_params[k]
        auth_key = k
        break
      end

      # honor devise configuration for case_insensitive_keys
      auth_val.downcase! if resource_class.case_insensitive_keys.include?(auth_key)

      { key: auth_key, val: auth_val }
    end

    def render_new_error
      render_error(405, I18n.t('devise_token_auth.sessions.not_supported'))
    end

    def render_create_success
      render json: {
        data: resource_data(resource_json: @resource.token_validation_response)
      }
    end

    def render_create_error_not_confirmed
      render_error(401, I18n.t('devise_token_auth.sessions.not_confirmed', email: @resource.email))
    end

    def render_create_error_account_locked
      render_error(401, I18n.t('devise.mailer.unlock_instructions.account_lock_msg'))
    end

    def render_create_error_bad_credentials
      render_error(401, I18n.t('devise_token_auth.sessions.bad_credentials'))
    end

    def render_destroy_success
      render json: {
        success: true
      }, status: 200
    end

    def render_destroy_error
      render_error(404, I18n.t('devise_token_auth.sessions.user_not_found'))
    end

    private

    def resource_params
      params.permit(*params_for_resource(:sign_in) << :phone, :otp_number)
    end

    def downcase_params
      params.transform_keys! { |key| key.to_s.underscore }
    end
  end
end
