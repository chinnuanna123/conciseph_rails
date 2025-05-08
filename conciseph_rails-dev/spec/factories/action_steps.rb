# frozen_string_literal: true

# spec/factories/action_step.rb
FactoryBot.define do
  factory :action_step do
    step_number { '1' }
    name { 'Sample Action Step' }
    message { 'This is a sample message for the action step.' }
    action { 0 } # Assuming 0 corresponds to 'Display Message'
    interaction { 0 } # Assuming 0 corresponds to 'Message Box with OK button'
    artifact_type { 0 } # Assuming 0 corresponds to 'document'
    artifact_url { 'http://example.com' }
    # association :actionable, factory: :custom_template # Adjust based on your actual model

    trait :with_video do
      action { 4 } # Assuming 4 corresponds to 'Play Video'
      artifact_type { 1 } # Assuming 1 corresponds to 'video'
      after(:build) do |action_step|
        action_step.artifact_video.attach(
          io: File.open(Rails.public_path.join('sample_video.mp4')), # Ensure the path exists
          filename: 'sample_video.mp4',
          content_type: 'video/mp4'
        )
      end
    end

    trait :with_document do
      action { 1 } # Assuming 1 corresponds to 'Display Flyer'
      artifact_type { 0 } # Assuming 0 corresponds to 'document'
      after(:build) do |action_step|
        action_step.artifact_document.attach(
          io: File.open(Rails.public_path.join('sample_document.pdf')), # Ensure the path exists
          filename: 'sample_document.pdf',
          content_type: 'application/pdf'
        )
      end
    end
  end
end
