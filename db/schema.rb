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

ActiveRecord::Schema.define(:version => 20121017160242) do

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "entities", :force => true do |t|
    t.string   "type"
    t.string   "serialized_data"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "name"
    t.text     "tags"
  end

  create_table "entities_news_feeds", :id => false, :force => true do |t|
    t.integer "entity_id"
    t.integer "news_feed_id"
  end

  create_table "entity_feed_entries", :force => true do |t|
    t.integer "entity_id"
    t.integer "feed_entry_id"
    t.boolean "default",       :default => false
  end

  create_table "feed_entries", :force => true do |t|
    t.string   "name"
    t.text     "summary"
    t.string   "url"
    t.datetime "published_at"
    t.string   "guid"
    t.string   "author"
    t.text     "content"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
    t.integer  "news_feed_id"
    t.boolean  "visible",           :default => true
    t.string   "state"
    t.text     "fetch_errors"
    t.boolean  "failed",            :default => false
    t.boolean  "indexed",           :default => false
    t.boolean  "reviewed",          :default => false
    t.integer  "tweet_count",       :default => 0
    t.float    "social_ranking"
    t.integer  "facebook_likes",    :default => 0
    t.integer  "facebook_shares",   :default => 0
    t.integer  "facebook_comments", :default => 0
    t.float    "rank_coefficient",  :default => 1.8
    t.boolean  "outdated",          :default => false
  end

  add_index "feed_entries", ["url"], :name => "index_feed_entries_on_url", :unique => true

  create_table "feedzirra_responses", :force => true do |t|
    t.integer  "news_feed_id"
    t.text     "serialized_response"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  create_table "news_feeds", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.string   "etag"
    t.datetime "last_modified"
    t.boolean  "valid_feed",    :default => true
  end

  add_index "news_feeds", ["name"], :name => "index_news_feeds_on_name", :unique => true
  add_index "news_feeds", ["url"], :name => "index_news_feeds_on_url", :unique => true

  create_table "social_network_configurations", :force => true do |t|
    t.string   "name"
    t.text     "message"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       :limit => 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string  "name"
    t.boolean "blacklisted", :default => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                            :null => false
    t.datetime "updated_at",                                            :null => false
    t.string   "rpx_identifier"
    t.string   "first_name"
    t.string   "last_name"
    t.boolean  "is_customer"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
