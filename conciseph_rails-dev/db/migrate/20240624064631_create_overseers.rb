class CreateOverseers < ActiveRecord::Migration[6.0]
  def change
    create_table :overseers do |t|
      t.string :name, null: false
      t.string :email, null: false, index: { unique: true }
      t.string :password_digest, null: false
      t.integer :role, default: 0


      t.timestamps
    end
    add_index :overseers, :email, unique: true unless index_exists?(:overseers, :email)
  end
end
