class ChangeColumnFromMemberSelections < ActiveRecord::Migration[6.0]
  def change
    rename_column :member_selections, :status, :milestone_status
  end
end
