class AddColumnToUsersOnboardingStepsCompleted < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :onboarding_steps_completed, :boolean, default: false
  end
end
