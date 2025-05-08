class AddColumnToUsersReportingAge < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :reporting_age, :integer
    add_column :users, :age_updated_at, :datetime
  end
end
