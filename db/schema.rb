# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_03_23_055616) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "arrivals", force: :cascade do |t|
    t.bigint "walk_id"
    t.bigint "station_id"
    t.string "memo"
    t.datetime "arrived_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["station_id"], name: "index_arrivals_on_station_id"
    t.index ["walk_id", "station_id"], name: "index_arrivals_on_walk_id_and_station_id", unique: true
    t.index ["walk_id"], name: "index_arrivals_on_walk_id"
  end

  create_table "stations", force: :cascade do |t|
    t.string "name", null: false
    t.float "longitude", null: false
    t.float "latitude", null: false
    t.float "clockwise_distance_to_next", null: false
    t.float "counterclockwise_distance_to_next", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.decimal "uid", null: false
    t.string "provider", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uid"], name: "index_users_on_uid", unique: true
  end

  create_table "walks", force: :cascade do |t|
    t.bigint "user_id"
    t.boolean "publish", default: false, null: false
    t.boolean "clockwise", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_walks_on_user_id", unique: true
  end

  add_foreign_key "arrivals", "stations"
  add_foreign_key "arrivals", "walks"
  add_foreign_key "walks", "users"
end
