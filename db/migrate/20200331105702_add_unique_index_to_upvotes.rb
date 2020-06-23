class AddUniqueIndexToUpvotes < ActiveRecord::Migration[6.0]
  def change
    add_index :upvotes, [:resource_id, :ip_address], unique: true
  end
end
