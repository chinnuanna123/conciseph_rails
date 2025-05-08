class CreateTrackings < ActiveRecord::Migration[6.0]
  def change
    create_table :trackings do |t|
      t.integer :user_id
      t.string :tracking_for
      t.integer :counter, :default => 0

      t.timestamps
    end
  end
end
