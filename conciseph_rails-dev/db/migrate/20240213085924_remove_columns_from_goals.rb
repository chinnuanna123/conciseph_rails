class RemoveColumnsFromGoals < ActiveRecord::Migration[6.0]
  def change
    remove_column :goals, :criteria_type, :integer
    remove_column :goals, :criterial_value, :string
  end
end
