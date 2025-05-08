class AddColumnCompletionDateToUserActions < ActiveRecord::Migration[6.0]
  def change
    add_column :user_actions, :completion_date, :datetime
  end
end
