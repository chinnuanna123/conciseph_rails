class AddColumnFamilyHeadIdToUsers < ActiveRecord::Migration[6.0]
  def change
    add_reference :users, :family_head, foreign_key: {to_table: :users}
  end
end
