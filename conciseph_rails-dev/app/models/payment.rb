# frozen_string_literal: true

class Payment < ApplicationRecord
  belongs_to :user, optional: true
  after_create :assign_it_to_user

  def assign_it_to_user
    user = User.find_by_email(email)
    update_column(:user_id, user.id) if user.present?
  end
end
