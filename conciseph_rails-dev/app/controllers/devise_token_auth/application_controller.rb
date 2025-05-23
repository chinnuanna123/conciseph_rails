# frozen_string_literal: true

module DeviseTokenAuth
  class ApplicationController < DeviseController
    include DeviseTokenAuth::Concerns::SetUserByToken

    def resource_data(_opts = {})
      response = JSON.parse(
        ApplicationController.render(partial: '/api/v1/users/user', locals: { user: @resource })
      )

      response['current_plan'] = @resource.current_plan if @resource.current_plan.present?
      response['type'] = @resource.class.name.parameterize if json_api?
      response
    end

    def resource_errors
      @resource.errors.full_messages
    end

    protected

    def blacklisted_redirect_url?(redirect_url)
      DeviseTokenAuth.redirect_whitelist && !DeviseTokenAuth::Url.whitelisted?(redirect_url)
    end

    def build_redirect_headers(access_token, client, redirect_header_options = {})
      {
        DeviseTokenAuth.headers_names[:"access-token"] => access_token,
        DeviseTokenAuth.headers_names[:client] => client,
        :config => params[:config],

        # Legacy parameters which may be removed in a future release.
        # Consider using "client" and "access-token" in client code.
        # See: github.com/lynndylanhurley/devise_token_auth/issues/993
        :client_id => client,
        :token => access_token
      }.merge(redirect_header_options)
    end

    def params_for_resource(resource)
      devise_parameter_sanitizer.instance_values['permitted'][resource].each do |type|
        params[type.to_s] ||= request.headers[type.to_s] unless request.headers[type.to_s].nil?
      end
      devise_parameter_sanitizer.instance_values['permitted'][resource]
    end

    def resource_class(m = nil)
      mapping = if m
                  Devise.mappings[m]
                else
                  Devise.mappings[resource_name] || Devise.mappings.values.first
                end

      mapping.to
    end

    def json_api?
      return false unless defined?(ActiveModel::Serializer)

      if ActiveModel::Serializer.respond_to?(:setup)
        return ActiveModel::Serializer.setup do |config|
          config.adapter == :json_api
        end
      end
      ActiveModelSerializers.config.adapter == :json_api
    end

    def recoverable_enabled?
      resource_class.devise_modules.include?(:recoverable)
    end

    def confirmable_enabled?
      resource_class.devise_modules.include?(:confirmable)
    end

    def render_error(status, message, data = nil)
      response = {
        success: false,
        errors: [message]
      }
      response = response.merge(data) if data
      render json: response, status: status
    end
  end
end
