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

ActiveRecord::Schema.define(version: 20150718155208) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "devices", force: :cascade do |t|
    t.string   "human_id"
    t.string   "sim_card_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "event_isopts", force: :cascade do |t|
    t.datetime "held_at"
    t.string   "venue_name"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.boolean  "is_activated",        default: false
    t.datetime "started_at"
    t.datetime "ended_at"
    t.boolean  "is_ended"
    t.string   "tz_offset",           default: "-0500"
    t.boolean  "is_resettable",       default: true
    t.string   "title"
    t.boolean  "is_published",        default: false
    t.text     "consensus_time_code"
  end

  create_table "moment_records", force: :cascade do |t|
    t.integer  "milliseconds"
    t.datetime "submitted_at"
    t.integer  "user_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "user_device_logs", force: :cascade do |t|
    t.integer  "user_device_id"
    t.text     "description"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "user_devices", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "device_id"
    t.integer  "event_isopt_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.string   "password_digest"
    t.boolean  "admin"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "init_time"
    t.boolean  "is_initialized",  default: false
    t.datetime "init_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "username"
  end

end
