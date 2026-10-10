# frozen_string_literal: true

class AddReasonToSuspensions < ActiveRecord::Migration[8.1]
  def change
    add_column :suspensions, :reason, :string, limit: 255, default: '', null: false
  end
end
