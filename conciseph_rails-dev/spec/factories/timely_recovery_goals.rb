# frozen_string_literal: true

FactoryBot.define do
  factory :timely_recovery_goal do
    association :owner, factory: :user # Assumes you have a User factory for the owner association

    name { 'timely_recovery_goal Name' }
    timely_recovery_goal_type { 0 } # Enum value for 'Quality Measures'
    timely_recovery_goal_category { rand(111..113) } # Enum value for 'Well Child Care'
    status { 0 } # Enum value for 'Draft'
    section { 0 } # Enum value for 'Better Health'
    description { 'Sample timely_recovery_goal description.' }

    # icon { Rack::Test::UploadedFile.new( Rails.public_path.join('sample_icon.png'), 'image/png', true, original_filename: 'sample_icon.png') }
    # end

    # Traits for different statuses
    trait :active do
      status { 1 }  # Enum value for 'Active'
    end

    trait :completed do
      status { 2 }  # Enum value for 'Completed'
    end
    trait :with_icon do
      after(:build) do |timely_recovery_goal|
        timely_recovery_goal.icon.attach(
          io: File.open(Rails.public_path.join('sample_icon.png')),
          filename: 'sample_icon.png',
          content_type: 'image/png'
        )
      end
    end

    # For testing associated records
    # trait :with_action_steps do
    #   after(:create) do |timely_recovery_goal|
    #     create_list(:action_step, 3, actionable: timely_recovery_goal)  # Assumes you have an ActionStep factory
    #   end
    # end

    # trait :with_member_selections do
    #   after(:create) do |timely_recovery_goal|
    #     create_list(:member_selection, 3, selectable: timely_recovery_goal)  # Assumes you have a MemberSelection factory
    #   end
    # end
  end
end
