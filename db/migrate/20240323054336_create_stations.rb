class CreateStations < ActiveRecord::Migration[7.1]
  def change
    create_table :stations do |t|
      t.string :name, null: false, index: { unique: true }
      t.float :longitude, null: false
      t.float :latitude, null: false
      t.float :clockwise_distance_to_next, null: false
      t.integer :clockwise_next_station_id, null: false, index: { unique: true }

      t.timestamps
    end
    add_index :stations, [:longitude, :latitude],  unique: true
  end
end
