class CreateMemberSelections < ActiveRecord::Migration[6.0]
  def change
    create_table :member_selections do |t|
      t.integer :criteria_type
      t.integer :criteria_sub_type
      t.string :criterial_value
      t.integer :criterial_start_range
      t.integer :criterial_end_range
      t.integer :unit
      t.references :selectable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
