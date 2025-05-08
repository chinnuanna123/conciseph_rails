# frozen_string_literal: true

FactoryBot.define do
  factory :member do
    member_id { Faker::Number.unique.number(digits: 10) }
    name { Faker::Name.name }
    email { Faker::Internet.unique.email }
    phone { Faker::PhoneNumber.phone_number }
    birth_date { Faker::Date.between(from: 100.years.ago, to: 18.years.ago) }
  end
end
