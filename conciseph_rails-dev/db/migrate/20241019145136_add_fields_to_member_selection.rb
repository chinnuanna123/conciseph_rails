class AddFieldsToMemberSelection < ActiveRecord::Migration[6.0]
  def change
    change_table :member_selections do |t|
      t.string :link_to_type
      t.integer :link_to_id
      t.integer :milestone_id
      t.integer :status
    end
  end
end
