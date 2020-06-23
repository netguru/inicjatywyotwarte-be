class AddDraftDescriptionToResources < ActiveRecord::Migration[6.0]
  def change
    add_column :resources, :draft_description, :text
  end
end
