class AddKeyToStations < ActiveRecord::Migration[8.1]
  def change
    add_column :stations, :key, :string
    add_index :stations, :key, unique: true
  end
end
