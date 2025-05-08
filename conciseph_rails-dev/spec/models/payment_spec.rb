# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Payment, type: :model do
  describe 'associations' do
    it { should belong_to(:user).optional }
  end

  describe 'callbacks' do
    it 'assigns a user after creation' do
      user = create(:user, email: 'test@example.com') # Ensure you have a user factory
      payment = Payment.create(amount: 100.00, currency: 'USD', email: user.email)

      expect(payment.user).to eq(user)
    end

    it 'does not assign user if email is nil' do
      payment = Payment.create(amount: 100.00, currency: 'USD', email: nil)

      expect(payment.user).to be_nil
    end

    it 'does not assign user if email does not exist' do
      payment = Payment.create(amount: 100.00, currency: 'USD', email: 'nonexistent@example.com')

      expect(payment.user).to be_nil
    end
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      user = create(:user, email: 'test@example.com')
      payment = Payment.new(amount: 100.00, currency: 'USD', email: user.email)
      expect(payment).to be_valid
    end
  end
end
