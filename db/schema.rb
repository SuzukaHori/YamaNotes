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

ActiveRecord::Schema[8.1].define(version: 2026_04_13_104603) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "arrivals", force: :cascade do |t|
    t.datetime "arrived_at", precision: nil, null: false
    t.datetime "created_at", null: false
    t.string "memo", limit: 255, default: "", null: false
    t.bigint "station_id"
    t.datetime "updated_at", null: false
    t.bigint "walk_id"
    t.index ["created_at"], name: "index_arrivals_on_created_at"
    t.index ["station_id"], name: "index_arrivals_on_station_id"
    t.index ["walk_id"], name: "index_arrivals_on_walk_id"
  end

  create_table "gps_points", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.float "latitude", null: false
    t.float "longitude", null: false
    t.datetime "recorded_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "walk_id", null: false
    t.index ["walk_id", "recorded_at"], name: "index_gps_points_on_walk_id_and_recorded_at"
    t.index ["walk_id"], name: "index_gps_points_on_walk_id"
  end

  create_table "stations", force: :cascade do |t|
    t.float "clockwise_distance_to_next", null: false
    t.integer "clockwise_next_station_id", null: false
    t.datetime "created_at", null: false
    t.string "key", null: false
    t.float "latitude", null: false
    t.float "longitude", null: false
    t.datetime "updated_at", null: false
    t.index ["clockwise_next_station_id"], name: "index_stations_on_clockwise_next_station_id", unique: true
    t.index ["key"], name: "index_stations_on_key", unique: true
    t.index ["longitude", "latitude"], name: "index_stations_on_longitude_and_latitude", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "provider", null: false
    t.datetime "remember_created_at"
    t.text "remember_token"
    t.decimal "uid", null: false
    t.datetime "updated_at", null: false
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
  end

  create_table "walks", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.boolean "clockwise", default: true, null: false
    t.datetime "created_at", null: false
    t.boolean "publish", default: false, null: false
    t.boolean "tracking", default: false, null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_walks_on_user_id", unique: true, where: "(active = true)"
  end

  add_foreign_key "arrivals", "stations"
  add_foreign_key "arrivals", "walks"
  add_foreign_key "gps_points", "walks"
  add_foreign_key "walks", "users"
end
