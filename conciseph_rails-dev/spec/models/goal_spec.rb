# frozen_string_literal: true

# spec/models/goal_spec.rb
require 'rails_helper'

RSpec.describe Goal, type: :model do
  before do
    create(:user)
  end
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:goal_type) }
    it { should validate_presence_of(:goal_category) }
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

  # spec/models/goal_spec.rb

  describe 'icon' do
    context 'when icon is attached' do
      let(:goal_with_icon) { create(:goal, :with_icon) }

      it 'returns the icon URL' do
        expect(goal_with_icon.icon_url).to be_present
      end
    end

    context 'when icon is not attached' do
      let(:goal) { create(:goal) }
      it 'returns an empty string' do
        expect(goal.icon_url).to eq('')
      end
    end
  end

  describe 'custom validation: date_checker' do
    it 'is valid when start_date is before end_date' do
      goal = build(:goal, owner: User.last, start_date: Date.today, end_date: Date.today + 1.month)
      expect(goal).to be_valid
    end

    it 'is invalid when start_date is after end_date' do
      goal = build(:goal, owner: User.last, start_date: Date.today + 1.month, end_date: Date.today)
      expect(goal).not_to be_valid
      expect(goal.errors[:base]).to include('Start date should be before the end date')
    end
  end

  describe '#create_user_actions' do
    let(:goal) { create(:goal, owner: User.last, status: 'Active') }

    it 'triggers CreateUserActionsJob after save if goal is active' do
      expect(CreateUserActionsJob).to receive(:perform_later).with(goal)
      goal.save!
    end

    it 'does not trigger CreateUserActionsJob if goal is not active' do
      inactive_goal = create(:goal, owner: User.last, status: 'Draft')
      expect(CreateUserActionsJob).not_to receive(:perform_later)
      inactive_goal.save!
    end
  end

  describe '.search' do
    let!(:user) { create(:user) }
    let!(:goal1) { create(:goal, owner: User.first, goal_category: 'Well Child Care') }
    let!(:goal2) { create(:goal, owner: user, goal_category: 'ED Follow Ups') }

    it 'returns goals based on the category' do
      result = Goal.search(category: 'Well Child Care')
      expect(result).to include(goal1)
      expect(result).not_to include(goal2)
    end
  end
end
