class AddKindToPaymentType < ActiveRecord::Migration[6.0]
  def change
    add_column :payment_types, :kind, :integer, default: 0
  end
end
