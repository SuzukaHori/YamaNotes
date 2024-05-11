class CreateArrivals < ActiveRecord::Migration[7.1]
  def change
    create_table :arrivals do |t|
      t.belongs_to :walk, foreign_key: true
      t.belongs_to :station, foreign_key: true
      t.string :memo, limit: 140
      t.timestamp :arrived_at, precision: 0, null: false

      t.timestamps
    end
  end
end
