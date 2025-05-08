class CreateSupportNeeds < ActiveRecord::Migration[6.0]
  def change
    create_table :support_needs do |t|
      t.integer :name, default: 4
      t.string :prefered_days, array: true, default: []
      t.integer :prefered_times
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
