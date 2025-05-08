# frozen_string_literal: true

FactoryBot.define do
  factory :support_need do
    association :user # Assuming you have a User factory

    code { 'No need for support services' }
    prefered_days { [] } # Default empty array
    prefered_times { [] } # Default empty array

    trait :prefer_day do
      code { 'Prefer Day' }
      prefered_days { [0] } # Assuming the code for Monday is 0
    end

    trait :prefer_time do
      code { 'Prefer Time' }
      prefered_times { [0] } # Assuming the code for '7am - 9am' is 0
    end

    trait :transportation do
      code { 'Transportation' }
    end

    trait :food do
      code { 'Food' }
    end

    trait :childcare do
      code { 'Childcare' }
    end

    trait :language_translator do
      code { 'Language Translator' }
    end
  end
end
