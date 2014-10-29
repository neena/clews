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

ActiveRecord::Schema.define(version: 20141029132417) do

  create_table "admins", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true

  create_table "observations", force: true do |t|
    t.integer  "patient_id"
    t.datetime "recorded_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "score",            default: 0
    t.integer  "rating",           default: 0
    t.string   "status",           default: "incomplete"
    t.string   "concious"
    t.float    "dia_bp"
    t.float    "sys_bp"
    t.float    "oxygen_sat"
    t.boolean  "oxygen_supp"
    t.float    "pulse"
    t.integer  "respiration_rate"
    t.float    "temperature"
    t.integer  "vip"
  end

  create_table "patients", force: true do |t|
    t.string   "mrn"
    t.string   "given_name"
    t.string   "surname"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "ward_id"
    t.datetime "observation_due_at"
    t.boolean  "mrsa_carrier"
    t.string   "sex"
    t.datetime "dob"
  end

  add_index "patients", ["ward_id"], name: "index_patients_on_ward_id"

  create_table "reminders", force: true do |t|
    t.string   "title"
    t.integer  "patient_id"
    t.string   "text"
    t.datetime "due"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "done",          default: false
    t.string   "reminder_type"
  end

  add_index "reminders", ["patient_id"], name: "index_reminders_on_patient_id"

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "rank"
    t.string   "given_name"
    t.string   "surname"
    t.string   "initials"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

  create_table "wards", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "emails"
  end

  create_table "waterlows", force: true do |t|
    t.float   "height"
    t.float   "weight"
    t.float   "bmi"
    t.string  "skin_type"
    t.string  "mobility"
    t.string  "continence"
    t.integer "nutrition_score"
    t.text    "special_risks"
    t.integer "patient_id"
    t.integer "score"
    t.string  "appetite"
  end

  add_index "waterlows", ["patient_id"], name: "index_waterlows_on_patient_id"

end
