# frozen_string_literal: true

class ChangeUidToStringInUsers < ActiveRecord::Migration[8.1]
  def up
    change_column :users, :uid, :string, null: false, using: 'uid::text'
  end

  def down
    change_column :users, :uid, :decimal, null: false, using: 'uid::decimal'
  end
end
