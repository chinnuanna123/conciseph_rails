# frozen_string_literal: true

class Member < ApplicationRecord
  validates_presence_of :member_id, :name, :email, :phone
  validates :member_id, :email, uniqueness: true
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/ }
  validate :date_format_checker
  belongs_to :user, optional: true

  def date_format_checker
    return unless birth_date.present?

    begin
      parsed_date = Date.parse(birth_date)
      self.birth_date = parsed_date.strftime('%Y-%m-%d') # Convert to standard format for storage
      if parsed_date.year < 1900 || parsed_date.year > Date.current.year
        errors.add(:birth_date, 'is not in a valid range')
      else
        self.birth_date = parsed_date
      end
    rescue ArgumentError => e
      errors.add(:base, 'invalid Date')
      puts "Invalid date: #{birth_date}"
    end
  end

  def self.search(params)
    search_obj = {}

    if params[:search].present?
      query = 'lower(name) like lower(:search) or lower(email) like lower(:search) or zip_code like :search'
      search_obj[:search] = "%#{params[:search]}%"
    end
    Member.where(query, search_obj)
  end
end
