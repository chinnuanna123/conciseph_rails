class ChangeColumnMedicationToMedicationIdUserAction < ActiveRecord::Migration[6.0]
  def change
    add_reference :user_actions, :medication, foreign_key: true
    remove_column :user_actions, :medication, :text
  end
end
