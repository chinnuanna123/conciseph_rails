# frozen_string_literal: true

# spec/factories/visit_types.rb

FactoryBot.define do
  factory :visit_type do
    name { 'Regular Visit' }
    code { 'REG_VISIT' }

    trait :with_unique_code do
      sequence(:code) { |n| "CODE_#{n}" }
    end
  end
end
