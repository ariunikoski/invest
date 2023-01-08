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

ActiveRecord::Schema[7.0].define(version: 2023_01_08_091414) do
  create_table "dividends", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "share_id", null: false
    t.date "x_date"
    t.date "payment_date"
    t.decimal "amount", precision: 15, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["share_id", "x_date"], name: "index_dividends_on_share_id_and_x_date", unique: true
    t.index ["share_id"], name: "index_dividends_on_share_id"
  end

  create_table "exchange_rates", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "currency_code"
    t.decimal "exchange_rate", precision: 15, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "funds", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "symbol"
    t.integer "israeli_number"
    t.string "currency"
    t.decimal "current_price", precision: 15, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "holdings", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "held_by_type", null: false
    t.bigint "held_by_id", null: false
    t.date "purchase_date"
    t.integer "amount"
    t.decimal "cost", precision: 15, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "account"
    t.index ["held_by_type", "held_by_id"], name: "index_holdings_on_held_by"
  end

  create_table "links", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "target_url"
    t.string "name"
    t.string "linked_to_type", null: false
    t.bigint "linked_to_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["linked_to_type", "linked_to_id"], name: "index_links_on_linked_to"
  end

  create_table "shares", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "symbol"
    t.integer "israeli_number"
    t.string "currency"
    t.decimal "last_dividend_trailing_pcnt", precision: 5, scale: 2
    t.decimal "current_price", precision: 15, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "dividends", "shares"
end
