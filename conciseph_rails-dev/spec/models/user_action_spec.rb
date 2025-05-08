# frozen_string_literal: true

# spec/models/user_action_spec.rb
require 'rails_helper'

RSpec.describe UserAction, type: :model do
  let(:user) { create(:user) }
  let(:actionable) { create(:goal) } # Replace with actual model if needed
  let(:user_action) { create(:user_action, user: user, actionable: actionable) }

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:actionable) }
    it { should belong_to(:medication).optional }
    it { should have_many(:user_action_steps) }
    it { should accept_nested_attributes_for(:user_action_steps) }
  end

  describe 'enums' do
    it 'defines status enums' do
      expect(UserAction.statuses).to eq({
                                          'Not Started' => 0,
                                          'In Progress' => 1,
                                          'Completed' => 2
                                        })
    end

    it 'can set status to Completed' do
      user_action.status = 'Completed'
      expect(user_action.status).to eq('Completed')
    end
  end

  describe 'callbacks' do
    # You can add any callback tests if there are any
  end

  describe 'nested attributes' do
    it 'allows nested attributes for user_action_steps' do
      expect(user_action.user_action_steps.build).to be_a_new(UserActionStep)
    end
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(user_action).to be_valid
    end

    it 'is not valid without a user' do
      user_action.user = nil
      expect(user_action).to_not be_valid
    end

    it 'is not valid without actionable type and id' do
      user_action.actionable_type = nil
      expect(user_action).to_not be_valid
      user_action.actionable_id = nil
      expect(user_action).to_not be_valid
    end
  end
end
