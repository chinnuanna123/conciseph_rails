class AddOwnerIdToRefers < ActiveRecord::Migration[6.0]
  def change
    add_column :refers, :owner_id, :integer
    add_index :refers, :owner_id
  end
end
