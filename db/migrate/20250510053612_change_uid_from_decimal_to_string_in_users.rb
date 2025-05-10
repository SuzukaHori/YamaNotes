class ChangeUidFromDecimalToStringInUsers < ActiveRecord::Migration[8.0]
  def change
    change_column :users, :uid, :string
  end
end
