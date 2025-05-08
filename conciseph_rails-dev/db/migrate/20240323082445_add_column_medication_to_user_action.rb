class AddColumnMedicationToUserAction < ActiveRecord::Migration[6.0]
  def change
    add_column :user_actions, :medication, :string unless column_exists?(:user_actions, :medication)
  end
end
