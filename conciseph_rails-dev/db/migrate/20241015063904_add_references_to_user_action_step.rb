class AddReferencesToUserActionStep < ActiveRecord::Migration[6.0]
  def change
    add_reference :user_action_steps, :user_action_milestone, foreign_key: true
  end
end
