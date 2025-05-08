class ChangeColumnPrefferdDaysPrefferdTimesToArrayType < ActiveRecord::Migration[6.0]
  def change
    remove_column :support_needs, :prefered_days, :integer
    remove_column :support_needs, :prefered_times, :integer

    add_column :support_needs, :prefered_days, :integer, array: true, default: [], null: false
    add_column :support_needs, :prefered_times, :integer, array: true, default: [], null: false
    change_column_default :support_needs, :name, from: 4, to: 0
  end
end
