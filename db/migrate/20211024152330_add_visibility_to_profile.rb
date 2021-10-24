# frozen_string_literal: true

# Visibility will allow us to store who can see a profile
class AddVisibilityToProfile < ActiveRecord::Migration[6.1]
  def change
    add_column :profiles, :visibility, :integer, default: 1
  end
end
