class RemoveUniqueConstraintFromWalks < ActiveRecord::Migration[6.0]
  def change
    remove_index :walks, :user_id, unique: true
    add_index :walks, :user_id
  end
end
