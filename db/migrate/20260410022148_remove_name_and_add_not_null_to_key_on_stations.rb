class RemoveNameAndAddNotNullToKeyOnStations < ActiveRecord::Migration[8.1]
  def change
    remove_column :stations, :name, :string, null: false
    change_column_null :stations, :key, false
  end
end
