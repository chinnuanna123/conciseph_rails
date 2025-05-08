# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Duplicatable do
  let(:original_goal) { create(:goal, :with_icon) }
  let(:custom_template) { create(:custom_template, :with_icon, campaign_name: 0) }
  let!(:member_selection) { create(:member_selection, selectable: original_goal) }
  let(:new_goal) { original_goal.duplicate_with_assn({ goal_id: original_goal.id }) }
  let(:new_record) { custom_template.duplicate_with_assn({ custom_template_id: custom_template.id }) }
  let(:new_goal_from_template) { custom_template.duplicate_with_assn({ template_id: custom_template.id }) }

  describe '#duplicate_with_assn' do
    it 'duplicates the goal attributes' do
      expect(new_goal.name).to eq("Copy-of-#{original_goal.name}")
      expect(new_goal.goal_type).to eq(original_goal.goal_type)
      expect(new_goal.goal_category).to eq(original_goal.goal_category)
      expect(new_goal.start_date).to eq(original_goal.start_date)
      expect(new_goal.description).to eq(original_goal.description)
    end

    it 'duplicates the custom_template attributes' do
      expect(new_record.name).to eq("Copy-of-#{custom_template.name}")
      expect(new_record.campaign_name).to eq(custom_template.campaign_name)
      expect(new_record.category).to eq(custom_template.category)
      expect(new_record.description).to eq(custom_template.description)
    end

    it 'duplicates the templated goals attributes' do
      expect(new_goal_from_template.name).to eq(custom_template.name.to_s)
      expect(new_goal_from_template.goal_category).to eq(custom_template.get_category)
      expect(new_goal_from_template.description).to eq(custom_template.description)
    end

    it 'sets the status to Draft' do
      expect(new_goal.status).to eq('Draft')
    end

    it 'duplicates the icon attachment' do
      expect(new_goal.icon).to be_attached
      expect(new_goal.icon.blob.id).not_to eq(original_goal.icon.blob.id)
    end

    it 'duplicates member selections' do
      original_selection = member_selection
      expect(new_goal.member_selections.size).to eq(original_goal.member_selections.count)
      expect(new_goal.member_selections.first.selectable_id).to be_nil
    end

    it 'duplicates action steps and their attachments' do
      original_action_step = create(:action_step, actionable: original_goal, action: 'Display Flyer')
      original_action_step.artifact_document.attach(
        io: File.open(Rails.public_path.join('sample_document.pdf')),
        filename: 'sample_document.pdf',
        content_type: 'application/pdf'
      )
      new_goal = original_goal.duplicate_with_assn({ goal_id: original_goal.id })

      expect(new_goal.action_steps.size).to eq(original_goal.action_steps.count)

      new_step = new_goal.action_steps.first
      expect(new_step).to be_present
      expect(new_step.artifact_document).to be_attached
      expect(new_step.artifact_document.blob.id).not_to eq(original_action_step.artifact_document.blob.id)
    end

    it 'attaches default icon if not present' do
      new_goal.set_default_attachment_if_not_present
      expect(new_goal.icon).to be_attached
      expect(new_goal.icon.blob.id).not_to eq(original_goal.icon.blob.id)
    end

    it 'does not attach the default icon if it is already attached' do
      new_goal.icon.attach(io: StringIO.new('dummy data'), filename: 'dummy.png')
      new_goal.set_default_attachment_if_not_present
      expect(new_goal.icon).to be_attached
      expect(new_goal.icon.blob.filename).to eq('dummy.png')
    end

    it 'attaches artifacts correctly using attach_default_artifacts' do
      original_action_step = create(:action_step, actionable: original_goal, action: 'Display Flyer')
      original_action_step.artifact_document.attach(
        io: File.open(Rails.public_path.join('sample_document.pdf')),
        filename: 'sample_document.pdf',
        content_type: 'application/pdf'
      )

      new_action_step = build(:action_step, actionable: new_goal)

      # Use send to access the private method
      new_goal.send(:attach_default_artifacts, new_action_step, original_goal, 0)

      expect(new_action_step.artifact_document).to be_attached
      expect(new_action_step.artifact_document.blob.filename).to eq(original_action_step.artifact_document.blob.filename)
    end

    it 'attaches the correct artifact type using attach_artifact' do
      original_action_step = create(:action_step, actionable: original_goal, action: 'Display Flyer')
      original_action_step.artifact_video.attach(
        io: File.open(Rails.public_path.join('sample_video.mp4')),
        filename: 'sample_video.mp4',
        content_type: 'video/mp4'
      )

      new_action_step = build(:action_step, actionable: new_goal)
      artifact_type = 'video'

      # Ensure the method to attach artifact is called
      new_goal.send(:attach_artifact, new_action_step, original_action_step, artifact_type)

      expect(new_action_step.artifact_video).to be_attached
      expect(new_action_step.artifact_video.blob.filename).to eq(original_action_step.artifact_video.blob.filename)
    end
  end

  describe '#set_default_attachment_if_not_present' do
    let(:unique_owner) { create(:user) }
    let(:custom_goal) { create(:goal, :with_icon, owner: unique_owner) }

    it 'attaches default icon if not present' do
      custom_goal.set_default_attachment_if_not_present
      expect(custom_goal.icon).to be_attached
      expect(custom_goal.icon.blob.filename).to eq(original_goal.icon.blob.filename)
    end

    it 'does not attach icon if it is already attached' do
      custom_goal.icon.attach(io: StringIO.new('sample.png'), filename: 'sample.png')
      expect { custom_goal.set_default_attachment_if_not_present }.not_to change { custom_goal.icon.attached? }
    end
  end
end
