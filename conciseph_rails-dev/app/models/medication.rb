# frozen_string_literal: true

class Medication < ApplicationRecord
  attr_accessor :delete_medication_timings

  has_many :medication_timings, dependent: :destroy
  has_many :user_actions, dependent: :destroy
  belongs_to :user

  after_save :change_user_medication_adhere_status

  accepts_nested_attributes_for :medication_timings, allow_destroy: true

  validates :mobile_app_uuid, presence: true

  enum medication_type: {
    'tablet': 1,
    'syrup': 2,
    'injection': 3,
    'creame': 4
  }

  enum dosage_count_cycle_name: {
    'days': 1,
    'weeks': 2
  }

  enum dosage_cycle_name: {
    'days': 1,
    'weeks': 2
  }, _prefix: true

  enum status: {
    'Not Started': 0,
    'On Track': 1,
    'Non Adherence': 2
  }

  def change_user_medication_adhere_status
    return if status == 'Not Started'

    status_hash = user.medications.group(:status).count
    percent = status_hash['On Track'].to_f / (status_hash['Non Adherence'].to_f + status_hash['On Track'].to_f)
    user.update(medication_adhere_status: 'Adherence') if percent >= 0.80
  end
end
