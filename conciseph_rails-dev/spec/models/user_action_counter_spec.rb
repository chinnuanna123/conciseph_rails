# frozen_string_literal: true

# spec/models/user_actions_counter_spec.rb

require 'rails_helper'

RSpec.describe UserActionsCounter do
  # Create a dummy class to include the UserActionsCounter module
  class DummyClass
    include UserActionsCounter

    attr_accessor :user_actions

    def initialize(user_actions = nil)
      @user_actions = user_actions
    end
  end

  describe '#user_actions_count' do
    let(:dummy_instance) { DummyClass.new }

    context 'when user_actions is present' do
      it 'returns the count of user_actions' do
        dummy_instance.user_actions = %w[action1 action2 action3]
        expect(dummy_instance.user_actions_count).to eq(3)
      end
    end

    context 'when user_actions is empty' do
      it 'calls the CreateService and returns the result' do
        allow(UserActions::CreateService).to receive(:new).and_return(double(call: 5))
        dummy_instance.user_actions = []

        expect(dummy_instance.user_actions_count).to eq(5)
      end
    end

    context 'when user_actions is nil' do
      it 'calls the CreateService and returns zero when the service returns nil' do
        allow(UserActions::CreateService).to receive(:new).and_return(double(call: nil))
        dummy_instance.user_actions = nil

        expect(dummy_instance.user_actions_count).to eq(0)
      end
    end

    context 'when user_actions is empty and the service returns nil' do
      it 'returns zero' do
        allow(UserActions::CreateService).to receive(:new).and_return(double(call: nil))
        dummy_instance.user_actions = []

        expect(dummy_instance.user_actions_count).to eq(0)
      end
    end
  end
end
