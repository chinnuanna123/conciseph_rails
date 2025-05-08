# frozen_string_literal: true

# spec/factories/custom_templates.rb
FactoryBot.define do
  factory :custom_template do
    name { 'Sample Template' }
    description { 'This is a sample custom template.' }
    functional_area { rand(0..8) }
    campaign_name { 4 }
    category { 1 }
    section { 1 }
    is_active { true }
    status { 0 }

    trait :with_icon do
      after(:build) do |goal|
        goal.icon.attach(
          io: File.open(Rails.public_path.join('sample_icon.png')),
          filename: 'sample_icon.png',
          content_type: 'image/png'
        )
      end
    end
  end
end
