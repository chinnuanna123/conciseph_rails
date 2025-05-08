# frozen_string_literal: true

class ApiLog < ApplicationRecord
  belongs_to :overseer

  validates :url, :request_ip, presence: true
end
