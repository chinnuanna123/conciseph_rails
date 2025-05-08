# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GoalDuplication::GoalDuplicationByMilestoneService do
  let(:goal) { create(:goal, :with_icon, name: 'Test Goal') }
  let(:milestone) { create(:milestone, milestonable: goal) }
  let!(:action_step1) { create(:action_step, milestone: milestone) }
  let!(:action_step2) { create(:action_step, milestone: milestone) }
  let!(:member_selection1) { create(:member_selection, selectable: goal, milestone_id: milestone.id) }
  let!(:member_selection2) { create(:member_selection, selectable: goal, milestone_id: milestone.id) }
  let(:params) do
    {
      milestone_id: milestone.id,
      link_to_id: 1,
      link_to_type: 'Goal',
      milestone_status: 'completed'
    }
  end
  let(:service) { described_class.new('milestone', params) }

  describe '#duplicate' do
    context 'when duplicating a milestone' do
      it 'duplicates the milestone' do
        duplicated_goal = service.duplicate

        expect(duplicated_goal.milestones.size).to eq(1)
        duplicated_milestone = duplicated_goal.milestones.first
        expect(duplicated_milestone).not_to eq(milestone)
      end

      it 'duplicates action steps associated with the milestone' do
        duplicated_goal = service.duplicate
        duplicated_milestone = duplicated_goal.milestones.first

        expect(duplicated_milestone.action_steps.size).to eq(milestone.action_steps.count)
        expect(duplicated_milestone.action_steps.map(&:name)).to match_array(milestone.action_steps.pluck(:name))
        expect(duplicated_milestone.action_steps).not_to eq(milestone.action_steps)
      end
    end

    context 'when duplicating member selections' do
      it 'duplicates only member selections matching the search object' do
        duplicated_goal = service.duplicate
        expect(duplicated_goal.member_selections.size).to eq(1)
        duplicated_member_selection = duplicated_goal.member_selections.first
        expect(duplicated_member_selection.milestone_status).to eq(1)
        expect(duplicated_member_selection).not_to eq(member_selection1)
        expect(duplicated_member_selection.selectable_id).to be_nil
      end

      it 'set milestone status as 0 if its in progress' do
        service = described_class.new('milestone', params.merge!(milestone_status: 'In Progress'))
        duplicated_goal = service.duplicate
        expect(duplicated_goal.member_selections.size).to eq(1)
        duplicated_member_selection = duplicated_goal.member_selections.first
        expect(duplicated_member_selection.milestone_status).to eq(0)
      end

      it 'set milestone status as 2 if its not started' do
        service = described_class.new('milestone', params.merge!(milestone_status: 'Not Started'))
        duplicated_goal = service.duplicate
        expect(duplicated_goal.member_selections.size).to eq(1)
        duplicated_member_selection = duplicated_goal.member_selections.first
        expect(duplicated_member_selection.milestone_status).to eq(2)
      end
    end
  end
end
