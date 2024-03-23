class CreateStations < ActiveRecord::Migration[7.1]
  def change
    create_table :stations do |t|
      t.string :name, null: false
      t.float :longitude, null: false
      t.float :latitude, null: false
      t.float :clockwise_distance_to_next, null: false
      t.float :counterclockwise_distance_to_next, null: false

      t.timestamps
    end
  end
end
