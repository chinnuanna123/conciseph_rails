# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PetServiceProvider, type: :model do
  describe 'validations' do
    let!(:pet_service_provider) { create(:pet_service_provider, code: 'PET123', kind: :PERSON) }

    it 'is valid with valid attributes' do
      expect(pet_service_provider).to be_valid
    end

    it 'validates uniqueness of code scoped to kind' do
      duplicate_provider = build(:pet_service_provider, code: 'PET123', kind: :PERSON)
      expect(duplicate_provider).not_to be_valid
      expect(duplicate_provider.errors[:code]).to include('has already been taken')
    end

    it 'allows same code with a different kind' do
      different_kind_provider = build(:pet_service_provider, code: 'PET123', kind: :PET)
      expect(different_kind_provider).to be_valid
    end

    # it 'sets default kind to PERSON if not provided' do
    #   provider_without_kind = create(:pet_service_provider, code: 'PET456', kind: nil)
    #   expect(provider_without_kind.kind).to eq('PERSON')
    # end
  end
end
