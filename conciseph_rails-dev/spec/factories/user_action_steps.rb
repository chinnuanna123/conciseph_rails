# frozen_string_literal: true

# spec/factories/user_action_steps.rb
FactoryBot.define do
  factory :user_action_step do
    association :action_step
    association :user_action
    action_taken { 'Ok' } # Default value for action_taken
    status { 'In Progress' } # Default value for status

    trait :completed do
      action_taken { 'Yes' }
      status { 'Completed' }
    end
  end
end
