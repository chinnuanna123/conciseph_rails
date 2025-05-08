class CreateGoalActionUserGoalSteps < ActiveRecord::Migration[6.0]
  def change
    create_table :goal_action_user_goal_steps do |t|
      t.references :user_goal, null: false, foreign_key: true
      t.references :goal_action_step, null: false, foreign_key: true
      t.integer :status, default: 0
      
      t.timestamps
    end
  end
end
