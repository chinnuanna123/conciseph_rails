class AddColumnAcknowledgedToUserActions < ActiveRecord::Migration[6.0]
  def change
    add_column :user_actions, :acknowledged, :boolean, default: false
  end
end
