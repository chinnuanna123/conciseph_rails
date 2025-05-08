class CreateCareManagements < ActiveRecord::Migration[6.0]
  def change
    create_table :care_managements do |t|
        t.string :name
        t.integer :care_management_type, default: 0
        t.integer :care_management_category
        t.integer :status, default: 0
        t.date :start_date
        t.date :end_date
        t.integer :section, null: false
        t.text :description
        t.string :icon
        t.integer :owner_id
  
        t.index :owner_id, name: "index_care_managements_on_owner_id"
  
      t.timestamps
    end
  end
end
