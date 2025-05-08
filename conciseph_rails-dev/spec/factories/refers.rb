# frozen_string_literal: true

FactoryBot.define do
  factory :refer do
    name { 'Sample Refer' }
    no_of_users { 5 }
    code { 'REF12345' }
    owner { nil } # This assumes you may have a User model as an owner; adjust accordingly
  end
end
