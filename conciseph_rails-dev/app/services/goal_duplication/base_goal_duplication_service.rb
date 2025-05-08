# app/services/goal_duplication/base_goal_duplication_service.rb

# frozen_string_literal: true

module GoalDuplication
  class BaseGoalDuplicationService
    attr_reader :actionable_type, :params, :new_record

    def initialize(actionable_type, params)
      @actionable_type = actionable_type
      @params = params
      @new_record = initialize_new_record
    end

    def duplicate
      duplicate_main_record_attachments
      duplicate_milestones if duplicate_milestones?
      duplicate_member_selections if duplicate_member_selections?
      new_record
    end

    private

    def class_name
      actionable_type.classify.constantize
    end

    def original_record
      raise NotImplementedError, 'Subclasses must implement original_record'
    end

    def initialize_new_record
      new_record = original_record.dup
      assign_common_attributes(new_record)
      new_record
    end

    def assign_common_attributes(new_record)
      new_record.status = 'Draft' unless new_record.is_a?(CustomTemplate)
      new_record.start_date = Date.today if new_record.respond_to?(:start_date)
      new_record.end_date = Date.today if new_record.respond_to?(:end_date)
    end

    def duplicate_main_record_attachments
      return unless original_record.respond_to?(:icon) && original_record.icon.attached?

      new_record.icon.attach(original_record.icon.blob)
    end

    def duplicate_member_selections?
      original_record.respond_to?(:member_selections) && !original_record.is_a?(TimelyRecoveryGoal)
    end

    def duplicate_milestones?
      original_record.respond_to?(:milestones)
    end

    def duplicate_milestones
      original_record.milestones.each do |milestone|
        new_milestone = milestone.dup
        new_milestone.milestonable_id = nil
        duplicate_action_steps_with_attachments(milestone, new_milestone)
        new_record.milestones << new_milestone
      end
    end

    def duplicate_action_steps_with_attachments(milestone, new_milestone)
      milestone.action_steps.includes(:artifact_document_attachment,
                                      :artifact_video_attachment).order('created_at ASC').each do |original_step|
        new_step = original_step.dup
        attach_artifact_document(original_step, new_step)
        attach_artifact_video(original_step, new_step)
        new_milestone.action_steps << new_step
      end
    end

    def attach_artifact_document(original_step, new_step)
      return unless original_step.artifact_document.attached?

      new_step.artifact_document.attach(original_step.artifact_document.blob)
    end

    def attach_artifact_video(original_step, new_step)
      return unless original_step.artifact_video.attached?

      new_step.artifact_video.attach(original_step.artifact_video.blob)
    end

    def duplicate_member_selections
      original_record.member_selections.each do |original_selection|
        new_selection = original_selection.dup
        new_selection.selectable_id = nil
        new_record.member_selections << new_selection
      end
    end
  end
end
