class AddHasWebsiteBooleansToResource < ActiveRecord::Migration[6.0]
  def change
    add_column :resources, :has_website, :boolean, default: false
    add_column :resources, :has_facebook, :boolean, default: false
    add_column :resources, :has_ios, :boolean, default: false
    add_column :resources, :has_android, :boolean, default: false
  end
end
