# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :ensure_otp_verified, unless: :json_request?

  skip_before_action :authenticate_user!, if: :devise_controller?
  skip_before_action :verify_authenticity_token, if: :devise_controller?
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :decrypt_data, if: :devise_controller? && :json_request?
  after_action :encrypt_data, if: :devise_controller? && :json_request?
  before_action :check_valid_ips

  # include DeviseTokenAuth::Concerns::SetUserByToken

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name phone email referred_by])
  end

  def encrypt_data
    if request.headers['request-from'].present? && request.headers['request-from'] == 'ios'
      # response.body= {data: response.body}.to_json
    else
      result = encrypt(response.body, '1f8c1e5ed0f621d1a8e155e9227ab497')
      data, iv, salt = result
      response.headers['iv'] = iv.force_encoding('ISO-8859-1').encode('UTF-8')
      response.headers['salt'] = salt.force_encoding('ISO-8859-1').encode('UTF-8')
      response.body = { data: data }.to_json
    end
  end

  def decrypt_data
    if request.headers['request-from'].present? && request.headers['request-from'] == 'ios'
      # raw_data = request.body.read
      # if raw_data.present?
      #   data = JSON.parse(raw_data)
      #   params.merge!(data['data'])
      # end
    else
      raw_data = request.body.read
      if raw_data.present?
        data = JSON.parse(raw_data)
        iv = request.headers['iv']
        salt = request.headers['salt']
        res = decrypt(data['data'], iv, salt)
        params.merge!(res)
      end
    end
  end

  def check_super_admin
    # binding.pry
    redirect_to rails_admin_path if current_user.super_admin
  end

  def current_ability
    @current_ability ||= if current_user.super_admin == true
                           Abilities::SuperAdminAbility.new(current_user, params)
                         elsif current_user.is_admin == true
                           Abilities::AdminAbility.new(current_user, params)
                         end
  end

  # def decrypt(encrypted_data, iv,salt)
  #     iv =Base64.decode64(iv)
  #     salt =Base64.decode64(salt)
  #     encrypted_data =Base64.decode64(encrypted_data)

  #     cipher = OpenSSL::Cipher.new('AES-128-CBC')
  #     cipher.key = OpenSSL::PKCS5.pbkdf2_hmac_sha1('1f8c1e5ed0f621d1a8e155e9227ab497', salt, 1024, 16)
  #     cipher.iv = iv
  #     cipher.decrypt
  #     data = cipher.update(encrypted_data)
  #     data << cipher.final
  #     JSON.parse(data)
  # end

  def decrypt(encrypted_data, iv, salt)
    iv = Base64.decode64(iv)
    salt = Base64.decode64(salt)
    encrypted_data = Base64.decode64(encrypted_data)

    cipher = OpenSSL::Cipher.new('AES-128-CBC')
    cipher.decrypt
    key_iv = OpenSSL::PKCS5.pbkdf2_hmac_sha1('1f8c1e5ed0f621d1a8e155e9227ab497', salt, 1024,
                                             cipher.key_len + cipher.iv_len)
    key = key_iv[0, cipher.key_len]
    cipher.key = key
    cipher.iv = iv
    data = cipher.update(encrypted_data)
    data << cipher.final
    JSON.parse(data)
  end

  def encrypt(string, pwd)
    @salt = OpenSSL::Random.random_bytes(16)
    # prepare cipher for encryption
    e = OpenSSL::Cipher.new('AES-128-CBC')
    e.encrypt
    # next, generate a PKCS5-based string for your key + initialization vector
    key_iv = OpenSSL::PKCS5.pbkdf2_hmac_sha1(pwd, @salt, 1024, e.key_len + e.iv_len)
    key = key_iv[0, e.key_len]
    @iv = key_iv[e.key_len, e.iv_len]
    # now set the key and iv for the encrypting cipher
    e.key = key
    e.iv  = @iv
    # encrypt the data!
    encrypted = String.new << e.update(string) << e.final
    [encrypted, @iv, @salt].map { |v| ::Base64.strict_encode64(v) }
  end

  def check_valid_ips
    # render file: "#{Rails.root}/public/404.html", layout: false, status: 404 if !json_request? and "45.79.74.107" != request.remote_ip
  end

  def after_sign_in_path_for(_resource)
    dashboard_new_path
  end

  def set_charts_data(resource)
    @milestone_data = Chart::MilestoneData.new.milestone_data(resource)
    @outreach_and_completion_data = Chart::DonutChart.new(resource).call
  end

  protected

  def json_request?
    request.format.json?
  end

  private
  
  def redirect_path(controller_name, record)
    if send("#{controller_name.singularize}_params")[:save_to_draft] == 'true'
      send("#{controller_name}_path")
    else
      send(
        "review_#{controller_name.singularize}_path", record
        )
    end
  end
    
  def ensure_otp_verified
    if user_signed_in? && session[:otp_verified].blank?
      # Redirect to OTP verification page if OTP is not verified
      redirect_to otp_verification_path, alert: 'Please verify your OTP before accessing this page.'
    end
  end
    
  def set_members_hash(resource_instance)
    @members_hash = if params[:link_to_id].present?
      params.slice(:link_to_id, :link_to_type, :milestone_id, :milestone_status)
    elsif action_name == 'edit' && resource_instance.member_selections.last.criteria_type == 'Pre Selected'
      member_selection = resource_instance.member_selections.last
      member_selection.slice(:link_to_id, :link_to_type, :milestone_id, :milestone_status)
    end

    # action_name == 'edit' && @announcement.member_selections.last.criteria_type == 'Pre selected'
      #   member_selection = @announcement.member_selections.last
  end
end
