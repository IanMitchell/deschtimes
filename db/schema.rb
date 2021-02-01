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

ActiveRecord::Schema.define(version: 2021_02_01_061726) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "authorized_users", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "group_id", null: false
    t.boolean "owner", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["group_id", "user_id"], name: "index_authorized_users_on_group_id_and_user_id", unique: true
    t.index ["group_id"], name: "index_authorized_users_on_group_id"
    t.index ["user_id"], name: "index_authorized_users_on_user_id"
  end

  create_table "episodes", force: :cascade do |t|
    t.bigint "show_id", null: false
    t.datetime "air_date"
    t.integer "number"
    t.boolean "released", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["released"], name: "index_episodes_on_released"
    t.index ["show_id"], name: "index_episodes_on_show_id"
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_type", "sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_type_and_sluggable_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string "acronym", null: false
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "token", null: false
    t.string "slug"
    t.index ["acronym"], name: "index_groups_on_acronym", unique: true
    t.index ["name"], name: "index_groups_on_name", unique: true
    t.index ["slug"], name: "index_groups_on_slug", unique: true
    t.index ["token"], name: "index_groups_on_token", unique: true
  end

  create_table "members", force: :cascade do |t|
    t.string "name"
    t.string "discord"
    t.bigint "group_id", null: false
    t.boolean "admin", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["group_id"], name: "index_members_on_group_id"
  end

  create_table "pg_search_documents", force: :cascade do |t|
    t.text "content"
    t.string "searchable_type"
    t.bigint "searchable_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["searchable_type", "searchable_id"], name: "index_pg_search_documents_on_searchable_type_and_searchable_id"
  end

  create_table "positions", force: :cascade do |t|
    t.string "name", null: false
    t.string "acronym", null: false
    t.bigint "group_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "rank"
    t.index ["acronym"], name: "index_positions_on_acronym"
    t.index ["group_id"], name: "index_positions_on_group_id"
    t.index ["name"], name: "index_positions_on_name"
  end

  create_table "projects", force: :cascade do |t|
    t.bigint "show_id", null: false
    t.bigint "group_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "status", default: 0
    t.index ["group_id", "show_id"], name: "index_projects_on_group_id_and_show_id", unique: true
    t.index ["group_id"], name: "index_projects_on_group_id"
    t.index ["show_id"], name: "index_projects_on_show_id"
    t.index ["status"], name: "index_projects_on_status"
  end

  create_table "shows", force: :cascade do |t|
    t.string "name"
    t.boolean "visible"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "status"
    t.index ["name"], name: "index_shows_on_name"
    t.index ["visible"], name: "index_shows_on_visible"
  end

  create_table "staff", force: :cascade do |t|
    t.bigint "member_id", null: false
    t.bigint "position_id", null: false
    t.bigint "episode_id", null: false
    t.boolean "finished", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["episode_id"], name: "index_staff_on_episode_id"
    t.index ["member_id"], name: "index_staff_on_member_id"
    t.index ["position_id"], name: "index_staff_on_position_id"
  end

  create_table "terms", force: :cascade do |t|
    t.bigint "show_id", null: false
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["show_id"], name: "index_terms_on_show_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["name"], name: "index_users_on_name", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "webhooks", force: :cascade do |t|
    t.string "name", null: false
    t.string "url", null: false
    t.integer "platform", default: 0
    t.bigint "group_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["group_id"], name: "index_webhooks_on_group_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "authorized_users", "groups"
  add_foreign_key "authorized_users", "users"
  add_foreign_key "episodes", "shows"
  add_foreign_key "members", "groups"
  add_foreign_key "positions", "groups"
  add_foreign_key "projects", "groups"
  add_foreign_key "projects", "shows"
  add_foreign_key "staff", "episodes"
  add_foreign_key "staff", "members"
  add_foreign_key "staff", "positions"
  add_foreign_key "terms", "shows"
end
