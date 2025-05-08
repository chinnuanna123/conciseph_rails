class AddFieldsToGoal < ActiveRecord::Migration[6.0]
  def change
    add_column :goals, :section, :integer, null: false
    add_column :goals, :description, :text
    add_column :goals, :icon, :string
  end
end
