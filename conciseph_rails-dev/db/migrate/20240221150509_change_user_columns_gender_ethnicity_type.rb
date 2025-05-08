class ChangeUserColumnsGenderEthnicityType < ActiveRecord::Migration[6.0]
  def up
    change_column :users, :gender, 'integer USING CAST(gender AS integer)'
    change_column :users, :ethnicity, 'integer USING CAST(ethnicity AS integer)'
  end

  def down
    change_column :users, :gender, :string
    change_column :users, :ethnicity, :string
  end
end
