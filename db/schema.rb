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

ActiveRecord::Schema[7.2].define(version: 2024_12_28_173327) do
  create_table "r_schedules", force: :cascade do |t|
    t.string "name"
    t.string "event"
    t.integer "start_number"
    t.time "start_time"
    t.integer "days"
    t.time "finish_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.integer "number"
  end

  create_table "regular_schedules", force: :cascade do |t|
    t.string "name"
    t.text "event"
    t.integer "user_id"
    t.integer "number"
    t.time "start_time"
    t.integer "days"
    t.time "finish_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "start_hour"
    t.integer "start_minute"
    t.integer "finish_hour"
    t.integer "finish_minute"
  end

  create_table "schedules", force: :cascade do |t|
    t.string "name"
    t.text "event"
    t.date "start_date"
    t.datetime "start_time"
    t.date "finish_date"
    t.datetime "finish_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.datetime "end_time"
    t.integer "number"
    t.boolean "regular_schedule"
  end

  create_table "shifts", force: :cascade do |t|
    t.date "date"
    t.integer "number"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end
end
