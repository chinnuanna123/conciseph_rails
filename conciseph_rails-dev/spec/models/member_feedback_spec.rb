# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MemberFeedback, type: :model do
  before do
    create(:user)
  end
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:member_feedback_type) }
    it { should validate_presence_of(:member_feedback_category) }
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

  # spec/models/member_feedback_spec.rb

  describe 'icon' do
    context 'when icon is attached' do
      let(:member_feedback_with_icon) { create(:member_feedback, :with_icon) }

      it 'returns the icon URL' do
        expect(member_feedback_with_icon.icon_url).to be_present
      end
    end

    context 'when icon is not attached' do
      let(:member_feedback) { create(:member_feedback) }
      it 'returns an empty string' do
        expect(member_feedback.icon_url).to eq('')
      end
    end
  end

  describe 'custom validation: date_checker' do
    it 'is valid when start_date is before end_date' do
      member_feedback = build(:member_feedback, owner: User.last, start_date: Date.today,
                                                end_date: Date.today + 1.month)
      expect(member_feedback).to be_valid
    end

    it 'is invalid when start_date is after end_date' do
      member_feedback = build(:member_feedback, owner: User.last, start_date: Date.today + 1.month,
                                                end_date: Date.today)
      expect(member_feedback).not_to be_valid
      expect(member_feedback.errors[:base]).to include('Start date should be before the end date')
    end
  end

  describe '#create_user_actions' do
    let(:member_feedback) { create(:member_feedback, owner: User.last, status: 'Active') }

    it 'triggers CreateUserActionsJob after save if member_feedback is active' do
      expect(CreateUserActionsJob).to receive(:perform_later).with(member_feedback)
      member_feedback.save!
    end

    it 'does not trigger CreateUserActionsJob if member_feedback is not active' do
      inactive_member_feedback = create(:member_feedback, owner: User.last, status: 'Draft')
      expect(CreateUserActionsJob).not_to receive(:perform_later)
      inactive_member_feedback.save!
    end
  end

  describe '.search' do
    let!(:user) { create(:user) }
    let!(:member_feedback1) { create(:member_feedback, owner: User.first, member_feedback_category: 'Care') }
    let!(:member_feedback2) { create(:member_feedback, owner: user, member_feedback_category: 'Service') }

    it 'returns member_feedbacks based on the category' do
      result = MemberFeedback.search(category: 'Care')
      expect(result).to include(member_feedback1)
      expect(result).not_to include(member_feedback2)
    end
  end
end
