class AddRememberCreatedAtToUsers < ActiveRecord::Migration[7.1]
  def change
    change_table :users do |t|
      t.timestamp :remember_created_at
    end
  end
end
