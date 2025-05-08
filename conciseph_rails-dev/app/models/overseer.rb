# frozen_string_literal: true

class Overseer < ApplicationRecord
  has_secure_password
  has_many :api_logs

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }
  validates :password_confirmation, presence: true, if: -> { password.present? }
  validates_confirmation_of :password

  attr_accessor :password_confirmation

  enum role: { api_consumer: 0, admin: 1 }
end
