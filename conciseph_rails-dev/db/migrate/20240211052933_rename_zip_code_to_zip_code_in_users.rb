class RenameZipCodeToZipCodeInUsers < ActiveRecord::Migration[6.0]
  def change
    rename_column :users, :zipCode, :zip_code
  end
end
