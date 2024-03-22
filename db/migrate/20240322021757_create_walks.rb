class CreateWalks < ActiveRecord::Migration[7.1]
  def change
    create_table :walks do |t|
      t.belongs_to :user, index: { unique: true }, foreign_key: true
      t.boolean :publish, null: false, default: false
      t.boolean :clockwise, null: false, default: true

      t.timestamps
    end
  end
end
