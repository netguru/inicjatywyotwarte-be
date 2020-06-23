class AddUpvotesCounterCacheToResources < ActiveRecord::Migration[6.0]
  def change
    add_column :resources, :upvotes_count, :integer
  end
end
