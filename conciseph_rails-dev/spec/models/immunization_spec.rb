# frozen_string_literal: true

# spec/models/immunization_spec.rb
require 'rails_helper'

RSpec.describe Immunization, type: :model do
  let(:immunization) { create(:immunization) }

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(immunization).to be_valid
    end

    it 'is invalid with a duplicate code scoped by kind' do
      create(:immunization, code: 'DUP001', kind: Immunization.kinds[:PERSON])
      duplicate_immunization = build(:immunization, code: 'DUP001', kind: Immunization.kinds[:PERSON])
      expect(duplicate_immunization).not_to be_valid
    end

    it 'allows duplicate codes for different kinds' do
      create(:immunization, code: 'DUP002', kind: Immunization.kinds[:PERSON])
      different_kind_immunization = build(:immunization, code: 'DUP002', kind: Immunization.kinds[:PET])
      expect(different_kind_immunization).to be_valid
    end
  end

  describe 'enums' do
    it 'defines the correct enum values for kind' do
      expect(Immunization.kinds).to eq({ 'PERSON' => 0, 'PET' => 1 })
    end

    it 'allows kind to be set as PERSON' do
      immunization.kind = 'PERSON'
      expect(immunization.kind).to eq('PERSON')
    end

    it 'allows kind to be set as PET' do
      immunization.kind = 'PET'
      expect(immunization.kind).to eq('PET')
    end
  end
end
