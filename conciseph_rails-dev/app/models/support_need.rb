# frozen_string_literal: true

class SupportNeed < ApplicationRecord
  belongs_to :user

  validates :prefered_days, presence: true, if: -> { code == 'Prefer Day' }
  validates :prefered_times, presence: true, if: -> { code == 'Prefer Time' }

  enum code: {
    'No need for support services': 0,
    'Transportation': 1,
    'Food': 2,
    'Prefer Day': 3,
    'Prefer Time': 4,
    'Childcare': 5,
    'Language Translator': 6
  }
  
  # constant hashes
  PREFERED_TIMES_CODES = {
    '7am - 9am': 0,
    '9am - 5pm': 1,
    '5pm - 8pm': 2
  }.freeze

  PREFERED_DAYS_CODES = {
    "Monday": 0,
    "Tuesday": 1,
    "Wednesday": 2,
    "Thursday": 3,
    "Friday": 4,
    "Saturday": 5,
    "Sunday": 6
  }.freeze

  # methods to access keys from code array codes
  def prefered_days_names
    return nil unless code == 'Prefer Day'

    prefered_days.map { |day_code| PREFERED_DAYS_CODES.key(day_code) }
  end

  def prefered_times_names
    return nil unless code == 'Prefer Time'
    
    prefered_times.map { |time_code| PREFERED_TIMES_CODES.key(time_code) }
  end
end
