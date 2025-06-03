# Add coordinates for event locations to support geocoding
class AddCoordinatesToEvents < ActiveRecord::Migration[7.1]
  def change
    change_table :events, bulk: true do |t|
      t.float :latitude
      t.float :longitude
    end
  end
end
