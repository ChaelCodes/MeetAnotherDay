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

ActiveRecord::Schema[7.0].define(version: 2021_10_24_152330) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "event_attendees", force: :cascade do |t|
    t.bigint "profile_id", null: false
    t.bigint "event_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "organizer", default: false
    t.index ["event_id"], name: "index_event_attendees_on_event_id"
    t.index ["profile_id"], name: "index_event_attendees_on_profile_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.datetime "start_at", precision: nil, null: false
    t.datetime "end_at", precision: nil, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "handle"
    t.index ["handle"], name: "index_events_on_handle", unique: true
  end

  create_table "friendships", force: :cascade do |t|
    t.integer "friend_id", null: false
    t.integer "buddy_id", null: false
    t.integer "status", default: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["friend_id", "buddy_id"], name: "index_friendships_on_friend_id_and_buddy_id", unique: true
  end

  create_table "notifications", force: :cascade do |t|
    t.string "message"
    t.string "notifiable_type", null: false
    t.bigint "notifiable_id", null: false
    t.bigint "notified_id"
    t.bigint "notifier_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["notifiable_type", "notifiable_id"], name: "index_notifications_on_notifiable"
    t.index ["notified_id"], name: "index_notifications_on_notified_id"
    t.index ["notifier_id"], name: "index_notifications_on_notifier_id"
  end

  create_table "profiles", force: :cascade do |t|
    t.string "name"
    t.string "handle"
    t.string "bio"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "visibility", default: 1
    t.index ["handle"], name: "index_profiles_on_handle", unique: true
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "bio"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.boolean "admin"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "event_attendees", "events"
  add_foreign_key "event_attendees", "profiles"
  add_foreign_key "friendships", "profiles", column: "buddy_id"
  add_foreign_key "friendships", "profiles", column: "friend_id"
  add_foreign_key "notifications", "profiles", column: "notified_id"
  add_foreign_key "notifications", "profiles", column: "notifier_id"
end
