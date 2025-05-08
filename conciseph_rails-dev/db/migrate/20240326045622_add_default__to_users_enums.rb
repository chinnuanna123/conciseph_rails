class AddDefaultToUsersEnums < ActiveRecord::Migration[6.0]
  def change
      changes = {
      gender: 114,
      gender_on_birth_certificates: 114,
      ethnicity: 117,
      preferred_language: 113,
      blood_group: 119
    }

    changes.each do |column_name, new_default|
      change_column_default :users, column_name, from: nil, to: new_default
    end
  end
end
