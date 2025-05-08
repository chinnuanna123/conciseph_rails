class AddKindToImmunization < ActiveRecord::Migration[6.0]
  def change
    add_column :immunizations, :kind, :integer, default: 0
  end
end
