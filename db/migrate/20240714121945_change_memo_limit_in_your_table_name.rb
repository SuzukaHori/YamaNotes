class ChangeMemoLimitInYourTableName < ActiveRecord::Migration[6.0]
  def up
    change_column :arrivals, :memo, :string, limit: 150
  end

  def down
    change_column :arrivals, :memo, :string, limit: 140
  end
end
