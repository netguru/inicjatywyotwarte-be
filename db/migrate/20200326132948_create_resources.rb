class CreateResources < ActiveRecord::Migration[6.0]
  def change
    create_table :resources do |t|
      t.string :name, null: false
      t.text :description
      t.string :target_url
      t.string :facebook_url
      t.string :ios_url
      t.string :android_url
      t.string :location

      t.timestamps
    end
  end
end
