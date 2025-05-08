# frozen_string_literal: true

# spec/models/vital_spec.rb
require 'rails_helper'

RSpec.describe Vital, type: :model do
  let(:user) { create(:user) }
  let(:vital) { build(:vital, user: user) }

  describe 'associations' do
    it 'belongs to a user' do
      expect(vital).to respond_to(:user)
    end
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(vital).to be_valid
    end

    it 'is not valid without a user' do
      vital.user = nil
      expect(vital).not_to be_valid
    end
  end

  describe 'enum values' do
    it 'has correct vital types' do
      expect(Vital.vital_types.keys).to contain_exactly(
        'Blood Pressure',
        'BloodSugarHome',
        'Blood Sugar Lab',
        'Hbac',
        'LdlLab',
        'HeartRate',
        'Oxidation',
        'Temperature',
        'Weight'
      )
    end
  end
end
