class CreateMembers < ActiveRecord::Migration[6.0]
  def change
    create_table :members do |t|
      t.integer :member_id, null: false , unique: true
      t.string :name, null: false
      t.string :email, null: false , unique: true
      t.string :phone, null: false , unique: true
      t.date :birth_date
      t.string :gender
      t.string :ethnicity
      t.string :address
      t.string :city
      t.string :state
      t.string :zip_code
      t.integer :owner_id

      t.timestamps
    end
  end
end
