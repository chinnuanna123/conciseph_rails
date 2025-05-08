# frozen_string_literal: true

json.data do
  json.messgae 'success'
  json.otp_number current_user.otp_number if Rails.env == 'development'
end

json.status 'success'
