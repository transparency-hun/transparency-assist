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

ActiveRecord::Schema.define(version: 20161128012007) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.string   "author_type"
    t.integer  "author_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree
  end

  create_table "admins", force: :cascade do |t|
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
    t.string   "username"
    t.index ["email"], name: "index_admins_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_categories_on_name", unique: true, using: :btree
  end

  create_table "data_tables", force: :cascade do |t|
    t.integer  "admin_id"
    t.integer  "category_id",                             null: false
    t.string   "title",                                   null: false
    t.text     "description",             default: ""
    t.boolean  "official",                default: false
    t.boolean  "confirmed",               default: false
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.string   "data_sheet_file_name"
    t.string   "data_sheet_content_type"
    t.integer  "data_sheet_file_size"
    t.datetime "data_sheet_updated_at"
    t.string   "preview",                 default: [],                 array: true
    t.string   "source"
    t.index ["admin_id"], name: "index_data_tables_on_admin_id", using: :btree
    t.index ["category_id"], name: "index_data_tables_on_category_id", using: :btree
    t.index ["confirmed"], name: "index_data_tables_on_confirmed", using: :btree
  end

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id",        null: false
    t.integer  "data_table_id", null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["data_table_id"], name: "index_taggings_on_data_table_id", using: :btree
    t.index ["tag_id", "data_table_id"], name: "index_taggings_on_tag_id_and_data_table_id", unique: true, using: :btree
    t.index ["tag_id"], name: "index_taggings_on_tag_id", using: :btree
  end

  create_table "tags", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_tags_on_name", unique: true, using: :btree
  end

  add_foreign_key "data_tables", "admins", on_delete: :nullify
  add_foreign_key "data_tables", "categories"
  add_foreign_key "taggings", "data_tables", on_delete: :cascade
  add_foreign_key "taggings", "tags", on_delete: :cascade
end
