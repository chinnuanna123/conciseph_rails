class Add < ActiveRecord::Migration[6.0]
  def change
    change_column :goals, :status, :integer, default: 0
  end
end
