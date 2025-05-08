class AddKindToSpeciality < ActiveRecord::Migration[6.0]
  def change
    add_column :specialities, :kind, :integer, default: 0
  end
end
