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

ActiveRecord::Schema.define(version: 20140125134637) do

  create_table "concious_measurements", force: true do |t|
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "observation_id"
  end

  add_index "concious_measurements", ["observation_id"], name: "index_concious_measurements_on_observation_id"

  create_table "dia_bp_measurements", force: true do |t|
    t.float    "value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "observation_id"
  end

  add_index "dia_bp_measurements", ["observation_id"], name: "index_dia_bp_measurements_on_observation_id"

  create_table "observations", force: true do |t|
    t.integer  "patient_id"
    t.datetime "recorded_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "score",       default: 0
    t.integer  "rating",      default: 0
    t.string   "status",      default: "incomplete"
  end

  create_table "oxygen_sat_measurements", force: true do |t|
    t.float    "value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "observation_id"
  end

  add_index "oxygen_sat_measurements", ["observation_id"], name: "index_oxygen_sat_measurements_on_observation_id"

  create_table "oxygen_supp_measurements", force: true do |t|
    t.boolean  "value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "observation_id"
  end

  add_index "oxygen_supp_measurements", ["observation_id"], name: "index_oxygen_supp_measurements_on_observation_id"

  create_table "patients", force: true do |t|
    t.string   "mrn"
    t.string   "given_name"
    t.string   "surname"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "ward_id"
  end

  add_index "patients", ["ward_id"], name: "index_patients_on_ward_id"

  create_table "pulse_measurements", force: true do |t|
    t.float   "value"
    t.integer "observation_id"
  end

  add_index "pulse_measurements", ["observation_id"], name: "index_pulse_measurements_on_observation_id"

  create_table "respiration_rate_measurements", force: true do |t|
    t.float    "value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "observation_id"
  end

  add_index "respiration_rate_measurements", ["observation_id"], name: "index_respiration_rate_measurements_on_observation_id"

  create_table "sys_bp_measurements", force: true do |t|
    t.float    "value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "observation_id"
  end

  add_index "sys_bp_measurements", ["observation_id"], name: "index_sys_bp_measurements_on_observation_id"

  create_table "temperature_measurements", force: true do |t|
    t.float    "value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "observation_id"
  end

  add_index "temperature_measurements", ["observation_id"], name: "index_temperature_measurements_on_observation_id"

  create_table "wards", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
