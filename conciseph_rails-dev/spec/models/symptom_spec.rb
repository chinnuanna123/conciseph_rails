# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Symptom, type: :model do
  describe 'validations' do
    subject { build(:symptom) }

    it 'validates uniqueness of code scoped to kind' do
      symptom1 = create(:symptom, code: 'C001', kind: :PERSON)
      symptom2 = build(:symptom, code: 'C001', kind: :PERSON)
      symptom3 = build(:symptom, code: 'C001', kind: :PET)

      expect(symptom2).not_to be_valid
      expect(symptom2.errors[:code]).to include('has already been taken')

      expect(symptom3).to be_valid
    end
  end
end
