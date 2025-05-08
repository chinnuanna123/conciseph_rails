# frozen_string_literal: true

# spec/factories/trackings.rb

FactoryBot.define do
  factory :tracking do
    association :user
    tracking_for { Tracking.tracking_fors.keys.sample } # Randomly select a valid tracking_for code
    counter { 0 }
  end
end
