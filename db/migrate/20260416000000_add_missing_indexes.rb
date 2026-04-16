# frozen_string_literal: true

class AddMissingIndexes < ActiveRecord::Migration[8.1]
  def change
    rename_index :walks, "index_walks_on_user_id", "index_walks_on_user_id_active"
    add_index :walks, :user_id, name: "index_walks_on_user_id"
    add_index :arrivals, [:walk_id, :created_at], name: "index_arrivals_on_walk_id_and_created_at"
  end
end
