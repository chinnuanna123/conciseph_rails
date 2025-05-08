class CreateActionSteps < ActiveRecord::Migration[6.0]
  def change
    create_table :action_steps do |t|
      t.string :step_number
      t.text :name
      t.text :message
      t.integer :action
      t.integer :interaction
      t.integer :artifact_type
      t.text :artifact_url
      t.references :actionable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
