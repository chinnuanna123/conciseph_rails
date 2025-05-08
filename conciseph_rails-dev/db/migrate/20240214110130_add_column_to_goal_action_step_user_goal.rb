class AddColumnToGoalActionStepUserGoal < ActiveRecord::Migration[6.0]
  def change
    add_column :goal_action_step_user_goals, :action_taken, :integer , default: 0
  end
end
