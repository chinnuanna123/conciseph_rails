# frozen_string_literal: true

# spec/factories/overseers.rb
FactoryBot.define do
  factory :overseer do
    name { 'John Doe' }
    email { 'john.doe@example.com' }
    password { 'securepassword' }
    password_confirmation { 'securepassword' }
    role { :api_consumer }

    trait :admin do
      role { :admin }
    end
  end
end
