# app/services/goal_duplication/create_service.rb

# frozen_string_literal: true

module GoalDuplication
  class CreateService
    attr_reader :actionable_type, :params

    def initialize(actionable_type, params)
      @actionable_type = actionable_type
      @params = params
    end

    def call
      if params[:goal_id].present?
        duplicate_with_goal_id
      elsif params[:custom_template_id].present?
        duplicate_with_template_id
      elsif params[:by_goal].present?
        duplicate_with_by_milestone
      else
        goal = actionable_type.classify.constantize.new
        unless goal.is_a?(CustomTemplate) || goal.is_a?(TimelyRecoveryGoal)
          goal.member_selections.build
          goal.milestones.build.action_steps.build
        end
        goal
      end
    end

    def duplicate_with_goal_id
      GoalDuplication::GoalDuplicationByGoalIdService.new(actionable_type, params).duplicate
    end

    def duplicate_with_template_id
      GoalDuplication::GoalDuplicationByCustomTemplateIdService.new(actionable_type, params).duplicate
    end

    def duplicate_with_by_milestone
      GoalDuplication::GoalDuplicationByMilestoneService.new(actionable_type, params).duplicate
    end
  end
end
