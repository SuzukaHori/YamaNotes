# frozen_string_literal: true

class CreateSuspensions < ActiveRecord::Migration[8.1]
  def change
    create_table :suspensions do |t|
      t.references :walk, null: false, foreign_key: true
      t.datetime :started_at, null: false
      t.datetime :ended_at

      t.timestamps
    end

    add_index :suspensions, :walk_id, unique: true, where: 'ended_at IS NULL',
                                      name: 'index_suspensions_on_walk_id_ongoing'
  end
end
