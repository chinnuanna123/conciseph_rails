class AddKindToDocumentType < ActiveRecord::Migration[6.0]
  def change
    add_column :document_types, :kind, :integer, default: 0
  end
end
