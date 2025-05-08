class CreateGoalActionSteps < ActiveRecord::Migration[6.0]
  def change
    create_table :goal_action_steps do |t|
      t.references :goal, null: false, foreign_key: true
      t.string :step_number
      t.text :name
      t.text :message
      t.integer :action
      t.integer :interaction
      t.integer :artifact_type
      t.text :artifact_url

      t.timestamps
    end
  end
end
