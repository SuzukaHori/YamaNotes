class CreateStations < ActiveRecord::Migration[7.1]
  def change
    create_table :stations do |t|
      t.string :name, null: false
      t.float :longitude, null: false
      t.float :latitude, null: false
      t.float :clockwise_distance_to_next, null: false
      t.integer :clockwise_next_station_id

      t.timestamps
    end
  end
end
