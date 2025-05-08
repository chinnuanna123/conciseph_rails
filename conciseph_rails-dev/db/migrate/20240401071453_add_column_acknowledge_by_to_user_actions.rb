class AddColumnAcknowledgeByToUserActions < ActiveRecord::Migration[6.0]
  def change
    add_column :user_actions, :acknowledge_by, :date
  end
end
