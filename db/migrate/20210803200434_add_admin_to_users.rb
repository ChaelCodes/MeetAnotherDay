# frozen_string_literal: true

# Add an admin column to users table
class AddAdminToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :admin, :bool
  end
end
