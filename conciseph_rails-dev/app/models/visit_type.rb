# frozen_string_literal: true

class VisitType < ApplicationRecord
  validates :code, uniqueness: true
end
