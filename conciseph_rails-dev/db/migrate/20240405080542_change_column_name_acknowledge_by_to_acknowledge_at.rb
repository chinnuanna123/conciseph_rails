class ChangeColumnNameAcknowledgeByToAcknowledgeAt < ActiveRecord::Migration[6.0]
  def change
    change_table :user_actions do |t|
      t.rename :acknowledge_by, :acknowledge_at
      t.change :acknowledge_at, :datetime
    end
  end

  def down
    change_table :user_actions do |t|
      t.rename :acknowledge_at, :acknowledge_by
      t.change :acknowledge_by, :date
    end
  end
end
