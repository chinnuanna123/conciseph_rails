class DeviseTokenAuthCreateUsers < ActiveRecord::Migration[6.0]
  def change
    
    if (ActiveRecord::Base.connection.table_exists? :users)
      add_column :users, :provider, :string, :null => false, :default => "email" unless column_exists? :users, :provider
      add_column :users, :uid, :string, :null => false, :default => "" unless column_exists? :users, :uid
      add_column :users, :name, :string unless column_exists? :users, :name
      add_column :users, :nickname, :string unless column_exists? :users, :nickname
      add_column :users, :image, :string unless column_exists? :users, :image
      add_column :users, :email, :string unless column_exists? :users, :email
      add_column :users, :tokens, :json unless column_exists? :users, :tokens

       ## Recoverable
      add_column :users, :reset_password_token, :string unless column_exists? :users, :reset_password_token
      add_column :users, :reset_password_sent_at, :datetime unless column_exists? :users, :reset_password_sent_at
      add_column :users, :allow_password_change, :boolean, :default => false unless column_exists? :users, :allow_password_change

       ## Rememberable
      add_column :users, :remember_created_at, :datetime unless column_exists? :users, :remember_created_at

       ## Trackable
      add_column :users, :sign_in_count, :integer, :default => 0, :null => false unless column_exists? :users, :sign_in_count
      add_column :users, :current_sign_in_at, :datetime unless column_exists? :users, :current_sign_in_at
      add_column :users, :last_sign_in_at, :datetime unless column_exists? :users, :last_sign_in_at
      add_column :users, :current_sign_in_ip, :string unless column_exists? :users, :current_sign_in_ip
      add_column :users, :last_sign_in_ip, :string unless column_exists? :users, :last_sign_in_ip

       ## Confirmable
      add_column :users, :confirmation_token, :string unless column_exists? :users, :confirmation_token
      add_column :users, :confirmed_at, :datetime unless column_exists? :users, :confirmed_at
      add_column :users, :confirmation_sent_at, :datetime unless column_exists? :users, :confirmation_sent_at
      add_column :users, :unconfirmed_email, :string unless column_exists? :users, :unconfirmed_email # Only if using reconfirmable


    else
      create_table(:users) do |t|
        ## Required
        t.string :provider, :null => false, :default => "email"
        t.string :uid, :null => false, :default => ""

        ## Database authenticatable
        t.string :encrypted_password, :null => false, :default => ""

        ## Recoverable
        t.string   :reset_password_token
        t.datetime :reset_password_sent_at
        t.boolean  :allow_password_change, :default => false

        ## Rememberable
        t.datetime :remember_created_at

        ## Trackable
        t.integer  :sign_in_count, :default => 0, :null => false
        t.datetime :current_sign_in_at
        t.datetime :last_sign_in_at
        t.string   :current_sign_in_ip
        t.string   :last_sign_in_ip

        ## Confirmable
        t.string   :confirmation_token
        t.datetime :confirmed_at
        t.datetime :confirmation_sent_at
        t.string   :unconfirmed_email # Only if using reconfirmable

        ## Lockable
        # t.integer  :failed_attempts, :default => 0, :null => false # Only if lock strategy is :failed_attempts
        # t.string   :unlock_token # Only if unlock strategy is :email or :both
        # t.datetime :locked_at

        ## User Info
        t.string :name
        t.string :nickname
        t.string :image
        t.string :email

        ## Tokens
        t.json :tokens

        t.timestamps
      end

      add_index :users, :email,                unique: true
      add_index :users, [:uid, :provider],     unique: true
      add_index :users, :reset_password_token, unique: true
      add_index :users, :confirmation_token,   unique: true
    end
    # add_index :users, :unlock_token,       unique: true
  end
end
