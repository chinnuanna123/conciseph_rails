class AddColumnToUsersMedicationAdherePercent < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :medication_adhere_status, :integer, default: 0
  end
end
