# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HealthEducation, type: :model do
  before do
    create(:user)
  end
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:health_education_type) }
    it { should validate_presence_of(:health_education_category) }
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

  # spec/models/health_education_spec.rb

  describe 'icon' do
    context 'when icon is attached' do
      let(:health_education_with_icon) { create(:health_education, :with_icon) }

      it 'returns the icon URL' do
        expect(health_education_with_icon.icon_url).to be_present
      end
    end

    context 'when icon is not attached' do
      let(:health_education) { create(:health_education) }
      it 'returns an empty string' do
        expect(health_education.icon_url).to eq('')
      end
    end
  end

  describe 'custom validation: date_checker' do
    it 'is valid when start_date is before end_date' do
      health_education = build(:health_education, owner: User.last, start_date: Date.today,
                                                  end_date: Date.today + 1.month)
      expect(health_education).to be_valid
    end

    it 'is invalid when start_date is after end_date' do
      health_education = build(:health_education, owner: User.last, start_date: Date.today + 1.month,
                                                  end_date: Date.today)
      expect(health_education).not_to be_valid
      expect(health_education.errors[:base]).to include('Start date should be before the end date')
    end
  end

  describe '#create_user_actions' do
    let(:health_education) { create(:health_education, owner: User.last, status: 'Active') }

    it 'triggers CreateUserActionsJob after save if health_education is active' do
      expect(CreateUserActionsJob).to receive(:perform_later).with(health_education)
      health_education.save!
    end

    it 'does not trigger CreateUserActionsJob if health_education is not active' do
      inactive_health_education = create(:health_education, owner: User.last, status: 'Draft')
      expect(CreateUserActionsJob).not_to receive(:perform_later)
      inactive_health_education.save!
    end
  end

  describe '.search' do
    let!(:user) { create(:user) }
    let!(:health_education1) { create(:health_education, owner: User.first, health_education_category: 'Nutrition') }
    let!(:health_education2) do
      create(:health_education, owner: user, health_education_category: 'Physical/Mental Health')
    end

    it 'returns health_educations based on the category' do
      result = HealthEducation.search(category: 'Nutrition')
      expect(result).to include(health_education1)
      expect(result).not_to include(health_education2)
    end
  end
end
