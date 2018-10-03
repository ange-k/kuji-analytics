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

ActiveRecord::Schema.define(version: 20180930121315) do

  create_table "analyses", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "number", null: false
    t.integer "pair", null: false
    t.integer "type_number", null: false
    t.integer "total", default: 0, null: false
    t.integer "year", null: false
    t.integer "month", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["month"], name: "index_analyses_on_month"
    t.index ["number", "pair", "type_number", "month"], name: "target_num_month_idx"
    t.index ["number", "pair", "type_number", "year", "month"], name: "num_unique_idx"
    t.index ["number", "pair", "type_number"], name: "target_num_pair_idx"
    t.index ["number", "pair"], name: "target_num_pair_all_idx"
    t.index ["year"], name: "index_analyses_on_year"
  end

  create_table "lotos", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "number", null: false
    t.integer "type_number", null: false
    t.string "result", null: false
    t.string "bonus_number", null: false
    t.date "date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["date"], name: "index_lotos_on_date"
    t.index ["number", "type_number"], name: "target_loto_idx", unique: true
  end

  create_table "units", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "number", null: false
    t.integer "type_number", null: false
    t.integer "unit", null: false
    t.boolean "bonus", default: false, null: false
    t.integer "year", null: false
    t.integer "month", null: false
    t.integer "day", null: false
    t.string "old_date", null: false
    t.string "rokuyou", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["day"], name: "index_units_on_day"
    t.index ["month"], name: "index_units_on_month"
    t.index ["number", "type_number", "unit"], name: "units_idx_unique", unique: true
    t.index ["number", "type_number"], name: "target_units_idx"
    t.index ["old_date"], name: "index_units_on_old_date"
    t.index ["rokuyou"], name: "index_units_on_rokuyou"
    t.index ["year"], name: "index_units_on_year"
  end

end
