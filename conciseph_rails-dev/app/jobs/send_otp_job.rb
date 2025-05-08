class SendOtpJob < ApplicationJob
  queue_as :default

  def perform(user, otp)
    UserMailer.send_otp(user, otp).deliver_now
  rescue StandardError => e
    Rails.logger.error("Error sending mail: #{e.message}")
  end
end
