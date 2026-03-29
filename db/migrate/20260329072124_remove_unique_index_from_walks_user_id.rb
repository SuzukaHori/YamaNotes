class RemoveUniqueIndexFromWalksUserId < ActiveRecord::Migration[8.1]
  def change
    remove_index :walks, :user_id
    add_index :walks, :user_id
  end
end
