class CreateTimelyRecoveryGoals < ActiveRecord::Migration[6.0]
  def change
    create_table :timely_recovery_goals do |t|
      t.string "name"
      t.integer "timely_recovery_goal_type"
      t.integer "timely_recovery_goal_category"
      t.integer "status", default: 0
      t.integer "section", null: false
      t.text "description"
      t.string "icon"

      t.timestamps
    end
  end
end
