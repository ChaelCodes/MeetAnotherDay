# frozen_string_literal: true

# Remove name and bio as Profile already tracks name and bio
class RemoveNameAndBioFromUsers < ActiveRecord::Migration[7.1]
  def change
    change_table :users, bulk: true do |t|
      t.remove :name, type: :string
      t.remove :bio, type: :string
    end
  end
end
