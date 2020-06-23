class AddGooglePlaceIdToResources < ActiveRecord::Migration[6.0]
  def change
    add_column :resources, :google_place_id, :string, default: nil
  end
end
