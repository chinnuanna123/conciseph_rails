
  class SessionsController <  Devise::SessionsController
    # before_action :require_no_authentication, only: [:new, :create]
    skip_before_action :ensure_otp_verified, only: %i[create otp_verification verify_otp destroy resend_otp]
    def create
      # super 
      if current_user.present?
        current_user.save_and_send_generated_otp
        redirect_to(otp_verification_path)
      end
    end

    def otp_verification
    end

    def verify_otp
      otp_record = fetch_otp_from_redis 
      if otp_record == params[:otp].to_s
        session[:otp_verified] = true
        sign_in(current_user)
        # reset_session # Regenerate session ID
        redirect_to after_sign_in_path_for(current_user), notice: 'Signed in successfully.'
      elsif otp_record != params[:otp].to_s
        flash[:alert] = "OTP Doesn't Match"
        render :otp_verification
      elsif otp_record.blank?
        flash[:alert] = "OTP Expired"
        render :otp_verification
      end
    end

    def resend_otp
      current_user.save_and_send_generated_otp
      redirect_to( otp_verification_path)
    end

    def fetch_otp_from_redis
      record = RedisStorage.new.get(current_user.id)     
      record
    end
  end
