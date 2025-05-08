class CreateUserActions < ActiveRecord::Migration[6.0]
  def change
    create_table :user_actions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :actionable, polymorphic: true, null: false
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
