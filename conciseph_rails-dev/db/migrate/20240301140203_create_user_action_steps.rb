class CreateUserActionSteps < ActiveRecord::Migration[6.0]
  def change
    create_table :user_action_steps do |t|
      t.references :action_step, null: false, foreign_key: true
      t.references :user_action, null: false, foreign_key: true
      t.integer :status, default: 0
      t.integer :action_taken, default: 0

      t.timestamps
    end
  end
end
