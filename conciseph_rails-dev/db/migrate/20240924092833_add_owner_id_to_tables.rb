class AddOwnerIdToTables < ActiveRecord::Migration[6.0]
  def change
    add_column :goals, :owner_id, :integer
    add_column :timely_recovery_goals, :owner_id, :integer
    add_column :member_feedbacks, :owner_id, :integer
    add_column :health_events, :owner_id, :integer
    add_column :health_educations, :owner_id, :integer
    add_column :compliances, :owner_id, :integer
    add_column :announcements, :owner_id, :integer

    add_index :goals, :owner_id, unique: true
    add_index :timely_recovery_goals, :owner_id, unique: true
    add_index :member_feedbacks, :owner_id, unique: true
    add_index :health_events, :owner_id, unique: true
    add_index :health_educations, :owner_id, unique: true
    add_index :compliances, :owner_id, unique: true
    add_index :announcements, :owner_id, unique: true
  end
end