# frozen_string_literal: true

FactoryBot.define do
  factory :payment_type do
    code { 'PAY123' }
    name { 'Test Payment Type' }
    kind { :PERSON }  # or :PET if you want to test the other kind
  end
end
