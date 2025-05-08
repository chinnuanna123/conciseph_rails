# frozen_string_literal: true

FactoryBot.define do
  factory :symptom do
    name { 'Example Symptom' }
    code { 'C001' }
    kind { :PERSON }
  end
end
