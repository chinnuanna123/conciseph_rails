# frozen_string_literal: true

module Api
  module V1
    module Overseers
      class ApiController < ApiController
        skip_before_action :authenticate_user!, :decrypt_data
        skip_after_action :encrypt_data
        before_action :authenticate_overseer
        before_action :log_request
        after_action :log_response

        private

        def authenticate_overseer
          token = request.headers['Authorization']&.split(' ')&.last
          if token
            begin
              decoded_token = decode_token(token)
              @current_overseer = Overseer.find_by(id: decoded_token[:overseer_id])
              render json: { error: 'Unauthorized' }, status: :unauthorized unless @current_overseer
            rescue JWT::DecodeError
              render json: { error: 'Invalid token' }, status: :unauthorized
            rescue JWT::ExpiredSignature
              render json: { error: 'Token has expired' }, status: :unauthorized
            rescue JWT::VerificationError
              render json: { error: 'Invalid token' }, status: :unauthorized
            end
          else
            render json: { error: 'Token not provided' }, status: :unauthorized
          end
        end

        def decode_token(token)
          decoded = JWT.decode(token, Rails.application.secrets.secret_key_base, true, { algorithm: 'HS256' })
          HashWithIndifferentAccess.new(decoded[0])
        end

        def log_request
          @api_log = ApiLog.create!(
            url: request.url,
            payload: request.request_parameters,
            request_ip: request.remote_ip,
            overseer_id: @current_overseer&.id || Overseer.find_by(email: params[:email])&.id
          )
        end

        def log_response
          @api_log.update(
            response_code: response.status,
            response_body: parse_response_body(response.body)
          )
        end

        def parse_response_body(body)
          JSON.parse(body)
        rescue StandardError
          body
        end
      end
    end
  end
end
