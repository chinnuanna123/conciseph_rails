class CreateCustomTemplates < ActiveRecord::Migration[6.0]
  def change
    create_table :custom_templates do |t|
      t.string :name
      t.text :description
      t.string :icon
      t.integer :functional_area
      t.integer :campaign_name
      t.integer :category
      t.integer :section
      t.boolean :is_active, default: false
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
