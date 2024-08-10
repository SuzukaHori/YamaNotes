class AddRememberFieldsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :remember_created_at, :datetime
    add_column :users, :remember_token, :text
  end
end
