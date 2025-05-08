class RenameGoalActionUserGoalStepsToGoalActionStepUserGoal < ActiveRecord::Migration[6.0]
  def change
    rename_table :goal_action_user_goal_steps, :goal_action_step_user_goals
  end
end
