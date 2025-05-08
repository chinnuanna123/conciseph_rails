class CreateSelectionCriteria < ActiveRecord::Migration[6.0]
  def change
    create_table :selection_criteria do |t|
      t.references :goal, foreign_key: true
      t.references :announcement, foreign_key: true
      t.integer :criteria_type
      t.integer :criteria_sub_type
      t.string :criterial_value
      t.integer :criterial_start_range
      t.integer :criterial_end_range
      t.integer :unit

      t.timestamps
    end
  end
end
