class ChangeMemoLimitInArrivals < ActiveRecord::Migration[6.0]
  def up
    change_column :arrivals, :memo, :string, limit: 255
  end

  def down
    change_column :arrivals, :memo, :string, limit: 140
  end
end

