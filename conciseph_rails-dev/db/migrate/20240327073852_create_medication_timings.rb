class CreateMedicationTimings < ActiveRecord::Migration[6.0]
  def change
    create_table :medication_timings do |t|
      t.datetime :time
      t.integer :qty, default: 0
      t.datetime :taken_at
      t.references :medication, null: false, foreign_key: true

      t.timestamps
    end
  end
end
