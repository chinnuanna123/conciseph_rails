class RemoveColumnAcknowledged < ActiveRecord::Migration[6.0]
  def change
    remove_column :user_actions, :acknowledged, :boolean
  end
end
