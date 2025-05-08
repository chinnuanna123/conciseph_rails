class AddReferToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :referred_by, :text
  end
end
