class CreateArrivals < ActiveRecord::Migration[7.1]
  def change
    create_table :arrivals do |t|
      t.belongs_to :walk, foreign_key: true
      t.belongs_to :station, foreign_key: true
      t.string :memo
      t.timestamp :arrived_at, precision: 6, null: false

      t.timestamps
    end
  end
end
