class CreateImmunizations < ActiveRecord::Migration[6.0]
  def change
    create_table :immunizations do |t|
      t.string :name
      t.string :code

      t.timestamps
    end
  end
end
