# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    #  user_id { Faker::Number.unique.number(digits: 10) }
    name { Faker::Name.name }
    email { Faker::Internet.unique.email }
    phone { Faker::PhoneNumber.phone_number }
    # birth_date { Faker::Date.between(from: 100.years.ago, to: 18.years.ago) }
    preferred_language { rand(111..113) }
    ethnicity { rand(111..117) }
    gender { rand(111..114) }
    password { SecureRandom.hex }
    otp_verified { true }
  end
end
# create_table "users", force: :cascade do |t|
#   t.string "email", default: "", null: false
#   t.string "encrypted_password", default: "", null: false
#   t.string "phone"
#   t.string "otp_number"
#   t.datetime "otp_validity"
#   t.boolean "otp_verified", default: false
#   t.string "reset_password_token"
#   t.datetime "reset_password_sent_at"
#   t.datetime "remember_created_at"
#   t.datetime "created_at", precision: 6, null: false
#   t.datetime "updated_at", precision: 6, null: false
#   t.string "provider", default: "email", null: false
#   t.string "uid", default: "", null: false
#   t.string "name"
#   t.string "nickname"
#   t.string "image"
#   t.json "tokens"
#   t.boolean "allow_password_change", default: false
#   t.integer "sign_in_count", default: 0, null: false
#   t.datetime "current_sign_in_at"
#   t.datetime "last_sign_in_at"
#   t.string "current_sign_in_ip"
#   t.string "last_sign_in_ip"
#   t.string "confirmation_token"
#   t.datetime "confirmed_at"
#   t.datetime "confirmation_sent_at"
#   t.string "unconfirmed_email"
#   t.boolean "is_admin", default: false
#   t.text "referred_by"
#   t.boolean "super_admin", default: false
#   t.integer "gender", default: 114
#   t.integer "gender_on_birth_certificates", default: 114
#   t.integer "ethnicity", default: 117
#   t.integer "preferred_language", default: 113
#   t.string "zip_code"
#   t.integer "height_ft"
#   t.integer "height_inch"
#   t.integer "blood_group", default: 119
#   t.bigint "family_head_id"
#   t.text "fcm_token"
#   t.datetime "last_seen_at"
#   t.integer "medication_adhere_status", default: 0
#   t.integer "reporting_age"
#   t.datetime "age_updated_at"
#   t.boolean "onboarding_steps_completed", default: false
#   t.index ["email"], name: "index_users_on_email", unique: true
#   t.index ["family_head_id"], name: "index_users_on_family_head_id"
#   t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
# end
