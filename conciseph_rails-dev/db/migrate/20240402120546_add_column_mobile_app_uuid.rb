class AddColumnMobileAppUuid < ActiveRecord::Migration[6.0]
  def change
    add_column :medications, :mobile_app_uuid, :uuid, index:true
    add_column :medication_timings, :mobile_app_uuid, :uuid, index:true
  end
end
