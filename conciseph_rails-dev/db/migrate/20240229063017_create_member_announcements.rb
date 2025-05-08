class CreateMemberAnnouncements < ActiveRecord::Migration[6.0]
  def change
    create_table :announcements do |t|
      t.string :name
      t.integer :announcement_type
      t.integer :announcement_category
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
