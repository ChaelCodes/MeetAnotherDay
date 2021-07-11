# frozen_string_literal: true

# This migration generates the profiles table
class CreateProfiles < ActiveRecord::Migration[6.1]
  def change
    create_table :profiles do |t|
      t.string :name
      t.string :handle
      t.string :bio
      t.references :user

      t.timestamps
    end
  end
end
