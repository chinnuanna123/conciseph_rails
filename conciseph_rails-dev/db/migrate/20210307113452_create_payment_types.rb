class CreatePaymentTypes < ActiveRecord::Migration[6.0]
  def change
    create_table :payment_types do |t|
      t.string :name
      t.string :code

      t.timestamps
    end
  end
end
