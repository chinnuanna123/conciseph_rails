# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PaymentType, type: :model do
  describe 'validations' do
    let!(:payment_type) { create(:payment_type, code: 'PAY123', kind: :PERSON) }

    it 'is valid with valid attributes' do
      expect(payment_type).to be_valid
    end

    it 'validates uniqueness of code scoped to kind' do
      duplicate_payment_type = build(:payment_type, code: 'PAY123', kind: :PERSON)
      expect(duplicate_payment_type).not_to be_valid
      expect(duplicate_payment_type.errors[:code]).to include('has already been taken')
    end

    it 'allows same code with a different kind' do
      different_kind_payment_type = build(:payment_type, code: 'PAY123', kind: :PET)
      expect(different_kind_payment_type).to be_valid
    end
  end
end
