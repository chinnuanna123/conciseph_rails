# frozen_string_literal: true

FactoryBot.define do
  factory :payment do
    association :user  # This assumes that a User factory is defined
    amount { 100.00 }
    currency { 'USD' }
    expiry_date { 1.month.from_now }
    purchase_id { 'PURCHASE123' }
    order_id { 'ORDER123' }
    sku_code { 'SKU123' }
    purchase_type { 'Subscription' }
    active { true }
    email { 'test@example.com' }
  end
end
