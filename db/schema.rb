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

ActiveRecord::Schema.define(version: 20150629173151) do

  create_table "folders", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
    t.integer  "folder_id"
  end

  add_index "folders", ["folder_id"], name: "index_folders_on_folder_id"
  add_index "folders", ["user_id"], name: "index_folders_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "oauth_token"
    t.string   "image"
    t.string   "email"
    t.datetime "oauth_expires_at"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "vocabularies", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "folder_id"
  end

  add_index "vocabularies", ["folder_id"], name: "index_vocabularies_on_folder_id"

  create_table "words", force: :cascade do |t|
    t.string   "word"
    t.string   "meaning"
    t.string   "sentence"
    t.string   "sentence_meaning"
    t.integer  "vocabulary_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.datetime "remaining_dates"
    t.integer  "stage",            default: 0
  end

  add_index "words", ["vocabulary_id"], name: "index_words_on_vocabulary_id"

end
