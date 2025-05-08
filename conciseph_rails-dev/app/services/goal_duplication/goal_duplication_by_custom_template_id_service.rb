# app/services/goal_duplication/goal_duplication_by_custom_template_id_service.rb

# frozen_string_literal: true

module GoalDuplication
  class GoalDuplicationByCustomTemplateIdService < GoalDuplication::BaseGoalDuplicationService
    private

    def original_record
      @original_record ||= CustomTemplate.find(params[:custom_template_id])
    end

    def initialize_new_record
      new_record = original_record.dup
      new_record.assign_attributes(
        name: "Copy-of-#{original_record.name}",
        custom_template_id: params[:custom_template_id]
      )
      assign_common_attributes(new_record)
      new_record
    end
  end
end
