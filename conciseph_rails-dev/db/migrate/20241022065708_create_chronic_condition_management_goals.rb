class CreateChronicConditionManagementGoals < ActiveRecord::Migration[6.0]
  def change
    create_table :chronic_condition_management_goals do |t|
      t.string :name
      t.integer :chronic_condition_management_goal_type, default: 0
      t.integer :chronic_condition_management_goal_category
      t.integer :status, default: 0
      t.date :start_date
      t.date :end_date
      t.integer :section, null: false
      t.text :description
      t.string :icon
      t.integer :owner_id

      t.index :owner_id, name: "index_chronic_condition_management_goals_on_owner_id"
      t.timestamps
    end
  end
end
