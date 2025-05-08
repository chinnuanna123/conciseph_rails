class CreateHealthEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :health_events do |t|
      t.string :name
      t.integer :health_event_type
      t.integer :health_event_category
      t.integer :status, default: 0
      t.date :start_date
      t.date :end_date
      t.integer :section, null: false
      t.text :description, :text
      t.string :icon, :string

      t.timestamps
    end
  end
end
