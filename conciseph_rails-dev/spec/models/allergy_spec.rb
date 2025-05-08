# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Allergy, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      allergy = Allergy.new(name: 'Pollen', code: 'ALGY123')
      expect(allergy).to be_valid
    end

    it 'is valid with a unique code' do
      create(:allergy, code: 'ALGY123')
      new_allergy = Allergy.new(name: 'Dust', code: 'ALGY456')
      expect(new_allergy).to be_valid
    end

    it 'is not valid with a duplicate code' do
      create(:allergy, code: 'ALGY123')
      duplicate_allergy = Allergy.new(name: 'Dust', code: 'ALGY123')
      expect(duplicate_allergy).not_to be_valid
      expect(duplicate_allergy.errors[:code]).to include('has already been taken')
    end
  end
end
