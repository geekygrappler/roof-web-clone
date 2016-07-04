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

ActiveRecord::Schema.define(version: 20160317075032) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "user_id"
    t.string   "user_type"
  end

  add_index "accounts", ["email"], name: "index_accounts_on_email", unique: true, using: :btree
  add_index "accounts", ["reset_password_token"], name: "index_accounts_on_reset_password_token", unique: true, using: :btree
  add_index "accounts", ["user_type", "user_id"], name: "index_accounts_on_user_type_and_user_id", using: :btree

  create_table "appointments", force: :cascade do |t|
    t.integer  "project_id"
    t.integer  "host_id"
    t.string   "host_type"
    t.integer  "attendant_id"
    t.string   "attendant_type"
    t.jsonb    "data",           default: {}
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "appointments", ["attendant_type", "attendant_id"], name: "index_appointments_on_attendant_type_and_attendant_id", using: :btree
  add_index "appointments", ["host_type", "host_id"], name: "index_appointments_on_host_type_and_host_id", using: :btree
  add_index "appointments", ["project_id"], name: "index_appointments_on_project_id", using: :btree

  create_table "assets", force: :cascade do |t|
    t.integer  "project_id"
    t.string   "file"
    t.integer  "file_size"
    t.string   "content_type"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "assets", ["content_type"], name: "index_assets_on_content_type", using: :btree
  add_index "assets", ["project_id"], name: "index_assets_on_project_id", using: :btree

  create_table "leads", force: :cascade do |t|
    t.jsonb    "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "materials", force: :cascade do |t|
    t.jsonb    "data",       default: {}
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "payments", force: :cascade do |t|
    t.integer  "project_id"
    t.integer  "professional_id"
    t.integer  "quote_id"
    t.integer  "customer_id"
    t.jsonb    "data",            default: {}
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "payments", ["customer_id"], name: "index_payments_on_customer_id", using: :btree
  add_index "payments", ["professional_id"], name: "index_payments_on_professional_id", using: :btree
  add_index "payments", ["project_id"], name: "index_payments_on_project_id", using: :btree
  add_index "payments", ["quote_id"], name: "index_payments_on_quote_id", using: :btree

  create_table "projects", force: :cascade do |t|
    t.integer  "account_id"
    t.jsonb    "data",       default: {}
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "projects", ["account_id"], name: "index_projects_on_account_id", using: :btree

  create_table "quotes", force: :cascade do |t|
    t.integer  "tender_id"
    t.integer  "professional_id"
    t.integer  "project_id"
    t.jsonb    "data",            default: {}
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "quotes", ["professional_id"], name: "index_quotes_on_professional_id", using: :btree
  add_index "quotes", ["project_id"], name: "index_quotes_on_project_id", using: :btree
  add_index "quotes", ["tender_id"], name: "index_quotes_on_tender_id", using: :btree

  create_table "tasks", force: :cascade do |t|
    t.jsonb    "data",       default: {}
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "tender_templates", force: :cascade do |t|
    t.jsonb    "data",       default: {}
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "tenders", force: :cascade do |t|
    t.integer  "tender_template_id"
    t.integer  "project_id"
    t.jsonb    "data",               default: {}
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "tenders", ["project_id"], name: "index_tenders_on_project_id", using: :btree
  add_index "tenders", ["tender_template_id"], name: "index_tenders_on_tender_template_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.integer  "account_id"
    t.string   "type"
    t.jsonb    "data",       default: {}
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "users", ["account_id"], name: "index_users_on_account_id", using: :btree
  add_index "users", ["id", "type"], name: "index_users_on_id_and_type", unique: true, using: :btree

  add_foreign_key "appointments", "projects"
  add_foreign_key "assets", "projects"
  add_foreign_key "payments", "projects"
  add_foreign_key "payments", "quotes"
  add_foreign_key "projects", "accounts"
  add_foreign_key "quotes", "projects"
  add_foreign_key "quotes", "tenders"
  add_foreign_key "tenders", "projects"
  add_foreign_key "tenders", "tender_templates"
  add_foreign_key "users", "accounts"
end
