# frozen_string_literal: true

FactoryBot.define do
  factory :speciality do
    name { 'Test Speciality' }
    code { 'SPEC123' }
    kind { :PERSON }  # or :PET if you want to test the other kind
  end
end
