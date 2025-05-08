class CreatePetServiceProviders < ActiveRecord::Migration[6.0]
  def change
    create_table :pet_service_providers do |t|
      t.string :code
      t.text :name
      t.integer :kind, :default =>  0
      t.timestamps
    end
  end
end
