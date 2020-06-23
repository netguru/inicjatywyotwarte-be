class AddRoleToAdminUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :admin_users, :role, :string, null: false, default: 'reviewer'
  end
end
