# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GoalDuplication::GoalDuplicationByGoalIdService do
  let(:goal) { create(:goal, :with_icon, name: 'Test Goal') }
  let(:milestone) { create(:milestone, milestonable: goal) }
  let(:member_selections) do
    [
      create(:member_selection, selectable: goal),
      create(:member_selection, selectable: goal)
    ]
  end
  let(:action_steps) do
    [
      create(:action_step, :with_video, :with_document, milestone: milestone, created_at: 2.days.ago, name: 'Step 1'),
      create(:action_step, :with_video, :with_document, milestone: milestone, created_at: 1.day.ago, name: 'Step 2'),
      create(:action_step, :with_video, :with_document, milestone: milestone, created_at: Time.current, name: 'Step 3')
    ]
  end

  let(:params) { { goal_id: goal.id } }
  let(:service) { described_class.new('goal', params) }

  before do
    member_selections
    action_steps # Ensure action step with an icon is created before running the test
  end

  describe '#duplicate' do
    context 'when the original record exists' do
      it 'duplicates the original goal with updated attributes' do
        duplicated_goal = service.duplicate

        expect(duplicated_goal).not_to be_persisted
        expect(duplicated_goal.name).to eq("Copy-of-#{goal.name}")
        expect(duplicated_goal.goal_id).to eq(goal.id)
        expect(duplicated_goal.status).to eq('Draft')
        expect(duplicated_goal.start_date).to eq(Date.today)
        expect(duplicated_goal.end_date).to eq(Date.today)
      end
    end

    context 'when the original record does not exist' do
      let(:params) { { goal_id: nil } }

      it 'raises a NotImplementedError' do
        expect { service.duplicate }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when duplicating attachments' do
      it "duplicates the goal's icon" do
        duplicated_goal = service.duplicate

        expect(duplicated_goal.icon).to be_attached
        expect(duplicated_goal.icon.blob).to eq(goal.icon.blob) # Ensure it's the same blob
      end

      it 'duplicates the action step icons' do
        duplicated_goal = service.duplicate

        original_action_step = goal.milestones.first.action_steps.first
        duplicated_action_step = duplicated_goal.milestones.first.action_steps.first

        expect(duplicated_action_step.artifact_document).to be_attached
        expect(duplicated_action_step.artifact_document.blob).to eq(original_action_step.artifact_document.blob)

        expect(duplicated_action_step.artifact_video).to be_attached
        expect(duplicated_action_step.artifact_video.blob).to eq(original_action_step.artifact_video.blob)
      end
    end

    context 'when duplicating action steps' do
      it 'duplicates the action steps in the same order as the original ones' do
        duplicated_goal = service.duplicate

        original_action_steps = goal.milestones.first.action_steps.order(:created_at)
        duplicated_action_steps = duplicated_goal.milestones.first.action_steps

        expect(duplicated_action_steps.size).to eq(original_action_steps.size)

        original_action_steps.each_with_index do |original_step, index|
          duplicated_step = duplicated_action_steps[index]

          expect(duplicated_step.name).to eq(original_step.name)
        end
      end
    end

    context 'when duplicating member selections' do
      it 'duplicates the member selections' do
        duplicated_goal = service.duplicate

        original_member_selections = goal.member_selections
        duplicated_member_selections = duplicated_goal.member_selections

        expect(duplicated_member_selections.size).to eq(original_member_selections.size)

        original_member_selections.each_with_index do |original_selection, index|
          duplicated_selection = duplicated_member_selections[index]

          expect(duplicated_selection.selectable_id).not_to eq(original_selection.selectable_id)
        end
      end
    end
  end

  describe '#initialize_new_record' do
    it 'creates a new duplicated record with the correct attributes' do
      new_record = service.send(:initialize_new_record)

      expect(new_record.name).to eq("Copy-of-#{goal.name}")
      expect(new_record.goal_id).to eq(goal.id)
      expect(new_record.status).to eq('Draft')
      expect(new_record.start_date).to eq(Date.today)
      expect(new_record.end_date).to eq(Date.today)
    end
  end

  describe '#original_record' do
    it 'fetches the original record by goal_id' do
      expect(service.send(:original_record)).to eq(goal)
    end
  end
end
