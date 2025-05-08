# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Refer, type: :model do
  let(:owner) { create(:user) }  # Assuming you have a User factory

  describe 'validations' do
    subject { Refer.new(name: name, no_of_users: no_of_users, code: code, owner: owner) }

    context 'when all attributes are present' do
      let(:name) { 'Sample Refer' }
      let(:no_of_users) { 10 }
      let(:code) { 'REFCODE' }

      it 'is valid with valid attributes' do
        expect(subject).to be_valid
      end
    end

    context 'when name is nil' do
      let(:name) { nil }
      let(:no_of_users) { 5 }
      let(:code) { 'REFCODE' }

      it 'is not valid without a name' do
        expect(subject).to_not be_valid
        expect(subject.errors[:name]).to include("can't be blank")
      end
    end

    context 'when no_of_users is nil' do
      let(:name) { 'Sample Refer' }
      let(:no_of_users) { nil }
      let(:code) { 'REFCODE' }

      it 'is not valid without no_of_users' do
        expect(subject).to_not be_valid
        expect(subject.errors[:no_of_users]).to include("can't be blank")
      end
    end

    context 'when code is nil' do
      let(:name) { 'Sample Refer' }
      let(:no_of_users) { 5 }
      let(:code) { nil }

      it 'is not valid without a code' do
        expect(subject).to_not be_valid
        expect(subject.errors[:code]).to include("can't be blank")
      end
    end

    context 'when code is not unique' do
      before { create(:refer, code: 'UNIQUECODE') }
      let(:name) { 'Sample Refer' }
      let(:no_of_users) { 5 }
      let(:code) { 'UNIQUECODE' }

      it 'is not valid with a duplicate code' do
        expect(subject).to_not be_valid
        expect(subject.errors[:code]).to include('has already been taken')
      end
    end
  end

  describe 'associations' do
    it { should have_many(:users).with_foreign_key('referred_by').class_name('User') }
    it { should belong_to(:owner).class_name('User').optional }
  end

  describe '#generate_code' do
    it 'generates a unique code' do
      refer = Refer.new(name: 'Test', no_of_users: 5)
      refer.generate_code
      expect(refer.code).to match(/[A-Z0-9]{8}/)
    end
  end
end
