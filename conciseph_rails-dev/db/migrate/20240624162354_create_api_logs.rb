class CreateApiLogs < ActiveRecord::Migration[6.0]
  def change
    create_table :api_logs do |t|
      t.text :url
      t.jsonb :payload
      t.string :response_code
      t.jsonb :response_body
      t.string :request_ip
      t.integer :overseer_id

      t.timestamps
    end
    add_index :api_logs, :overseer_id
  end
end
