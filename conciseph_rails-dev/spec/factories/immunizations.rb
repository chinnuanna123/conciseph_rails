# frozen_string_literal: true

# spec/factories/immunizations.rb
FactoryBot.define do
  factory :immunization do
    name { 'Rabies Vaccine' }  # Example name
    code { 'RAB001' }          # Example code
    kind { Immunization.kinds[:PERSON] }  # Default to PERSON kind
  end
end
