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

ActiveRecord::Schema.define(version: 20161114124941) do

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

  create_table "activities", force: :cascade do |t|
    t.integer  "actor_id"
    t.string   "actor_type"
    t.integer  "subject_id"
    t.string   "subject_type"
    t.jsonb    "data",         default: {}
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "activities", ["actor_type", "actor_id"], name: "index_activities_on_actor_type_and_actor_id", using: :btree
  add_index "activities", ["subject_type", "subject_id"], name: "index_activities_on_subject_type_and_subject_id", using: :btree

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

  create_table "architects", force: :cascade do |t|
    t.string   "address_1"
    t.string   "address_2"
    t.string   "city"
    t.string   "postcode"
    t.string   "name"
    t.string   "email"
    t.string   "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "assets", force: :cascade do |t|
    t.integer  "project_id"
    t.string   "file"
    t.integer  "file_size"
    t.string   "content_type"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.jsonb    "meta"
    t.boolean  "file_processing", default: false, null: false
    t.string   "file_tmp"
  end

  add_index "assets", ["content_type"], name: "index_assets_on_content_type", using: :btree
  add_index "assets", ["project_id"], name: "index_assets_on_project_id", using: :btree

  create_table "backup_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "backups", force: :cascade do |t|
    t.string   "s3_url"
    t.integer  "document_id"
    t.integer  "backup_type_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "backups", ["backup_type_id"], name: "index_backups_on_backup_type_id", using: :btree
  add_index "backups", ["document_id"], name: "index_backups_on_document_id", using: :btree

  create_table "building_materials", force: :cascade do |t|
    t.string   "name"
    t.integer  "price",                default: 0
    t.integer  "building_material_id"
    t.integer  "section_id"
    t.integer  "location_id"
    t.boolean  "supplied"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "total",                default: 0
    t.text     "description"
    t.integer  "unit_id"
  end

  add_index "building_materials", ["building_material_id"], name: "index_building_materials_on_building_material_id", using: :btree
  add_index "building_materials", ["location_id"], name: "index_building_materials_on_location_id", using: :btree
  add_index "building_materials", ["section_id"], name: "index_building_materials_on_section_id", using: :btree
  add_index "building_materials", ["unit_id"], name: "index_building_materials_on_unit_id", using: :btree

  create_table "comments", force: :cascade do |t|
    t.integer  "account_id"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.jsonb    "data",                    default: {}
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.integer  "commentable_parent_id"
    t.string   "commentable_parent_type"
  end

  add_index "comments", ["account_id"], name: "index_comments_on_account_id", using: :btree
  add_index "comments", ["commentable_type", "commentable_id"], name: "index_comments_on_commentable_type_and_commentable_id", using: :btree

  create_table "content_pages", force: :cascade do |t|
    t.string   "pathname"
    t.text     "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "content_templates", force: :cascade do |t|
    t.text     "body"
    t.string   "path"
    t.string   "locale"
    t.string   "format"
    t.string   "handler"
    t.boolean  "partial"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "content_templates", ["path", "locale", "format", "handler", "partial"], name: "index_content_templates", unique: true, using: :btree

  create_table "csv_references", force: :cascade do |t|
    t.string   "key"
    t.integer  "database_objectable_id"
    t.string   "database_objectable_type"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "csv_references", ["database_objectable_type", "database_objectable_id"], name: "csv_ref_poly_index", using: :btree
  add_index "csv_references", ["key"], name: "index_csv_references_on_key", using: :btree

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "document_invitations", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "phone"
    t.boolean  "sent_email",  default: false
    t.integer  "document_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "document_invitations", ["document_id"], name: "index_document_invitations_on_document_id", using: :btree

  create_table "document_states", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "document_uploads", force: :cascade do |t|
    t.integer  "document_id"
    t.string   "s3_url"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "document_uploads", ["document_id"], name: "index_document_uploads_on_document_id", using: :btree

  create_table "documents", force: :cascade do |t|
    t.integer  "document_id"
    t.integer  "document_state_id"
    t.string   "name"
    t.integer  "total_cost_line_items",                default: 0
    t.integer  "total_cost_supplied_materials",        default: 0
    t.integer  "total_cost_supplied_by_pro_materials", default: 0
    t.integer  "total_cost",                           default: 0
    t.text     "notes"
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
    t.integer  "total_pro_costs",                      default: 0
    t.integer  "vat_amount"
    t.integer  "handling_fee_amount"
    t.integer  "architect_id"
  end

  add_index "documents", ["document_id"], name: "index_documents_on_document_id", using: :btree
  add_index "documents", ["document_state_id"], name: "index_documents_on_document_state_id", using: :btree

  create_table "failed_payments", force: :cascade do |t|
    t.jsonb    "data"
    t.string   "message"
    t.integer  "payment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "invitations", force: :cascade do |t|
    t.integer  "project_id"
    t.integer  "inviter_id"
    t.integer  "invitee_id"
    t.jsonb    "data",       default: {}
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "invitations", ["invitee_id"], name: "index_invitations_on_invitee_id", using: :btree
  add_index "invitations", ["inviter_id"], name: "index_invitations_on_inviter_id", using: :btree
  add_index "invitations", ["project_id"], name: "index_invitations_on_project_id", using: :btree

  create_table "item_actions", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "item_actions", ["name"], name: "index_item_actions_on_name", unique: true, using: :btree

  create_table "item_actions_items", id: false, force: :cascade do |t|
    t.integer "item_action_id"
    t.integer "item_id"
  end

  add_index "item_actions_items", ["item_action_id", "item_id"], name: "index_item_actions_items_on_item_action_id_and_item_id", unique: true, using: :btree
  add_index "item_actions_items", ["item_action_id"], name: "index_item_actions_items_on_item_action_id", using: :btree
  add_index "item_actions_items", ["item_id"], name: "index_item_actions_items_on_item_id", using: :btree

  create_table "item_specs", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "item_id"
  end

  add_index "item_specs", ["item_id"], name: "index_item_specs_on_item_id", using: :btree
  add_index "item_specs", ["name", "item_id"], name: "index_item_specs_on_name_and_item_id", unique: true, using: :btree

  create_table "items", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "items", ["name"], name: "index_items_on_name", unique: true, using: :btree

  create_table "leads", force: :cascade do |t|
    t.jsonb    "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "line_items", force: :cascade do |t|
    t.integer  "line_item_id"
    t.integer  "location_id"
    t.string   "name"
    t.string   "description"
    t.integer  "quantity",       default: 0
    t.integer  "rate",           default: 0
    t.integer  "total",          default: 0
    t.boolean  "admin_verified"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "stage_id"
    t.integer  "unit_id"
    t.boolean  "searchable",     default: false
    t.integer  "material_cost"
    t.string   "unit"
    t.integer  "item_id"
    t.integer  "item_action_id"
    t.integer  "item_spec_id"
    t.integer  "document_id"
  end

  add_index "line_items", ["document_id"], name: "index_line_items_on_document_id", using: :btree
  add_index "line_items", ["item_action_id"], name: "index_line_items_on_item_action_id", using: :btree
  add_index "line_items", ["item_id"], name: "index_line_items_on_item_id", using: :btree
  add_index "line_items", ["item_spec_id"], name: "index_line_items_on_item_spec_id", using: :btree
  add_index "line_items", ["line_item_id"], name: "index_line_items_on_line_item_id", using: :btree
  add_index "line_items", ["location_id"], name: "index_line_items_on_location_id", using: :btree
  add_index "line_items", ["stage_id"], name: "index_line_items_on_stage_id", using: :btree

  create_table "locations", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "document_id"
  end

  add_index "locations", ["document_id"], name: "index_locations_on_document_id", using: :btree

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

  create_table "rates", force: :cascade do |t|
    t.integer  "item_id"
    t.integer  "item_spec_id"
    t.integer  "item_action_id"
    t.integer  "rate"
    t.string   "formatted_rate"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "rates", ["item_action_id"], name: "index_rates_on_item_action_id", using: :btree
  add_index "rates", ["item_id"], name: "index_rates_on_item_id", using: :btree
  add_index "rates", ["item_spec_id"], name: "index_rates_on_item_spec_id", using: :btree

  create_table "stages", force: :cascade do |t|
    t.integer  "document_id"
    t.string   "name"
    t.text     "notes"
    t.integer  "total_cost_line_items",                default: 0
    t.integer  "total_cost_supplied_materials",        default: 0
    t.integer  "total_cost_supplied_by_pro_materials", default: 0
    t.integer  "total_cost",                           default: 0
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
    t.integer  "total_pro_costs",                      default: 0
  end

  add_index "stages", ["document_id"], name: "index_stages_on_document_id", using: :btree

  create_table "stat_types", force: :cascade do |t|
    t.string   "name"
    t.string   "metric"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "stats", force: :cascade do |t|
    t.integer  "enumerable_id"
    t.string   "enumerable_type"
    t.integer  "stat_type_id"
    t.integer  "statable_id"
    t.string   "statable_type"
    t.integer  "referenceable_id"
    t.string   "referenceable_type"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.decimal  "value"
  end

  add_index "stats", ["enumerable_type", "enumerable_id"], name: "index_stats_on_enumerable_type_and_enumerable_id", using: :btree
  add_index "stats", ["referenceable_type", "referenceable_id"], name: "index_stats_on_referenceable_type_and_referenceable_id", using: :btree
  add_index "stats", ["stat_type_id"], name: "index_stats_on_stat_type_id", using: :btree
  add_index "stats", ["statable_type", "statable_id"], name: "index_stats_on_statable_type_and_statable_id", using: :btree

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

  create_table "units", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "description"
    t.string   "abbreviation"
    t.integer  "power"
  end

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
  add_foreign_key "backups", "backup_types"
  add_foreign_key "backups", "documents"
  add_foreign_key "building_materials", "building_materials"
  add_foreign_key "building_materials", "locations"
  add_foreign_key "building_materials", "stages", column: "section_id"
  add_foreign_key "building_materials", "units"
  add_foreign_key "comments", "accounts"
  add_foreign_key "document_invitations", "documents"
  add_foreign_key "document_uploads", "documents"
  add_foreign_key "documents", "document_states"
  add_foreign_key "documents", "documents"
  add_foreign_key "invitations", "projects"
  add_foreign_key "item_specs", "items"
  add_foreign_key "line_items", "documents"
  add_foreign_key "line_items", "item_actions"
  add_foreign_key "line_items", "item_specs"
  add_foreign_key "line_items", "items"
  add_foreign_key "line_items", "line_items"
  add_foreign_key "line_items", "locations"
  add_foreign_key "line_items", "stages"
  add_foreign_key "locations", "documents"
  add_foreign_key "payments", "projects"
  add_foreign_key "payments", "quotes"
  add_foreign_key "projects", "accounts"
  add_foreign_key "quotes", "projects"
  add_foreign_key "quotes", "tenders"
  add_foreign_key "rates", "item_actions"
  add_foreign_key "rates", "item_specs"
  add_foreign_key "rates", "items"
  add_foreign_key "stages", "documents"
  add_foreign_key "stats", "stat_types"
  add_foreign_key "tenders", "projects"
  add_foreign_key "tenders", "tender_templates"
  add_foreign_key "users", "accounts"
end
