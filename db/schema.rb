# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140501192814) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "boards", force: true do |t|
    t.integer  "height"
    t.integer  "width"
    t.integer  "grid_width"
    t.integer  "grid_height"
    t.integer  "boardable_id"
    t.string   "boardable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "games", force: true do |t|
    t.integer  "battleship_id"
    t.string   "name"
    t.string   "email"
    t.string   "game_status"
    t.string   "prize"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "nukes", force: true do |t|
    t.integer  "x_position"
    t.integer  "y_position"
    t.string   "status"
    t.integer  "nukeable_id"
    t.string   "nukeable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "oponents", force: true do |t|
    t.integer  "game_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "players", force: true do |t|
    t.integer  "game_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ships", force: true do |t|
    t.string   "name"
    t.integer  "size"
    t.string   "status"
    t.integer  "location_x"
    t.integer  "location_y"
    t.string   "direction"
    t.integer  "shipable_id"
    t.string   "shipable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
