class CreatePayments < ActiveRecord::Migration[6.0]
  def change
    create_table :payments do |t|
      t.integer :user_id
      t.float :amount
      t.string :currency
      t.datetime :expiry_date
      t.string :purchase_id
      t.string :order_id
      t.string :sku_code
      t.string :purchase_type
      t.boolean :active, default: false

      t.timestamps
    end
    add_index :payments, :user_id
  end
end
