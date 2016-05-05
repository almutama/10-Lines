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

ActiveRecord::Schema.define(version: 20151205004439) do

  create_table "comments", force: true do |t|
    t.string   "text"
    t.integer  "user_id"
    t.integer  "sketch_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lines", force: true do |t|
    t.string   "color"
    t.integer  "width"
    t.text     "lines"
    t.integer  "sketch_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sketches", force: true do |t|
    t.string   "title"
    t.string   "url"
    t.integer  "upvotes"
    t.integer  "creator_id"
    t.integer  "user_id"
    t.integer  "comment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "ispublic"
  end

  create_table "sketches_users", force: true do |t|
    t.integer "sketch_id"
    t.integer "user_id"
  end

  add_index "sketches_users", ["sketch_id"], name: "index_sketches_users_on_sketch_id"
  add_index "sketches_users", ["user_id"], name: "index_sketches_users_on_user_id"

  create_table "users", force: true do |t|
    t.string   "username"
    t.string   "password"
    t.string   "firstname"
    t.string   "lastname"
    t.string   "icon"
    t.string   "sketch_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
