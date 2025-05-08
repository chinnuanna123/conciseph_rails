# frozen_string_literal: true

# spec/factories/member_selections.rb

FactoryBot.define do
  factory :member_selection do
    criteria_type { :Age } # Set default value
    criteria_sub_type { 0 } # Set default value
    criterial_value { '30' } # Default value as a string
    criterial_start_range { 25 }  # Default start range
    criterial_end_range { 35 }    # Default end range
    unit { :years } # Default unit

    # Set up the polymorphic association
    association :selectable, factory: :goal  # Replace with the actual selectable model
  end
end
