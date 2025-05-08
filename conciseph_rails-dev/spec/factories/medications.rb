# frozen_string_literal: true

# spec/factories/medications.rb
FactoryBot.define do
  factory :medication do
    association :user # Assuming you have a User factory
    mobile_app_uuid { SecureRandom.uuid }

    medication_type { 'tablet' } # Default medication type
    dosage_count_cycle_name { 'days' } # Default dosage count cycle
    dosage_cycle_name { 'days' } # Default dosage cycle
    status { 'Not Started' } # Default status

    trait :on_track do
      status { 'On Track' }
    end

    trait :non_adherence do
      status { 'Non Adherence' }
    end
  end
end
