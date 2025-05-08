class ChangePreferedDaysTypeToIntInSupportNeeds < ActiveRecord::Migration[6.0]
  def change
     # Remove the old column
     remove_column :support_needs, :prefered_days, :string, array: true, default: []

     # Add the new column with the desired type
     add_column :support_needs, :prefered_days, :integer
  end
end
