# frozen_string_literal: true

FactoryBot.define do
  factory :announcement do
    association :owner, factory: :user # Assumes you have a User factory for the owner association

    name { 'announcement Name' }
    announcement_type { 0 } # Enum value for 'Quality Measures'
    announcement_category { rand(0..2) } # Enum value for 'Well Child Care'
    status { 0 } # Enum value for 'Draft'
    start_date { Date.today } # A valid start date
    end_date { Date.today + 1.month } # A valid end date, after the start date
    section { 0 } # Enum value for 'Better Health'
    description { 'Sample announcement description.' }

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
      after(:build) do |announcement|
        announcement.icon.attach(
          io: File.open(Rails.public_path.join('sample_icon.png')),
          filename: 'sample_icon.png',
          content_type: 'image/png'
        )
      end
    end

    # For testing associated records
    # trait :with_action_steps do
    #   after(:create) do |announcement|
    #     create_list(:action_step, 3, actionable: announcement)  # Assumes you have an ActionStep factory
    #   end
    # end

    # trait :with_member_selections do
    #   after(:create) do |announcement|
    #     create_list(:member_selection, 3, selectable: announcement)  # Assumes you have a MemberSelection factory
    #   end
    # end
  end
end
