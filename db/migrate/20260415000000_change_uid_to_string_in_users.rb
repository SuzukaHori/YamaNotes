# frozen_string_literal: true

class ChangeUidToStringInUsers < ActiveRecord::Migration[8.1]
  def up
    change_column :users, :uid, :string, null: false
    User.find_each do |user|
      user.update_column(:uid, user.uid.to_i.to_s)
    end
  end

  def down
    change_column :users, :uid, :decimal, null: false, using: 'uid::numeric'
    User.find_each do |user|
      user.update_column(:uid, user.uid.to_d)
    end
  end
end
