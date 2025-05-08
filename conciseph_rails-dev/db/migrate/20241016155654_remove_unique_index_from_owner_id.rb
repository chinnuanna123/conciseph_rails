class RemoveUniqueIndexFromOwnerId < ActiveRecord::Migration[6.0]
  def change
    remove_index :goals, :owner_id if index_exists?(:goals, :owner_id, unique: true)
    add_index :goals, :owner_id unless index_exists?(:goals, :owner_id)

    remove_index :timely_recovery_goals, :owner_id if index_exists?(:timely_recovery_goals, :owner_id, unique: true)
    add_index :timely_recovery_goals, :owner_id unless index_exists?(:timely_recovery_goals, :owner_id)

    remove_index :member_feedbacks, :owner_id if index_exists?(:member_feedbacks, :owner_id, unique: true)
    add_index :member_feedbacks, :owner_id unless index_exists?(:member_feedbacks, :owner_id)

    remove_index :health_events, :owner_id if index_exists?(:health_events, :owner_id, unique: true)
    add_index :health_events, :owner_id unless index_exists?(:health_events, :owner_id)

    remove_index :health_educations, :owner_id if index_exists?(:health_educations, :owner_id, unique: true)
    add_index :health_educations, :owner_id unless index_exists?(:health_educations, :owner_id)

    remove_index :compliances, :owner_id if index_exists?(:compliances, :owner_id, unique: true)
    add_index :compliances, :owner_id unless index_exists?(:compliances, :owner_id)

    remove_index :announcements, :owner_id if index_exists?(:announcements, :owner_id, unique: true)
    add_index :announcements, :owner_id unless index_exists?(:announcements, :owner_id)
  end
end
