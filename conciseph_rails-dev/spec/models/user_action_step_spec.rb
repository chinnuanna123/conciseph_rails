# frozen_string_literal: true

# spec/models/user_action_step_spec.rb
require 'rails_helper'

RSpec.describe UserActionStep, type: :model do
  let(:user_action) { create(:user_action) }
  let(:action_step) { create(:action_step) }
  let(:user_action_step) do
    create(:user_action_step, user_action: user_action, action_step: action_step, status: 'In Progress')
  end

  describe '#set_status_to_complete' do
    context 'when action_taken is present' do
      it 'sets the status to Completed' do
        user_action_step.action_taken = 'Yes'
        user_action_step.save
        expect(user_action_step.status).to eq('Completed')
      end
    end
  end

  describe '#change_user_action_status' do
    context 'when user_action is present' do
      before do
        # user_action_step.user_action = user_action
      end

      it 'updates the user action status to Completed when all steps are completed' do
        create(:user_action_step, user_action: user_action) # all three steps completed
        create(:user_action_step, user_action: user_action)
        user_action_step.save

        expect(user_action.reload.status).to eq('Completed')
        expect(user_action.completion_date).not_to be_nil
      end

      it 'does not update the user action status when not all steps are completed' do
        user_action_step.save
        # only one completed
        expect(user_action.reload.status).not_to eq('Completed')
      end
    end

    context 'when user_action is not present' do
      it 'does not perform any action' do
        user_action_step.user_action = nil
        expect { user_action_step.change_user_action_status }.not_to raise_error
      end
    end

    #   context 'when an exception is raised during update' do
    #     it 'logs an error message' do
    #       allow(user_action).to receive(:user_action_steps).and_return([user_action_step])
    #       allow(user_action).to receive(:actionable).and_return(double('Goal', action_steps: [double]))
    #       allow(user_action).to receive(:update).and_raise(StandardError.new("Update failed"))

    #       # Expectation for the logger to receive an error message
    #       expect(Rails.logger).to receive(:error).with("Error creating user goals: Update failed")

    #       # Call the method under test
    #       user_action_step.change_user_action_status
    #     end
    #   end
  end

  describe '#mark_user_action_in_progress' do
    context 'when user_action is present and status is not In Progress or Completed' do
      it 'updates the user action status to In Progress' do
        user_action.update(status: nil)
        user_action_step.mark_user_action_in_progress
        expect(user_action.reload.status).to eq('In Progress')
      end
    end

    context 'when the status is already In Progress or Completed' do
      it 'does not update the user action status' do
        user_action.update(status: 'In Progress')
        user_action_step.mark_user_action_in_progress
        expect(user_action.reload.status).to eq('In Progress')

        user_action.update(status: 'Completed')
        user_action_step.mark_user_action_in_progress
        expect(user_action.reload.status).to eq('Completed')
      end
    end

    # context 'when user_action is not present' do
    #   it 'does not perform any action' do
    #     user_action_step.user_action = nil
    #     expect { user_action_step.mark_user_action_in_progress }.not_to raise_error
    #   end
    # end
  end
end
