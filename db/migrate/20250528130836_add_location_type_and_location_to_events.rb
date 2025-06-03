class AddLocationTypeAndLocationToEvents < ActiveRecord::Migration[7.1]
  # Add location type to support both physical and online events
  def up
    add_column :events, :location_type, :string, default: 'online', null: false
  end

  def down
    remove_column :events, :location_type if column_exists?(:events, :location_type)
  end
end
