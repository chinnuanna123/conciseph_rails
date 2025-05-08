class ChangeColumnTypesMembers < ActiveRecord::Migration[6.0]
  def change
    change_column :members, :member_id, :string
    change_column :members, :birth_date, :string
  end
end
