class AddColumnStatusToMedication < ActiveRecord::Migration[6.0]
  def change
    add_column :medications, :status, :integer, default: 0
  end
end
