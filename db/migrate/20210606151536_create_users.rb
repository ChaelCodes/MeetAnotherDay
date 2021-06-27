# frozen_string_literal: true

# This is for the User table. This table should contain user data
# for login and access purposes. Profiles will manage permissions
# and conference visits.
class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :bio

      t.timestamps
    end
  end
end
