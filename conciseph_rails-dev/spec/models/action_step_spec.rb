# frozen_string_literal: true

# spec/models/action_step_spec.rb
require 'rails_helper'

RSpec.describe ActionStep, type: :model do
  let(:action_step) { create(:action_step) }

  describe 'associations' do
    it { should belong_to(:actionable) }
    it { should have_one(:user_action_step) }
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(action_step).to be_valid
    end

    it 'is invalid without an actionable' do
      action_step.actionable = nil
      expect(action_step).to_not be_valid
    end
  end

  describe 'callbacks' do
    it 'sets artifact_type based on action before save' do
      action_step.action = 'Display Flyer'
      action_step.save
      expect(action_step.artifact_type).to eq('document')

      action_step.action = 'Play Video'
      action_step.save
      expect(action_step.artifact_type).to eq('video')

      action_step.action = 'Launch External Website or Link'
      action_step.save
      expect(action_step.artifact_type).to eq('web_url')
    end
  end

  describe '#artifact_description_arr' do
    context 'when artifact_type is video' do
      it 'returns video description and URL' do
        action_step.action = 'Play Video'
        action_step.artifact_video.attach(
          io: File.open(Rails.public_path.join('sample_video.mp4')),
          filename: 'sample_video.mp4',
          content_type: 'video/mp4'
        )
        action_step.save
        expect(action_step.artifact_description_arr).to include('video.mp4')
      end
    end

    context 'when artifact_type is document' do
      it 'returns document description and URL' do
        action_step.action = 'Display Flyer'
        action_step.artifact_document.attach(
          io: File.open(Rails.public_path.join('sample_document.pdf')),
          filename: 'sample_document.pdf',
          content_type: 'application/pdf'
        )
        action_step.save
        expect(action_step.artifact_description_arr).to include('document.pdf')
      end
    end

    context 'when artifact_type is web_url' do
      it 'returns artifact URL' do
        action_step.action = 'Launch External Website or Link'
        action_step.artifact_url = 'http://example.com'
        action_step.save
        expect(action_step.artifact_description_arr).to include('http://example.com')
      end
    end
  end
end
