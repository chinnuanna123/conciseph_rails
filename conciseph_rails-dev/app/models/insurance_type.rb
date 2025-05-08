# frozen_string_literal: true

class InsuranceType < ApplicationRecord
  validates :code, uniqueness: true
end
