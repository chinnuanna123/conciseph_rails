# frozen_string_literal: true

FactoryBot.define do
  factory :member_feedback do
    association :owner, factory: :user # Assumes you have a User factory for the owner association

    name { 'Member Feedback Name' }
    member_feedback_type { 0 } # Enum value for 'Quality Measures'
    member_feedback_category { rand(0..6) } # Enum value for 'Well Child Care'
    status { 0 } # Enum value for 'Draft'
    start_date { Date.today } # A valid start date
    end_date { Date.today + 1.month } # A valid end date, after the start date
    section { 0 } # Enum value for 'Better Health'
    description { 'Sample Member Feedback description.' }

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
      after(:build) do |goal|
        goal.icon.attach(
          io: File.open(Rails.public_path.join('sample_icon.png')),
          filename: 'sample_icon.png',
          content_type: 'image/png'
        )
      end
    end

    # For testing associated records
    # trait :with_action_steps do
    #   after(:create) do |goal|
    #     create_list(:action_step, 3, actionable: goal)  # Assumes you have an ActionStep factory
    #   end
    # end

    # trait :with_member_selections do
    #   after(:create) do |goal|
    #     create_list(:member_selection, 3, selectable: goal)  # Assumes you have a MemberSelection factory
    #   end
    # end
  end
end
# create_table "member_feedbacks", force: :cascade do |t|
#   t.string "name"
#   t.integer "member_feedback_type", default: 0
#   t.integer "member_feedback_category"
#   t.integer "status", default: 0
#   t.date "start_date"
#   t.date "end_date"
#   t.integer "section", null: false
#   t.text "description"
#   t.text "text"
#   t.string "icon"
#   t.string "string"
#   t.datetime "created_at", precision: 6, null: false
#   t.datetime "updated_at", precision: 6, null: false
#   t.integer "owner_id"
#   t.index ["owner_id"], name: "index_member_feedbacks_on_owner_id", unique: true
# end
