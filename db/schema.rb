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

ActiveRecord::Schema.define(:version => 20130509203735) do

  create_table "products", :force => true do |t|
    t.integer  "external_id"
    t.string   "url"
    t.string   "title",       :default => "",    :null => false
    t.string   "location",    :default => "",    :null => false
    t.string   "make_model",  :default => "",    :null => false
    t.text     "description"
    t.string   "condition",   :default => "",    :null => false
    t.integer  "year"
    t.integer  "size"
    t.integer  "price"
    t.integer  "price_last"
    t.datetime "listed_at"
    t.datetime "removed_at"
    t.integer  "days_active"
    t.boolean  "sold",        :default => false
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

end
