# frozen_string_literal: true

FactoryBot.define do
  factory :pet_service_provider do
    code { 'PET123' }
    name { 'Test Pet Service Provider' }
    kind { :PERSON }  # or :PET if you want to test the other kind
  end
end
