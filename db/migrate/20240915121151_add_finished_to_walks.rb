class AddFinishedToWalks < ActiveRecord::Migration[7.2]
  def change
    add_column :walks, :finished, :boolean, default: false, null: false
  end
end
