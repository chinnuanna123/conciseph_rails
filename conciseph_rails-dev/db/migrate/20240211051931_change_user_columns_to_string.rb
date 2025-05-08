class ChangeUserColumnsToString < ActiveRecord::Migration[6.0]
  def change
    change_column :users, :gender, :string
    change_column :users, :ethnicity, :string
  end
end
