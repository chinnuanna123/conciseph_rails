# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GoalDuplication::CreateService do
  let(:actionable_type) { 'goal' }
  let(:params) { {} }
  let(:service) { described_class.new(actionable_type, params) }
  let(:goal) { create(:goal, :with_icon, name: 'Test Goal') }
  let(:custom_template) { create(:custom_template, name: 'Test Template') }

  describe '#call' do
    context 'when params[:goal_id] is present' do
      let(:params) { { goal_id: goal.id } }

      it 'calls duplicate_with_goal_id' do
        expect_any_instance_of(GoalDuplication::GoalDuplicationByGoalIdService)
          .to receive(:duplicate)

        service.call
      end

      it 'returns the duplicated goal' do
        duplicated_goal = double('Goal')
        allow_any_instance_of(GoalDuplication::GoalDuplicationByGoalIdService)
          .to receive(:duplicate).and_return(duplicated_goal)

        expect(service.call).to eq(duplicated_goal)
      end
    end

    context 'when params[:custom_template_id] is present' do
      let(:params) { { custom_template_id: custom_template.id } }

      it 'calls duplicate_with_template_id' do
        expect_any_instance_of(GoalDuplication::GoalDuplicationByCustomTemplateIdService)
          .to receive(:duplicate)

        service.call
      end

      it 'returns the duplicated goal' do
        duplicated_goal = double('Goal')
        allow_any_instance_of(GoalDuplication::GoalDuplicationByCustomTemplateIdService)
          .to receive(:duplicate).and_return(duplicated_goal)

        expect(service.call).to eq(duplicated_goal)
      end
    end

    context 'when params[:by_goal] is present' do
      let(:params) { { by_goal: true, link_to_id: goal.id, link_to_type: goal.class.to_s, milestone_id: 3 } }

      it 'calls duplicate_with_by_milestone' do
        expect_any_instance_of(GoalDuplication::GoalDuplicationByMilestoneService)
          .to receive(:duplicate)

        service.call
      end

      it 'returns the duplicated milestone' do
        duplicated_milestone = double('Milestone')
        allow_any_instance_of(GoalDuplication::GoalDuplicationByMilestoneService)
          .to receive(:duplicate).and_return(duplicated_milestone)

        expect(service.call).to eq(duplicated_milestone)
      end
    end

    context 'when no matching params are present' do
      it 'returns a new instance of the actionable type' do
        new_goal = double('Goal')
        allow(actionable_type.classify.constantize).to receive(:new).and_return(new_goal)

        expect(service.call).to eq(new_goal)
      end
    end
  end
end
