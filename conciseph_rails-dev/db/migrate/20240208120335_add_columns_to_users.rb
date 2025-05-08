class AddColumnsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :gender, :integer
    add_column :users, :gender_on_birth_certificates, :integer
    add_column :users, :ethnicity, :integer
    add_column :users, :preferred_language, :integer
    add_column :users, :zipCode, :string
    add_column :users, :height_ft, :integer
    add_column :users, :height_inch, :integer
    add_column :users, :blood_group, :integer
    add_column :users, :birth_date, :date
  end
end
