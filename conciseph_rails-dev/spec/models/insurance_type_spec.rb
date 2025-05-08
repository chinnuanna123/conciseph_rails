# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InsuranceType, type: :model do
  describe 'validations' do
    let!(:insurance_type) { create(:insurance_type, code: 'INS123') }

    it 'is valid with valid attributes' do
      expect(insurance_type).to be_valid
    end

    it 'validates uniqueness of code' do
      duplicate_insurance_type = build(:insurance_type, code: 'INS123')
      expect(duplicate_insurance_type).not_to be_valid
      expect(duplicate_insurance_type.errors[:code]).to include('has already been taken')
    end

    it 'is valid with a different code' do
      unique_insurance_type = build(:insurance_type, code: 'INS456')
      expect(unique_insurance_type).to be_valid
    end
  end
end
