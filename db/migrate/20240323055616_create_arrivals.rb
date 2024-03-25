class CreateArrivals < ActiveRecord::Migration[7.1]
  def change
    create_table :arrivals do |t|
      t.belongs_to :walk, foreign_key: true
      t.belongs_to :station, foreign_key: true
      t.string :memo
      t.timestamp :arrived_at, precision: 6

      t.timestamps
    end
    add_index :arrivals, [:walk_id, :station_id], unique: true
  end
end
