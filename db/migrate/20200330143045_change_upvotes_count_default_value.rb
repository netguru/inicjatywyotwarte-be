class ChangeUpvotesCountDefaultValue < ActiveRecord::Migration[6.0]
  def change
    change_column_default :resources, :upvotes_count, 0
    change_column_null :resources, :upvotes_count, false
  end
end
