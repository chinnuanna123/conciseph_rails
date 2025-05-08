# frozen_string_literal: true

# spec/factories/vitals.rb
FactoryBot.define do
  factory :vital do
    user
    vital_type { 'Blood Pressure' }
    value { 120.0 }
    date { DateTime.current }
    unit { 'mmHg' }
    type1 { 'Type 1' }
    type2 { 'Type 2' }
    type3 { 'Type 3' }
  end
end
