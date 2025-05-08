# frozen_string_literal: true

module Api
  module V1
    module Overseers
      class OverseerAuthController < Api::V1::Overseers::ApiController
        skip_before_action :authenticate_overseer

        def login
          overseer = Overseer.find_by(email: params[:email])
          if overseer&.authenticate(params[:password])
            token = generate_token(overseer)
            render json: { token: token }, status: :ok
          else
            render json: { error: 'Invalid credentials' }, status: :unauthorized
          end
        end

        private

        def generate_token(overseer)
          payload = { overseer_id: overseer.id, exp: 10.minutes.from_now.to_i }
          JWT.encode(payload, Rails.application.secrets.secret_key_base, 'HS256')
        end
      end
    end
  end
end
