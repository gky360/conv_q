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

ActiveRecord::Schema.define(version: 20160319204248) do

  create_table "histories", force: :cascade do |t|
    t.integer  "topic_id",   limit: 4
    t.integer  "user_id",    limit: 4
    t.integer  "times",      limit: 4, default: 0, null: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "rating",     limit: 4, default: 0, null: false
  end

  add_index "histories", ["topic_id", "user_id"], name: "index_histories_on_topic_id_and_user_id", unique: true, using: :btree

  create_table "reports", force: :cascade do |t|
    t.integer  "topic_id",    limit: 4,                 null: false
    t.integer  "user_id",     limit: 4,                 null: false
    t.integer  "reason_flag", limit: 4,     default: 0, null: false
    t.text     "detail",      limit: 65535
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  add_index "reports", ["topic_id", "user_id"], name: "index_reports_on_topic_id_and_user_id", unique: true, using: :btree

  create_table "tag_topics", force: :cascade do |t|
    t.integer  "tag_id",     limit: 4, null: false
    t.integer  "topic_id",   limit: 4, null: false
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "tags", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "topics", force: :cascade do |t|
    t.text     "title",      limit: 65535, null: false
    t.string   "source_url", limit: 255
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "user_id",    limit: 4
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",                   limit: 255,                     null: false
    t.string   "account",                limit: 255,                     null: false
    t.integer  "status",                 limit: 1,     default: 0,       null: false
    t.string   "email",                  limit: 255,   default: "",      null: false
    t.string   "encrypted_password",     limit: 255,   default: "",      null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,     default: 0,       null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at",                                             null: false
    t.datetime "updated_at",                                             null: false
    t.string   "provider",               limit: 255,   default: "email", null: false
    t.string   "uid",                    limit: 255,   default: "",      null: false
    t.text     "tokens",                 limit: 65535
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true, using: :btree

end
