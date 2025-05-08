# frozen_string_literal: true

class Refer < ApplicationRecord
  validates :name, :no_of_users, :code, presence: true
  validates :code, presence: true
  has_many :users, foreign_key: 'referred_by', class_name: 'User'
  belongs_to :owner, foreign_key: 'owner_id', class_name: 'User', optional: true

  validates :code, uniqueness: true
  # before_create :generate_code

  rails_admin do
    field :name
    field :no_of_users
    field :code
    field :owner

    list do
      field :code
    end
  end

  def generate_code
    require 'securerandom'
    self.code = SecureRandom.alphanumeric.first(8).upcase
  end
end
