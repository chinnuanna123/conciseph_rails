# frozen_string_literal: true

# spec/models/medication_spec.rb
require 'rails_helper'

RSpec.describe Medication, type: :model do
  let(:user) { create(:user) } # Assuming you have a User factory
  let(:medication) { create(:medication, user: user) }

  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:medication_timings).dependent(:destroy) }
    it { should have_many(:user_actions).dependent(:destroy) }
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(medication).to be_valid
    end

    it 'is invalid without a mobile_app_uuid' do
      medication.mobile_app_uuid = nil
      expect(medication).not_to be_valid
      expect(medication.errors[:mobile_app_uuid]).to include("can't be blank")
    end
  end

  describe 'enums' do
    it 'has the correct medication types' do
      expect(Medication.medication_types.keys).to include('tablet', 'syrup', 'injection', 'creame')
    end

    it 'has the correct dosage count cycle names' do
      expect(Medication.dosage_count_cycle_names.keys).to include('days', 'weeks')
    end

    it 'has the correct dosage cycle names' do
      expect(Medication.dosage_cycle_names.keys).to include('days', 'weeks')
    end

    it 'has the correct statuses' do
      expect(Medication.statuses.keys).to include('Not Started', 'On Track', 'Non Adherence')
    end
  end

  describe '#change_user_medication_adhere_status' do
    context 'when status is not "Not Started"' do
      before do
        medication.update(status: 'On Track')
      end

      it 'updates the user medication adhere status to "Adherence" if adherence percentage is 80% or more' do
        create(:medication, user: user, status: 'On Track')
        create(:medication, user: user, status: 'On Track')
        create(:medication, user: user, status: 'On Track')
        create(:medication, user: user, status: 'Non Adherence')
        medication.save

        expect(user.medication_adhere_status).to eq('Adherence')
      end

      it 'does not update the user medication adhere status if adherence percentage is less than 80%' do
        create(:medication, user: user, status: 'Non Adherence')
        user.update(medication_adhere_status: 'Non Adherence') # need to change_user_medication_adhere_status method
        medication.save

        expect(user.medication_adhere_status).not_to eq('Adherence')
      end
    end

    context 'when status is "Not Started"' do
      it 'does not update the user medication adhere status' do
        medication.update(status: 'Not Started')
        expect(user.medication_adhere_status).to eql('Not Started')
      end
    end
  end
end
