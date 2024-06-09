# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.numeric :uid, null: false
      t.string :provider, null: false
      t.timestamps null: false
      t.timestamp :remember_created_at
    end
    add_index :users, [:uid, :provider],  unique: true
  end
end
