class AddLocationTypeAndLocationToEvents < ActiveRecord::Migration[7.1]
  def up
    add_column :events, :location_type, :string, null: false
  end

  def down
    remove_column :events, :location_type if column_exists?(:events, :location_type)
  end
end
