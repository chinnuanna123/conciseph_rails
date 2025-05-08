# frozen_string_literal: true

FactoryBot.define do
  factory :allergy do
    name { 'Pollen' } # Provide a default name for the allergy
    code { 'ALGY123' } # Provide a default code for the allergy
  end
end
