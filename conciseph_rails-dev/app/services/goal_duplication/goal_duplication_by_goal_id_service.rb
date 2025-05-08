# app/services/goal_duplication/goal_duplication_by_goal_id_service.rb

# frozen_string_literal: true

module GoalDuplication
  class GoalDuplicationByGoalIdService < GoalDuplication::BaseGoalDuplicationService
    private

    def original_record
      @original_record ||= class_name.find(params[:goal_id])
    end

    def initialize_new_record
      new_record = original_record.dup
      new_record.assign_attributes(
        name: "Copy-of-#{original_record.name}",
        goal_id: params[:goal_id]
      )
      assign_common_attributes(new_record)
      new_record
    end
  end
end
