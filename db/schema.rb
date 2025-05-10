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

ActiveRecord::Schema[8.0].define(version: 2025_05_10_053612) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "arrivals", force: :cascade do |t|
    t.bigint "walk_id"
    t.bigint "station_id"
    t.string "memo", limit: 255, default: "", null: false
    t.datetime "arrived_at", precision: nil, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_arrivals_on_created_at"
    t.index ["station_id"], name: "index_arrivals_on_station_id"
    t.index ["walk_id"], name: "index_arrivals_on_walk_id"
  end

  create_table "stations", force: :cascade do |t|
    t.string "name", null: false
    t.float "longitude", null: false
    t.float "latitude", null: false
    t.float "clockwise_distance_to_next", null: false
    t.integer "clockwise_next_station_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["clockwise_next_station_id"], name: "index_stations_on_clockwise_next_station_id", unique: true
    t.index ["longitude", "latitude"], name: "index_stations_on_longitude_and_latitude", unique: true
    t.index ["name"], name: "index_stations_on_name", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "uid", null: false
    t.string "provider", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "remember_created_at"
    t.text "remember_token"
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
  end

  create_table "walks", force: :cascade do |t|
    t.bigint "user_id"
    t.boolean "publish", default: false, null: false
    t.boolean "clockwise", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "arrivals", "stations"
  add_foreign_key "arrivals", "walks"
  add_foreign_key "walks", "users"
end
