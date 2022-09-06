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

ActiveRecord::Schema.define(version: 20161202022822) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "admin_users", force: :cascade do |t|
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
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "agencies", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0,     null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "phone_number",           default: "",    null: false
    t.string   "city",                   default: "",    null: false
    t.string   "state",                  default: "",    null: false
    t.string   "address1",               default: "",    null: false
    t.string   "address2",               default: "",    null: false
    t.string   "company_name",           default: "",    null: false
    t.string   "profile_image_id",       default: "",    null: false
    t.boolean  "phone_confirmed",        default: false
    t.boolean  "email_confirmed",        default: false
    t.boolean  "activated",              default: false
    t.string   "first_name",             default: "",    null: false
    t.string   "last_name",              default: "",    null: false
  end

  add_index "agencies", ["confirmation_token"], name: "index_agencies_on_confirmation_token", unique: true, using: :btree
  add_index "agencies", ["email"], name: "index_agencies_on_email", unique: true, using: :btree
  add_index "agencies", ["phone_number"], name: "index_agencies_on_phone_number", unique: true, using: :btree
  add_index "agencies", ["reset_password_token"], name: "index_agencies_on_reset_password_token", unique: true, using: :btree
  add_index "agencies", ["unlock_token"], name: "index_agencies_on_unlock_token", unique: true, using: :btree

  create_table "ambassador_roles", force: :cascade do |t|
    t.integer  "ambassador_id"
    t.integer  "role_type_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "ambassadors", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "password_digest"
    t.string   "remember_digest"
    t.decimal  "rate"
    t.string   "rate_currency"
    t.string   "phone_number"
    t.string   "profile_image_id"
    t.string   "city"
    t.string   "state"
    t.text     "about"
    t.string   "activation_digest"
    t.boolean  "activated",         default: false
    t.datetime "activated_at"
    t.string   "reset_digest"
    t.datetime "reset_sent_at"
    t.string   "full_name"
    t.string   "slug"
    t.datetime "last_seen_at"
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "oauth_token"
    t.datetime "oauth_expires_at"
    t.boolean  "phone_confirmed",   default: false
    t.boolean  "email_confirmed",   default: false
    t.integer  "response_time",     default: 8
    t.integer  "acceptance_rate",   default: 100
    t.string   "roles"
    t.string   "image"
  end

  add_index "ambassadors", ["email"], name: "index_ambassadors_on_email", unique: true, using: :btree
  add_index "ambassadors", ["slug"], name: "index_ambassadors_on_slug", unique: true, using: :btree

  create_table "booking_staff_items", force: :cascade do |t|
    t.integer  "booking_staff_id"
    t.integer  "event_role_id"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "status",           default: "pending"
  end

  add_index "booking_staff_items", ["booking_staff_id"], name: "index_booking_staff_items_on_booking_staff_id", using: :btree
  add_index "booking_staff_items", ["event_role_id"], name: "index_booking_staff_items_on_event_role_id", using: :btree

  create_table "booking_staffs", force: :cascade do |t|
    t.integer  "booking_id"
    t.integer  "ambassador_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "confirm_token"
    t.integer  "delayed_job_id"
  end

  add_index "booking_staffs", ["ambassador_id"], name: "index_booking_staffs_on_ambassador_id", using: :btree
  add_index "booking_staffs", ["booking_id"], name: "index_booking_staffs_on_booking_id", using: :btree

  create_table "booking_status_types", force: :cascade do |t|
    t.string   "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "booking_statuses", force: :cascade do |t|
    t.integer  "type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "booking_summaries", force: :cascade do |t|
    t.integer  "booking_id"
    t.integer  "unique_staff"
    t.decimal  "service_fee_rate"
    t.decimal  "tax_rate"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "booking_summaries", ["booking_id"], name: "index_booking_summaries_on_booking_id", using: :btree

  create_table "booking_transactions", force: :cascade do |t|
    t.integer  "booking_id"
    t.decimal  "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "bookings", force: :cascade do |t|
    t.integer  "agency_id"
    t.integer  "event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "bookings", ["agency_id"], name: "index_bookings_on_agency_id", using: :btree
  add_index "bookings", ["event_id"], name: "index_bookings_on_event_id", using: :btree

  create_table "busy_shifts", force: :cascade do |t|
    t.string   "day"
    t.integer  "ambassador_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.datetime "start_time"
    t.datetime "end_time"
  end

  create_table "carts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "conversations", force: :cascade do |t|
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "event_id"
  end

  add_index "conversations", ["event_id"], name: "index_conversations_on_event_id", using: :btree

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

  create_table "event_date_shifts", force: :cascade do |t|
    t.integer  "event_date_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.datetime "start_time"
    t.datetime "end_time"
  end

  create_table "event_dates", force: :cascade do |t|
    t.date     "event_date"
    t.time     "start_time"
    t.time     "end_time"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "event_location_id"
  end

  create_table "event_locations", force: :cascade do |t|
    t.string   "label"
    t.string   "address"
    t.string   "zip"
    t.string   "state"
    t.string   "country"
    t.string   "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "event_id"
    t.string   "city"
    t.integer  "city_id"
  end

  create_table "event_roles", force: :cascade do |t|
    t.integer  "hourly_rate"
    t.integer  "quantity"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.integer  "event_date_id"
    t.integer  "event_date_shift_id"
    t.integer  "ambassador_id"
    t.string   "role_status",         default: "empty"
    t.integer  "role_type_id",        default: 1
    t.integer  "event_id"
  end

  create_table "events", force: :cascade do |t|
    t.string   "name"
    t.string   "event_details"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.integer  "agency_id"
    t.integer  "current_location_id"
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "images", force: :cascade do |t|
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "ambassador_id"
    t.string   "file_id"
    t.integer  "row_order"
  end

  add_index "images", ["ambassador_id"], name: "index_images_on_ambassador_id", using: :btree

  create_table "line_items", force: :cascade do |t|
    t.integer  "ambassador_id"
    t.integer  "cart_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "quantity",      default: 1
    t.integer  "order_id"
  end

  add_index "line_items", ["ambassador_id"], name: "index_line_items_on_ambassador_id", using: :btree
  add_index "line_items", ["cart_id"], name: "index_line_items_on_cart_id", using: :btree
  add_index "line_items", ["order_id"], name: "index_line_items_on_order_id", using: :btree

  create_table "messages", force: :cascade do |t|
    t.text     "content"
    t.integer  "user_id"
    t.string   "user_type"
    t.integer  "conversation_id"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.boolean  "is_read",         default: false
  end

  add_index "messages", ["conversation_id"], name: "index_messages_on_conversation_id", using: :btree
  add_index "messages", ["user_id"], name: "index_messages_on_user_id", using: :btree

  create_table "orders", force: :cascade do |t|
    t.string   "full_name"
    t.string   "company"
    t.string   "telephone"
    t.string   "email"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "card_token"
    t.string   "zip_code"
    t.date     "start_date"
    t.date     "end_date"
    t.time     "start_time"
    t.time     "end_time"
  end

  create_table "phone_numbers", force: :cascade do |t|
    t.string   "phone_number"
    t.string   "pin"
    t.boolean  "verified"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "properties", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "property_ambassadors", force: :cascade do |t|
    t.integer  "ambassador_id"
    t.integer  "property_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "reviews", force: :cascade do |t|
    t.text     "content"
    t.string   "name"
    t.string   "email"
    t.decimal  "rating"
    t.integer  "ambassador_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "star",          default: 5
    t.integer  "agency_id"
  end

  add_index "reviews", ["agency_id"], name: "index_reviews_on_agency_id", using: :btree
  add_index "reviews", ["ambassador_id", "created_at"], name: "index_reviews_on_ambassador_id_and_created_at", using: :btree
  add_index "reviews", ["ambassador_id"], name: "index_reviews_on_ambassador_id", using: :btree

  create_table "role_statuses", force: :cascade do |t|
    t.string   "status"
    t.string   "displayname"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "role_types", force: :cascade do |t|
    t.string   "type_of"
    t.string   "displayname"
    t.string   "abbrv"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "weekly_unavailabilities", force: :cascade do |t|
    t.time     "sunday_start"
    t.time     "sunday_end"
    t.time     "monday_start"
    t.time     "monday_end"
    t.time     "tuesday_start"
    t.time     "tuesday_end"
    t.time     "wednesday_start"
    t.time     "wednesday_end"
    t.time     "thursday_start"
    t.time     "thursday_end"
    t.time     "friday_start"
    t.time     "friday_end"
    t.time     "saturday_start"
    t.time     "saturday_end"
    t.integer  "ambassador_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_foreign_key "booking_staff_items", "booking_staffs"
  add_foreign_key "booking_staff_items", "event_roles"
  add_foreign_key "booking_staffs", "ambassadors"
  add_foreign_key "booking_staffs", "bookings"
  add_foreign_key "booking_summaries", "bookings"
  add_foreign_key "booking_transactions", "bookings"
  add_foreign_key "bookings", "agencies"
  add_foreign_key "bookings", "events"
  add_foreign_key "conversations", "events"
  add_foreign_key "event_roles", "events"
  add_foreign_key "line_items", "ambassadors"
  add_foreign_key "line_items", "carts"
  add_foreign_key "line_items", "orders"
  add_foreign_key "messages", "conversations"
  add_foreign_key "reviews", "agencies"
end
