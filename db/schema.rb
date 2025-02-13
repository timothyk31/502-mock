# frozen_string_literal: true

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

ActiveRecord::Schema[7.0].define(version: 20_250_211_024_558) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'attendances', force: :cascade do |t|
    t.bigint 'member_id', null: false
    t.bigint 'event_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['event_id'], name: 'index_attendances_on_event_id'
    t.index %w[member_id event_id], name: 'index_attendances_on_member_id_and_event_id', unique: true
    t.index ['member_id'], name: 'index_attendances_on_member_id'
  end

  create_table 'events', force: :cascade do |t|
    t.string 'name'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.string 'location'
    t.datetime 'start_time', null: false
    t.datetime 'end_time'
    t.string 'attendance_code'
  end

  create_table 'members', force: :cascade do |t|
    t.string 'email', null: false
    t.string 'first_name'
    t.string 'last_name'
    t.string 'uid'
    t.string 'avatar_url'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.decimal 'class_year'
    t.decimal 'role', default: '0.0'
    t.string 'phone_number'
    t.string 'address'
    t.string 'uin'
    t.index ['email'], name: 'index_members_on_email', unique: true
  end

  create_table 'speakers', force: :cascade do |t|
    t.string 'name'
    t.string 'details'
    t.string 'email'
  end

  add_foreign_key 'attendances', 'events'
  add_foreign_key 'attendances', 'members'
end
