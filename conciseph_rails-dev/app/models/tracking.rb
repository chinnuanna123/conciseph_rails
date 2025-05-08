# frozen_string_literal: true

class Tracking < ApplicationRecord
  belongs_to :user
  validates :tracking_for, presence: true
  CODES = { USERS: 100, VISITS: 101, DIAGNOSIS: 102, MEDICATIONS: 103,
            SYMPTOMS: 104, DOCUMENTS: 105, PAYMENTS: 106 }.freeze

  enum tracking_for: CODES
  validates :tracking_for,
            exclusion: { in: CODES.values,
                         message: '%{value} is not a valid code ' }

  def self.search(params, code)
    user_ids = User.where('referred_by = ?', code).pluck(:id)
    query = 'user_id IN (:user_ids)'
    search_obj = {
      user_ids: user_ids
    }

    if params[:search].present?
      query = "#{query} AND " if query.present?
      query = "#{query}(lower(users.email) like lower(:search) OR lower(users.name) like lower(:search) "
      search_obj[:search] = "%#{params[:search].strip}%"

      if Tracking.tracking_fors.key?(params[:search].upcase)
        query = "#{query} OR " if query.present?
        query = "#{query}tracking_for = :tracking_for"
        search_obj[:tracking_for] = Tracking.tracking_fors[params[:search]]
      end
      query += ')'
    end

    Tracking.joins(:user).where(query, search_obj)
  end
end
