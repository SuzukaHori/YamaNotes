# frozen_string_literal: true

class ChangeUniqueIndexOnWalksUserIdToActiveOnly < ActiveRecord::Migration[8.1]
  def change
    remove_index :walks, :user_id
    add_index :walks, :user_id, unique: true, where: "active = true"
  end
end
