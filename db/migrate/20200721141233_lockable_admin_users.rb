# frozen_string_literal: true

class LockableAdminUsers < ActiveRecord::Migration[6.0]
  def up
    change_table :admin_users do |t|
      ## Lockable
      t.column :failed_attempts, :integer,default: 0, null: false # Only if lock strategy is :failed_attempts
      t.column :unlock_token, :string   # Only if unlock strategy is :email or :both
      t.column :locked_at, :datetime
    end

    add_index :admin_users, :unlock_token, unique: true
  end

  def down
    remove_index :admin_users, :unlock_token
    change_table :admin_users do |t|
      ## Lockable
      t.remove :failed_attempts
      t.remove :unlock_token
      t.remove :locked_at
    end
  end
end
