# frozen_string_literal: true

json.extract! user, :id, :email, :phone, :name, :is_new_user, :zip_code, :height_ft, :height_inch, :family_head_id, :onboarding_steps_completed
              
json.gender user.gender_before_type_cast
json.gender_on_birth_certificates user.gender_on_birth_certificates_before_type_cast
json.ethnicity user.ethnicity_before_type_cast
json.preferred_language user.preferred_language_before_type_cast
json.blood_group user.blood_group_before_type_cast
