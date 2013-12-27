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

ActiveRecord::Schema.define(version: 20131222223749) do

  create_table "concious_measurements", force: true do |t|
    t.integer  "patient_id"
    t.string   "value"
    t.datetime "datetime"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "dia_bp_measurements", force: true do |t|
    t.integer  "patient_id"
    t.float    "value"
    t.datetime "datetime"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "oxygen_sat_measurements", force: true do |t|
    t.integer  "patient_id"
    t.float    "value"
    t.datetime "datetime"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "oxygen_supp_measurements", force: true do |t|
    t.integer  "patient_id"
    t.boolean  "value"
    t.datetime "datetime"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "patients", force: true do |t|
    t.string   "mrn"
    t.string   "given_name"
    t.string   "surname"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "ward"
  end

  create_table "pulse_measurements", force: true do |t|
    t.integer  "patient_id"
    t.float    "value"
    t.datetime "datetime"
  end

  create_table "respiration_rate_measurements", force: true do |t|
    t.integer  "patient_id"
    t.float    "value"
    t.datetime "datetime"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sys_bp_measurements", force: true do |t|
    t.integer  "patient_id"
    t.float    "value"
    t.datetime "datetime"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "temperature_measurements", force: true do |t|
    t.integer  "patient_id"
    t.float    "value"
    t.datetime "datetime"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
