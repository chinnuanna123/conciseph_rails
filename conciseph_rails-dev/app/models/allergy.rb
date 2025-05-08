# frozen_string_literal: true

class Allergy < ApplicationRecord
  validates :code, uniqueness: true
end
