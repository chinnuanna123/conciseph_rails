class AddColumnAcknowledgedToUserGoals < ActiveRecord::Migration[6.0]
  def change
    add_column :user_goals, :acknowledged, :boolean , default: false
  end
end
