class AddColumnToUserGoals < ActiveRecord::Migration[6.0]
  def change
    add_column :user_goals, :status, :integer , default: 0 
  end
end
