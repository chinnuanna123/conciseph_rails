# frozen_string_literal: true

class MedicationTiming < ApplicationRecord
  belongs_to :medication

  validates :mobile_app_uuid, presence: true
  after_save :update_medication_status

  def update_medication_status
    consecutive_pair = consecutive_nil(medication.medication_timings)
    if consecutive_pair.present?
      medication.update(status: 'Non Adherence')
    else
      medication.update(status: 'On Track')
    end
  end

  def consecutive_nil(medication_timings)
    return true if medication_timings.count == 1 && medication_timings.where(taken_at: nil).present?

    consecutive_pair = medication_timings.each_cons(2)
    consecutive_pair.find { |pair| pair.all? { |mt| mt.taken_at.nil? } }
  end
end
