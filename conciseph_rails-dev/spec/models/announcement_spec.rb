# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Announcement, type: :model do
  before do
    create(:user)
  end
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:announcement_type) }
    it { should validate_presence_of(:announcement_category) }
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

  # spec/models/announcement_spec.rb

  describe 'icon' do
    context 'when icon is attached' do
      let(:announcement_with_icon) { create(:announcement, :with_icon) }

      it 'returns the icon URL' do
        expect(announcement_with_icon.icon_url).to be_present
      end
    end

    context 'when icon is not attached' do
      let(:announcement) { create(:announcement) }
      it 'returns an empty string' do
        expect(announcement.icon_url).to eq('')
      end
    end
  end

  describe 'custom validation: date_checker' do
    it 'is valid when start_date is before end_date' do
      announcement = build(:announcement, owner: User.last, start_date: Date.today, end_date: Date.today + 1.month)
      expect(announcement).to be_valid
    end

    it 'is invalid when start_date is after end_date' do
      announcement = build(:announcement, owner: User.last, start_date: Date.today + 1.month, end_date: Date.today)
      expect(announcement).not_to be_valid
      expect(announcement.errors[:base]).to include('Start date should be before the end date')
    end
  end

  describe '#create_user_actions' do
    let(:announcement) { create(:announcement, owner: User.last, status: 'Active') }

    it 'triggers CreateUserActionsJob after save if announcement is active' do
      expect(CreateUserActionsJob).to receive(:perform_later).with(announcement)
      announcement.save!
    end

    it 'does not trigger CreateUserActionsJob if announcement is not active' do
      inactive_announcement = create(:announcement, owner: User.last, status: 'Draft')
      expect(CreateUserActionsJob).not_to receive(:perform_later)
      inactive_announcement.save!
    end
  end

  describe '.search' do
    let!(:user) { create(:user) }
    let!(:announcement1) { create(:announcement, owner: User.first, announcement_category: 'General') }
    let!(:announcement2) { create(:announcement, owner: user, announcement_category: 'Eligibility & Benefits') }

    it 'returns announcements based on the category' do
      result = Announcement.search(category: 'General')
      expect(result).to include(announcement1)
      expect(result).not_to include(announcement2)
    end
  end
end
