# frozen_string_literal: true

FactoryBot.define do
  factory :medication_timing do
    time { Time.current }
    qty { 1 }
    taken_at { nil }
    association :medication
    mobile_app_uuid { SecureRandom.uuid }
  end
end
