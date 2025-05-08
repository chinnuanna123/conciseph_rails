# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Speciality, type: :model do
  describe 'validations' do
    let!(:speciality) { create(:speciality, code: 'SPEC123', kind: :PERSON) }

    it 'is valid with valid attributes' do
      expect(speciality).to be_valid
    end

    it 'validates uniqueness of code scoped to kind' do
      duplicate_speciality = build(:speciality, code: 'SPEC123', kind: :PERSON)
      expect(duplicate_speciality).not_to be_valid
      expect(duplicate_speciality.errors[:code]).to include('has already been taken')
    end

    it 'allows same code with a different kind' do
      different_kind_speciality = build(:speciality, code: 'SPEC123', kind: :PET)
      expect(different_kind_speciality).to be_valid
    end

    # it 'sets default kind to PERSON if not provided' do
    #   speciality_without_kind = create(:speciality, code: 'SPEC456', kind: nil)
    #   expect(speciality_without_kind.kind).to eq('PERSON')
    # end
  end
end
