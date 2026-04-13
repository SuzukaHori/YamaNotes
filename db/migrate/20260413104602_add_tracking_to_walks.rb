class AddTrackingToWalks < ActiveRecord::Migration[8.1]
  def change
    add_column :walks, :tracking, :boolean, default: false, null: false
  end
end
