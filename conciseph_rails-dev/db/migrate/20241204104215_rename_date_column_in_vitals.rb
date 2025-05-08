class RenameDateColumnInVitals < ActiveRecord::Migration[6.0]
  def change
    rename_column :vitals, :date, :vital_date
  end
end
