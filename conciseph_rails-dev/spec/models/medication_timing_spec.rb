# frozen_string_literal: true

# spec/models/medication_timing_spec.rb
require 'rails_helper'

RSpec.describe MedicationTiming, type: :model do
  let(:medication) { create(:medication) }
  let(:medication_timing) { build(:medication_timing, medication: medication) }

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(medication_timing).to be_valid
    end

    it 'is not valid without a mobile_app_uuid' do
      medication_timing.mobile_app_uuid = nil
      expect(medication_timing).not_to be_valid
    end
  end

  describe 'callbacks' do
    context 'when saving medication timing' do
      it 'updates medication status to "Non Adherence" if there are consecutive nil taken_at' do
        create(:medication_timing, medication: medication, taken_at: nil)
        create(:medication_timing, medication: medication, taken_at: nil)

        medication_timing.save

        expect(medication.reload.status).to eq('Non Adherence')
      end

      it 'updates medication status to "On Track" if there are no consecutive nil taken_at' do
        create(:medication_timing, medication: medication, taken_at: Time.current)
        create(:medication_timing, medication: medication, taken_at: Time.current)

        medication_timing.save

        expect(medication.reload.status).to eq('On Track')
      end
    end
  end
end
