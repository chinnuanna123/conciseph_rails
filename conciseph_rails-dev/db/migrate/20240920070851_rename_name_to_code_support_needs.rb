class RenameNameToCodeSupportNeeds < ActiveRecord::Migration[6.0]
  def change
    rename_column :support_needs, :name, :code
  end
end
