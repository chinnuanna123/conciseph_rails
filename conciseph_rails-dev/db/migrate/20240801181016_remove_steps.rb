class RemoveSteps < ActiveRecord::Migration[6.0]
  def change
    drop_table :steps
  end
end
