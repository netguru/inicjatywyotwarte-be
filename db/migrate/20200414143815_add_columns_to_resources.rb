class AddColumnsToResources < ActiveRecord::Migration[6.0]
  def change
    add_column :resources, :organizer, :string
    add_column :resources, :contact, :string
    add_column :resources, :how_to_help, :text
  end
end
