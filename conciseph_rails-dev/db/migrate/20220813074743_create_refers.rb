class CreateRefers < ActiveRecord::Migration[6.0]
  def change
    create_table :refers do |t|
      t.string :name
      t.string :code
      t.integer :no_of_users, default: 0
      t.timestamps
    end
  end
end
