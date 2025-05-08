class AddSymptomsTypeToSymptoms < ActiveRecord::Migration[6.0]
  def change
    add_column :symptoms, :symptom_type, :string, :default=> "general"
  end
end
