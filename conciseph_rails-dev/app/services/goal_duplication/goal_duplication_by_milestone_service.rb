# app/services/goal_duplication/goal_duplication_by_goal_service.rb

# frozen_string_literal: true

module GoalDuplication
  class GoalDuplicationByMilestoneService < GoalDuplication::BaseGoalDuplicationService
    private

    def original_record
      @original_record ||= params[:link_to_type].classify.constantize.new
    end

    def duplicate_milestones
      milestone = Milestone.find(params[:milestone_id])
      new_milestone = milestone.dup
      new_milestone.milestonable_id = nil
      duplicate_action_steps_with_attachments(milestone, new_milestone)
      new_record.milestones << new_milestone
    end

    def duplicate_member_selections
      new_record.member_selections.build(member_selection_obj)
    end

    def member_selection_obj
      {
        link_to_id: params[:link_to_id],
        link_to_type: params[:link_to_type],
        milestone_id: params[:milestone_id],
        milestone_status: milestone_status
      }
    end

    def milestone_status
      case params[:milestone_status].downcase
      when 'completed'
        return 1
      when 'in progress'
        return 0
      when 'not started'
        return 2
      end
    end
  end
end
