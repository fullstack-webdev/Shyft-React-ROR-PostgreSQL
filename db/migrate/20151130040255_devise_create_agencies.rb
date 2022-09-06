class DeviseCreateAgencies < ActiveRecord::Migration
  def change
    create_table(:agencies) do |t|
      ## Database authenticatable
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.inet     :current_sign_in_ip
      t.inet     :last_sign_in_ip

      ## Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      t.string   :unlock_token # Only if unlock strategy is :email or :both
      t.datetime :locked_at

      t.timestamps null: false

      ## Other Properties      
      t.string :phone_number, null: false, default: ""
      t.string :city, null: false, default: ""
      t.string :state, null: false, default: ""
      t.string :address1, null: false, default: ""
      t.string :address2, null: false, default: ""
      t.string :company_name, null: false, default: ""
      t.string :profile_image_id, null: false, default: ""
      t.boolean :phone_confirmed, default: false
      t.boolean :email_confirmed, default: false
      t.boolean :activated, default: false

    end

    add_index :agencies, :email,                unique: true
    add_index :agencies, :phone_number,         unique: true    
    add_index :agencies, :reset_password_token, unique: true
    add_index :agencies, :confirmation_token,   unique: true
    add_index :agencies, :unlock_token,         unique: true
  end
end
