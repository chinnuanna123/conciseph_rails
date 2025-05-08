class RenameTimeInMedicationTimings < ActiveRecord::Migration[6.0]
  def change
    rename_column :medication_timings, :time, :scheduled_time
  end
end
