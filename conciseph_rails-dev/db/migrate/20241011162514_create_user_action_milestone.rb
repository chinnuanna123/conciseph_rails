class CreateUserActionMilestone < ActiveRecord::Migration[6.0]
  def change
    create_table :user_action_milestones do |t|
      t.references :user_action
      t.references :milestone
      t.integer :status, default: 0
    end
  end
end
