class DeleteSymptomTypeFromSymptoms < ActiveRecord::Migration[6.0]
  def change
    remove_column :symptoms, :symptom_type
  end
end
