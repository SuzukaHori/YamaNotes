class CreateGpsPoints < ActiveRecord::Migration[8.1]
  def change
    create_table :gps_points do |t|
      t.references :walk, null: false, foreign_key: true
      t.float :latitude, null: false
      t.float :longitude, null: false
      t.datetime :recorded_at, null: false

      t.timestamps
    end
    add_index :gps_points, [:walk_id, :recorded_at]
  end
end
