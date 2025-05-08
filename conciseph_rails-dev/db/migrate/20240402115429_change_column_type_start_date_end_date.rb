class ChangeColumnTypeStartDateEndDate < ActiveRecord::Migration[6.0]
  def up
    change_column :medications, :start_date, :datetime
    change_column :medications, :end_date, :datetime
  end

  def down
    change_column :medications, :start_date, :date
    change_column :medications, :end_date, :date
  end
end
