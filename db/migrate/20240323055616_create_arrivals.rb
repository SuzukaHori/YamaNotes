class CreateArrivals < ActiveRecord::Migration[7.1]
  def change
    create_table :arrivals do |t|
      t.belongs_to :walk, index: { unique: true }, foreign_key: true
      t.belongs_to :station, index: { unique: true }, foreign_key: true
      t.string :memo
      t.date :arrived_at

      t.timestamps
    end
  end
end
