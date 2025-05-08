# frozen_string_literal: true

class ApiController < ApplicationController
  # protect_from_forgery with: :exception
  protect_from_forgery with: :null_session
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token, if: :json_request?
  skip_before_action :authenticate_user!, if: :devise_controller?
  skip_before_action :verify_authenticity_token, if: :devise_controller?
  before_action :decrypt_data, if: :json_request?
  after_action :encrypt_data, if: :json_request?
  before_action :ensure_json_request
  before_action :update_last_seen_at

  include DeviseTokenAuth::Concerns::SetUserByToken
  respond_to :json

  def ensure_json_request
    return if request.format.json?

    render nothing: true, status: 406
  end

  def update_last_seen_at
    return unless current_user

    current_user.update(last_seen_at: Time.now)
  end

  def current_ability
    @current_ability ||= Abilities::UserAbility.new(current_user, params)
  end
end
