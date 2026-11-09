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

ActiveRecord::Schema[8.1].define(version: 2026_11_13_032525) do
  create_table "route_stops", force: :cascade do |t|
    t.integer "route_id", null: false
    t.integer "stop_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["route_id", "stop_id"], name: "index_route_stops_on_route_id_and_stop_id", unique: true
    t.index ["route_id"], name: "index_route_stops_on_route_id"
    t.index ["stop_id"], name: "index_route_stops_on_stop_id"
  end

  create_table "routes", force: :cascade do |t|
    t.string "route_number"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["route_number"], name: "index_routes_on_route_number", unique: true
  end

  create_table "stops", force: :cascade do |t|
    t.integer "street_id", null: false
    t.integer "cross_street_id"
    t.integer "stop_number"
    t.string "name"
    t.string "direction"
    t.string "side"
    t.decimal "latitude", precision: 9, scale: 6
    t.decimal "longitude", precision: 9, scale: 6
    t.integer "departures_per_day"
    t.boolean "has_shelter"
    t.boolean "has_bench"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cross_street_id"], name: "index_stops_on_cross_street_id"
    t.index ["stop_number"], name: "index_stops_on_stop_number", unique: true
    t.index ["street_id"], name: "index_stops_on_street_id"
  end

  create_table "streets", force: :cascade do |t|
    t.integer "transit_id"
    t.string "name"
    t.string "street_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["transit_id"], name: "index_streets_on_transit_id", unique: true
  end

  add_foreign_key "route_stops", "routes"
  add_foreign_key "route_stops", "stops"
  add_foreign_key "stops", "streets"
  add_foreign_key "stops", "streets", column: "cross_street_id"
end
