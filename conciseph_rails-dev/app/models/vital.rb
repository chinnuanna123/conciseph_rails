# frozen_string_literal: true

class Vital < ApplicationRecord
  belongs_to :user

  enum vital_type: {
    'Blood Pressure': 111,
    'BloodSugarHome': 112,
    'Blood Sugar Lab': 113,
    'Hbac': 114,
    'LdlLab': 115,
    'HeartRate': 116,
    'Oxidation': 117,
    'Temperature': 118,
    'Weight': 119
  }
end
