class ChangeTrackingFor < ActiveRecord::Migration[6.0]
  def change
    change_column :trackings, :tracking_for, 'integer USING CAST(tracking_for AS integer)'
  end
end
