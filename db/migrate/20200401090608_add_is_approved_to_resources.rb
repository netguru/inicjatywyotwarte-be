class AddIsApprovedToResources < ActiveRecord::Migration[6.0]
  def change
    add_column :resources, :is_approved, :boolean, default: false
  end
end
