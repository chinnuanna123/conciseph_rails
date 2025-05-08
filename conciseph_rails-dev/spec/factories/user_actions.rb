# frozen_string_literal: true

# spec/factories/user_actions.rb
FactoryBot.define do
  factory :user_action do
    association :user
    association :actionable, factory: :goal # Replace with actual model if needed
    status { 'Not Started' }

    trait :in_progress do
      status { 'In Progress' }
    end

    trait :completed do
      status { 'Completed' }
    end

    after(:create) do |user_action|
      # Create associated action steps for the goal
      create_list(:action_step, 3, actionable: user_action.actionable) # Creates 3 ActionSteps
    end
  end
end
