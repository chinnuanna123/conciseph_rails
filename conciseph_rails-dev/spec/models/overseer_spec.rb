# frozen_string_literal: true

# spec/models/overseer_spec.rb
require 'rails_helper'

RSpec.describe Overseer, type: :model do
  subject { build(:overseer) }

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without a name' do
      subject.name = nil
      expect(subject).not_to be_valid
      expect(subject.errors[:name]).to include("can't be blank")
    end

    it 'is not valid without an email' do
      subject.email = nil
      expect(subject).not_to be_valid
      expect(subject.errors[:email]).to include("can't be blank")
    end

    it 'is not valid with a duplicate email' do
      create(:overseer, email: subject.email)
      expect(subject).not_to be_valid
      expect(subject.errors[:email]).to include('has already been taken')
    end

    it 'is not valid with an invalid email' do
      subject.email = 'invalid_email'
      expect(subject).not_to be_valid
      expect(subject.errors[:email]).to include('is invalid')
    end

    it 'is not valid without a password for a new record' do
      subject.password = nil
      expect(subject).not_to be_valid
      expect(subject.errors[:password]).to include("can't be blank")
    end

    it 'is not valid with a short password' do
      subject.password = '12345'
      subject.password_confirmation = '12345'
      expect(subject).not_to be_valid
      expect(subject.errors[:password]).to include('is too short (minimum is 6 characters)')
    end

    it 'is not valid if password and password_confirmation do not match' do
      subject.password_confirmation = 'differentpassword'
      expect(subject).not_to be_valid
      expect(subject.errors[:password_confirmation]).to include("doesn't match Password")
    end
  end

  describe 'associations' do
    it { is_expected.to have_many(:api_logs) }
  end

  describe 'roles' do
    it 'has the role api_consumer by default' do
      expect(subject.role).to eq('api_consumer')
    end

    it 'can be assigned the admin role' do
      subject.role = :admin
      expect(subject.role).to eq('admin')
    end
  end
end
