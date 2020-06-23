class CreateUpvote < ActiveRecord::Migration[6.0]
  def change
    create_table :upvotes do |t|
      t.inet :ip_address, null: false
      t.references :resource, index: true

      t.timestamps
    end
  end
end
