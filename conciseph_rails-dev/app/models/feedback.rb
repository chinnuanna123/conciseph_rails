# frozen_string_literal: true

class Feedback < ApplicationRecord
  belongs_to :user

  def self.search(params, code)
    user_ids = User.where('referred_by = ?', code).pluck(:id)
    query = 'user_id IN (:user_ids)'
    search_obj = {
      user_ids: user_ids
    }

    if params[:search].present?
      query = "#{query} AND " if query.present?
      query = "#{query}lower(message) like lower(:search)"
      search_obj[:search] = "%#{params[:search]}%"
    end

    Feedback.where(query, search_obj)
  end
end
