# frozen_string_literal: true

FactoryBot.define do
  factory :insurance_type do
    name { 'Health Insurance' } # Provide a default name
    code { 'INS123' } # Provide a default code
  end
end
