class AddKindToSymptoms < ActiveRecord::Migration[6.0]
  def change
    add_column :symptoms, :kind, :integer, default: 0
  end
end
