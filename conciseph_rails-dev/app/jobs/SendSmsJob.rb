# frozen_string_literal: true

class SendSmsJob
  include SuckerPunch::Job
  def perform(_user)
    require 'rest-client'
    p 'send otp logic will come here'
  end
end
