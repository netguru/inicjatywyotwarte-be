class RemoveApplications < ActiveRecord::Migration[6.0]
  def up
    drop_table :applications
  end

  def down
    create_table :applications do |t|
      t.string :name
    end
  end
end
