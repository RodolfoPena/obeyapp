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

ActiveRecord::Schema.define(version: 2019_01_22_225916) do

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
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "causes", force: :cascade do |t|
    t.string "name"
    t.boolean "root_cause"
    t.bigint "problem_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["problem_id"], name: "index_causes_on_problem_id"
  end

  create_table "commitments", force: :cascade do |t|
    t.string "action"
    t.text "conditions_of_satisfaction"
    t.date "start_date"
    t.date "due_date"
    t.date "renegotiation_date"
    t.date "closing_date"
    t.boolean "critical"
    t.boolean "deliverable"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.bigint "target_id"
    t.bigint "responsible_id"
    t.boolean "closed_in_term"
    t.integer "status"
    t.index ["responsible_id"], name: "index_commitments_on_responsible_id"
    t.index ["target_id"], name: "index_commitments_on_target_id"
    t.index ["user_id"], name: "index_commitments_on_user_id"
  end

  create_table "members", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_members_on_team_id"
    t.index ["user_id"], name: "index_members_on_user_id"
  end

  create_table "problems", force: :cascade do |t|
    t.string "title"
    t.string "type"
    t.string "status"
    t.date "status_update"
    t.bigint "target_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.string "description"
    t.index ["target_id"], name: "index_problems_on_target_id"
    t.index ["user_id"], name: "index_problems_on_user_id"
  end

  create_table "targets", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.date "start_date"
    t.date "due_date"
    t.bigint "team_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "responsible_id"
    t.index ["responsible_id"], name: "index_targets_on_responsible_id"
    t.index ["team_id"], name: "index_targets_on_team_id"
    t.index ["user_id"], name: "index_targets_on_user_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.bigint "commitment_id"
    t.string "name"
    t.boolean "done", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["commitment_id"], name: "index_tasks_on_commitment_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_teams_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "location"
    t.text "bio"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "sign_in_count", default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "provider"
    t.string "uid"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "causes", "problems"
  add_foreign_key "commitments", "targets"
  add_foreign_key "commitments", "users"
  add_foreign_key "members", "teams"
  add_foreign_key "members", "users"
  add_foreign_key "problems", "targets"
  add_foreign_key "problems", "users"
  add_foreign_key "targets", "teams"
  add_foreign_key "targets", "users"
  add_foreign_key "tasks", "commitments"
  add_foreign_key "teams", "users"
end
