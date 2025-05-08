class CreateGoals < ActiveRecord::Migration[6.0]
  def change
    create_table :goals do |t|
      t.string :name
      t.integer :goal_type
      t.integer :goal_category
      t.integer :status
      t.date :start_date
      t.date :end_date
      t.integer :criteria_type
      t.string :criterial_value

      t.timestamps
    end
    add_index :goals, :criteria_type
  end
end
