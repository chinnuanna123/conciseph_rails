# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TimelyRecoveryGoal, type: :model do
  before do
    create(:user)
  end
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:timely_recovery_goal_type) }
    it { should validate_presence_of(:timely_recovery_goal_category) }
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:section) }
  end

  # describe 'associations' do
  #   it { should belong_to(:owner).class_name('User') }
  #   it { should have_many(:action_steps).dependent(:destroy) }
  #   it { should have_many(:member_selections).dependent(:destroy) }
  #   it { should have_many(:user_actions).dependent(:destroy) }
  # end

  # spec/models/timely_recovery_goal_spec.rb

  describe 'icon' do
    context 'when icon is attached' do
      let(:timely_recovery_goal_with_icon) { create(:timely_recovery_goal, :with_icon) }

      it 'returns the icon URL' do
        expect(timely_recovery_goal_with_icon.icon_url).to be_present
      end
    end

    context 'when icon is not attached' do
      let(:timely_recovery_goal) { create(:timely_recovery_goal) }
      it 'returns an empty string' do
        expect(timely_recovery_goal.icon_url).to eq('')
      end
    end
  end

  describe '.search' do
    let!(:user) { create(:user) }
    let!(:timely_recovery_goal1) do
      create(:timely_recovery_goal, owner: User.first, timely_recovery_goal_category: 'Follow Up Care')
    end
    let!(:timely_recovery_goal2) do
      create(:timely_recovery_goal, owner: user, timely_recovery_goal_category: 'Medication Refill')
    end

    it 'returns timely_recovery_goals based on the category' do
      result = TimelyRecoveryGoal.search(category: 'Follow Up Care')
      expect(result).to include(timely_recovery_goal1)
      expect(result).not_to include(timely_recovery_goal2)
    end
  end
end
