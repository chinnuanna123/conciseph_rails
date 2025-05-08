# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Compliance, type: :model do
  before do
    create(:user)
  end
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:compliance_type) }
    it { should validate_presence_of(:compliance_category) }
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:start_date) }
    it { should validate_presence_of(:end_date) }
    it { should validate_presence_of(:section) }
  end

  # describe 'associations' do
  #   it { should belong_to(:owner).class_name('User') }
  #   it { should have_many(:action_steps).dependent(:destroy) }
  #   it { should have_many(:member_selections).dependent(:destroy) }
  #   it { should have_many(:user_actions).dependent(:destroy) }
  # end

  # spec/models/compliance_spec.rb

  describe 'icon' do
    context 'when icon is attached' do
      let(:compliance_with_icon) { create(:compliance, :with_icon) }

      it 'returns the icon URL' do
        expect(compliance_with_icon.icon_url).to be_present
      end
    end

    context 'when icon is not attached' do
      let(:compliance) { create(:compliance) }
      it 'returns an empty string' do
        expect(compliance.icon_url).to eq('')
      end
    end
  end

  describe 'custom validation: date_checker' do
    it 'is valid when start_date is before end_date' do
      compliance = build(:compliance, owner: User.last, start_date: Date.today, end_date: Date.today + 1.month)
      expect(compliance).to be_valid
    end

    it 'is invalid when start_date is after end_date' do
      compliance = build(:compliance, owner: User.last, start_date: Date.today + 1.month, end_date: Date.today)
      expect(compliance).not_to be_valid
      expect(compliance.errors[:base]).to include('Start date should be before the end date')
    end
  end

  describe '#create_user_actions' do
    let(:compliance) { create(:compliance, owner: User.last, status: 'Active') }

    it 'triggers CreateUserActionsJob after save if compliance is active' do
      expect(CreateUserActionsJob).to receive(:perform_later).with(compliance)
      compliance.save!
    end

    it 'does not trigger CreateUserActionsJob if compliance is not active' do
      inactive_compliance = create(:compliance, owner: User.last, status: 'Draft')
      expect(CreateUserActionsJob).not_to receive(:perform_later)
      inactive_compliance.save!
    end
  end

  describe '.search' do
    let!(:user) { create(:user) }
    let!(:compliance1) { create(:compliance, owner: User.first, compliance_category: 'Care Utilization') }
    let!(:compliance2) { create(:compliance, owner: user, compliance_category: 'Care Access') }

    it 'returns compliances based on the category' do
      result = Compliance.search(category: 'Care Utilization')
      expect(result).to include(compliance1)
      expect(result).not_to include(compliance2)
    end
  end
end
