# frozen_string_literal: true

module Duplicatable
  extend ActiveSupport::Concern

  def duplicate_with_assn(params)
    original_record = self
    new_record = initialize_new_record(original_record, params)

    duplicate_main_record_attachments(original_record, new_record)
    duplicate_member_selections(original_record, new_record, params)
    duplicate_milestones(original_record, new_record, params)
    new_record
  end

  def set_default_attachment_if_not_present
    original_goal = find_original_goal

    attach_default_icon(original_goal)
    action_steps.each_with_index { |action_step, index| attach_default_artifacts(action_step, original_goal, index) }
  end
  

  private

  def initialize_new_record(original_record, params)
    new_record = if params[:goal_id].present?
                   initialize_goal_copy(original_record, params[:goal_id])
                 elsif params[:custom_template_id].present?
                   initialize_template_copy(original_record, params[:custom_template_id])
                 else
                   initialize_templated_goal(original_record, params[:template_id])
                 end

    set_common_attributes(new_record)
    new_record
  end

  def initialize_goal_copy(original_record, goal_id)
    new_record = original_record.dup
    new_record.assign_attributes(
      name: "Copy-of-#{original_record.name}",
      goal_id: goal_id
    )
    new_record
  end

  def initialize_template_copy(original_record, custom_template_id)
    new_record = original_record.dup
    new_record.assign_attributes(
      name: "Copy-of-#{original_record.name}",
      custom_template_id: custom_template_id
    )
    new_record
  end

  def initialize_templated_goal(original_record, template_id)
    new_record = original_record.get_model.new
    new_record.assign_attributes(
      name: original_record.name,
      "#{original_record.get_model.to_s.underscore}_category".to_sym => original_record.get_category,
      section: original_record.get_section,
      description: original_record.description,
      template_id: template_id
    )
    new_record
  end

  def set_common_attributes(new_record)
    new_record.status = 'Draft' unless new_record.is_a?(CustomTemplate)
    new_record.start_date = Date.today if new_record.respond_to?(:start_date)
    new_record.end_date = Date.today if new_record.respond_to?(:end_date)
  end

  def duplicate_main_record_attachments(original_record, new_record)
    return unless original_record.respond_to?(:icon) && original_record.icon.attached?

    new_record.icon.attach(original_record.icon.blob)
  end

  def duplicate_member_selections(original_record, new_record, params)
    return if original_record.is_a?(TimelyRecoveryGoal) || !original_record.respond_to?(:member_selections)
    if params[:by_goal] .present?
      original_record.member_selections.where(
        link_to_id: params[:link_to_id], 
        link_to_type: params[:link_to_type],
        milestone_id: params[:milestone_id],
        milestone_status: params[:milestone_status]
        ).build
    else
        original_record.member_selections.each do |original_selection|
          new_selection = original_selection.dup
          new_selection.selectable_id = nil
          new_record.member_selections << new_selection
        end
    end
  end

  def duplicate_milestones(original_record, new_record, params)
    if params[:by_goal].present? && params[:template_id].blank?
       milestone_id = params[:milestone_id]
       milestone = Milestone.find(milestone_id)
       new_milestone = milestone.dup
       new_milestone.milestonable_id = nil
       duplicate_action_steps_with_attachments(milestone, new_milestone)
       new_record.milestones << new_milestone
    else
      original_record.milestones.each do |milestone|
        new_milestone = milestone.dup
        new_milestone.milestonable_id = nil
        duplicate_action_steps_with_attachments(milestone, new_milestone)
        new_record.milestones << new_milestone
      end
    end
  end

  def duplicate_action_steps_with_attachments(milestone, new_milestone)
    milestone.action_steps.includes(:artifact_document_attachment,
                                          :artifact_video_attachment).order('created_at ASC').each do |original_step|
      new_step = original_step.dup
      new_step.id = nil # Reset the id to associate with new_goal

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

  def find_original_goal
    if respond_to?(:goal_id) && goal_id.present?
      self.class.find(goal_id)
    elsif respond_to?(:template_id) && template_id.present?
      CustomTemplate.find(template_id)
    elsif respond_to?(:custom_template_id) && custom_template_id.present?
      CustomTemplate.find(custom_template_id)
    end
  end

  def attach_default_icon(original_goal)
    return unless original_goal&.icon&.attached?

    icon.attach(original_goal.icon.blob) unless icon.attached?
  end

  def attach_default_artifacts(action_step, original_goal, index)
    return unless original_goal

    action_step.set_artifact_type_val
    artifact_type = action_step.artifact_type
    return if artifact_type.nil? || artifact_type == 'web_url'

    original_action_step = original_goal.action_steps.order('created_at ASC')[index]
    attach_artifact(action_step, original_action_step, artifact_type)
  end

  def attach_artifact(action_step, original_action_step, artifact_type)
    artifact_attachment_method = "artifact_#{artifact_type}"
    return unless original_action_step.send(artifact_attachment_method).attached?

    artifact_blob = original_action_step.send(artifact_attachment_method).blob
    return if action_step.send(artifact_attachment_method).attached?

    action_step.send(artifact_attachment_method).attach(artifact_blob)
  end
end
