class AddIndexArrivalsCreatedAt < ActiveRecord::Migration[7.1]
  def change
    add_index :arrivals, :created_at
  end
end
