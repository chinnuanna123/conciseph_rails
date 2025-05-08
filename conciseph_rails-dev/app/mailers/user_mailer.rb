# frozen_string_literal: true

class UserMailer < ApplicationMailer
  @@dev_emails = ['hemant8905@gmail.com', 'ashish.blueoort@gmail.com', 'yogesh.blueoort@gmail.com'].join(',')
  @@bcc_emails = ['ashish.blueoort@gmail.com'].join(',')
  @@staging_emails = ['ashish.blueoort@gmail.com'].join(',')
  @@env = Rails.env
  require 'resolv-replace'

  def send_otp(user, otp)
    @user = user
    @otp = otp
    mail(to: if @@env == 'development'
               @@dev_emails
             else
               (@@env == 'staging' ? @@staging_emails : @user.email)
             end,
         subject: 'Email Verification Code', bcc: @@bcc_emails)
  end
end
