class CreateMilestones < ActiveRecord::Migration[6.0]
  def change
    create_table :milestones do |t|
      t.references :action_step
      t.references :milestonable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
