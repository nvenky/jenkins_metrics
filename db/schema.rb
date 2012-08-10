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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120810053931) do

  create_table "authors", :force => true do |t|
    t.string   "name"
    t.integer  "build_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "authors", ["build_id"], :name => "index_authors_on_build_id"

  create_table "builds", :force => true do |t|
    t.integer  "build_number"
    t.integer  "total_test"
    t.integer  "skipped_test"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "project_id"
    t.datetime "build_date"
    t.integer  "total_changes"
    t.integer  "java_changes"
    t.integer  "test_changes"
  end

  create_table "change_sets", :force => true do |t|
    t.string   "file_name"
    t.string   "change_type"
    t.integer  "build_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "change_sets", ["build_id"], :name => "index_change_sets_on_build_id"

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "url"
  end

end
