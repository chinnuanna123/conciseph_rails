# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'noreply@conciseph.com'
  layout 'mailer'
end
