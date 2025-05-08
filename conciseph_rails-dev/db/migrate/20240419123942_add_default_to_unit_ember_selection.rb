class AddDefaultToUnitEmberSelection < ActiveRecord::Migration[6.0]
  def change
    change_column_default :member_selections, :unit, 0
  end
end
