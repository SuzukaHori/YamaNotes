# frozen_string_literal: true

class AddActiveToWalks < ActiveRecord::Migration[7.2]
  def change
    add_column :walks, :active, :boolean, default: true, null: false
  end
end
