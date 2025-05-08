class AddMissingIndexes < ActiveRecord::Migration[6.0]
  def change
    add_index :active_storage_attachments, [:record_id, :record_type]  # Index for polymorphic association
    add_index :trackings, :user_id  # Index for the user_id in the trackings table
    add_index :members, :member_id
  end
end
