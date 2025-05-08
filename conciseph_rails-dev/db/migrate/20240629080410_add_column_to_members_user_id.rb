class AddColumnToMembersUserId < ActiveRecord::Migration[6.0]
  def change
    add_column :members, :user_id, :integer, null: true
    add_foreign_key :members, :users, column: :user_id
    add_index :members, :user_id, unique: true
  end
end
