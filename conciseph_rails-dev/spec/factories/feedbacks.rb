# frozen_string_literal: true

# spec/factories/feedbacks.rb
FactoryBot.define do
  factory :feedback do
    association :user # Automatically creates a user if one isn't provided
    ratings { rand(1.0..5.0).round(1) } # Random rating between 1.0 and 5.0
    message { 'This is a sample feedback message.' } # Default message

    # You can also define traits for different kinds of feedback
    trait :positive do
      message { 'Great service!' }
      ratings { 5.0 }
    end

    trait :negative do
      message { 'Not satisfied.' }
      ratings { 1.0 }
    end
  end
end
