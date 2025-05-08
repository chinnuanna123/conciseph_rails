class CreateMedications < ActiveRecord::Migration[6.0]
  def change
    create_table :medications do |t|
      t.string :name
      t.integer :medication_type
      t.float :dosage_qty
      t.float :dosage_count, default: -1
      t.integer :dosage_count_cycle_name
      t.integer :dosage_days, default: -1
      t.integer :dosage_cycle_name
      t.date :start_date
      t.date :end_date
      t.integer :medication_timing_count
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
