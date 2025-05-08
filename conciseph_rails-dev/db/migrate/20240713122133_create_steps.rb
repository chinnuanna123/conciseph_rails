class CreateSteps < ActiveRecord::Migration[6.0]
  def change
    create_table :steps do |t|
      t.string :step_number
      t.string :name
      t.text :message
      t.integer :action
      t.integer :interaction
      t.integer :artifact_type
      t.integer :custom_template_id

      t.timestamps
    end
    add_index :steps, :custom_template_id
  end
end
