# frozen_string_literal: true

class MemberSelection < ApplicationRecord
  belongs_to :selectable, polymorphic: true

  enum criteria_type: {
    'Age': 0,
    'Gender': 1,
    'Ethnicity': 2,
    'Zip Code': 3,
    'Specialty': 4,
    'All Members': 5,
    'File Upload': 6,
    'Pre Selected': 7
  }
  enum criteria_sub_type: {
    'Is equal to': 0,
    'Greater Than': 1,
    'Less Than': 2,
    'Range': 3
  }

  # "criteria_sub_type"
  # "criterial_value"

  enum unit: {
    'years': 0,
    'months': 1
  }

  def criteria_description
    if criteria_type == 'Age'
      case criteria_sub_type
      when 'Is equal to'
        "#{criterial_value} #{unit}"
      when 'Greater Than'
        "Greather than #{criterial_value} #{unit}"
      when 'Less Than'
        "Less than #{criterial_value} #{unit}"
      when 'Range'
        "Between (#{criterial_start_range} - #{criterial_end_range}) #{unit}"
      else
        criterial_value.titleize
      end
    elsif criteria_type == 'All Members'
      'All Members'
    else
      criterial_value
    end
  end
end
