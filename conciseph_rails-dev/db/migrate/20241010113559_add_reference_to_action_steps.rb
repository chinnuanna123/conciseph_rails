class AddReferenceToActionSteps < ActiveRecord::Migration[6.0]
  def change
    add_reference :action_steps, :milestone, index: true
    Rake::Task['milestones:update'].invoke
    remove_column :action_steps, :actionable_id, :bigint
    remove_column :action_steps, :actionable_type, :string
  end
end
