# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GoalDuplication::GoalDuplicationByCustomTemplateIdService do
  let(:custom_template) { create(:custom_template, name: 'Test Template') }
  let(:milestone1) { create(:milestone, milestonable: custom_template) }
  let(:milestone2) { create(:milestone, milestonable: custom_template) }
  let!(:action_step1) { create(:action_step, milestone: milestone1, name: 'Action Step 1') }
  let!(:action_step2) { create(:action_step, milestone: milestone1, name: 'Action Step 2') }
  let!(:action_step3) { create(:action_step, milestone: milestone2, name: 'Action Step 3') }
  let(:params) { { custom_template_id: custom_template.id } }
  let(:service) { described_class.new('custom_template', params) }

  describe '#duplicate' do
    context 'when duplicating a custom template' do
      it 'creates a duplicate with the correct attributes' do
        duplicated_template = service.duplicate

        expect(duplicated_template).to be_a(CustomTemplate)
        expect(duplicated_template.name).to eq('Copy-of-Test Template')
        expect(duplicated_template.custom_template_id).to eq(custom_template.id)
        expect(duplicated_template).not_to eq(custom_template)
      end

      it 'duplicates the milestones' do
        duplicated_template = service.duplicate

        expect(duplicated_template.milestones.size).to eq(custom_template.milestones.size)
        expect(duplicated_template.milestones).not_to eq(custom_template.milestones)
      end

      it 'duplicates the action steps for each milestone' do
        duplicated_template = service.duplicate

        custom_template.milestones.each_with_index do |original_milestone, index|
          duplicated_milestone = duplicated_template.milestones[index]
          expect(duplicated_milestone.action_steps.size).to eq(original_milestone.action_steps.size)
          expect(duplicated_milestone.action_steps.map(&:name)).to match_array(original_milestone.action_steps.pluck(:name))
          expect(duplicated_milestone.action_steps).not_to eq(original_milestone.action_steps)
        end
      end
    end

    context 'when the original record cannot be found' do
      let(:params) { { custom_template_id: nil } }

      it 'raises an error' do
        expect { service.duplicate }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when duplicating attachments' do
      before do
        custom_template.icon.attach(
          io: File.open(Rails.root.join('spec/fixtures/files/sample_icon.png')),
          filename: 'sample_icon.png',
          content_type: 'image/png'
        )
      end

      it 'duplicates the icon attachment' do
        duplicated_template = service.duplicate

        expect(duplicated_template.icon).to be_attached
        expect(duplicated_template.icon.blob.filename).to eq(custom_template.icon.blob.filename)
      end
    end
  end
end
