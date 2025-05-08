class CreateVitals < ActiveRecord::Migration[6.0]
  def change
    create_table :vitals do |t|
      t.integer :vital_type
      t.references :user
      t.float :value
      t.datetime :date
      t.string :unit
      t.string :type1
      t.string :type2
      t.string :type3

      t.timestamps
    end
  end
end
