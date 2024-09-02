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

ActiveRecord::Schema[7.1].define(version: 2024_09_02_103802) do
  create_table "app_banners", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "title"
    t.text "image_url"
    t.string "action_url"
    t.boolean "status", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "app_opens", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "source_ip"
    t.bigint "user_id", null: false
    t.string "version_name"
    t.string "version_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_app_opens_on_user_id"
  end

  create_table "deleted_users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "kyc_details", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "user_id"
    t.string "aadhar_number"
    t.string "full_name"
    t.string "address"
    t.string "pan_number"
    t.string "dob"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "leads", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "pan_number"
    t.string "mobile_number"
    t.string "full_name"
    t.string "email_address"
    t.string "pincode"
    t.string "offer_id"
    t.string "user_id"
    t.string "status", default: "PROCESSING"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "offers", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "offer_name"
    t.text "description"
    t.string "status"
    t.string "offer_type"
    t.string "offer_rate"
    t.string "offer_time"
    t.string "offer_tags"
    t.string "fee_charge"
    t.string "offer_amount"
    t.string "income_amount"
    t.string "short_text"
    t.string "priority"
    t.string "yt_video_url"
    t.string "icon_small_img_url"
    t.string "banner_big_img_url"
    t.string "action_url"
    t.text "offer_terms"
    t.text "offer_docs"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "features"
    t.text "fees_and_charges"
    t.text "target_audience"
    t.text "documents_required"
    t.text "how_to_get_commission"
    t.text "lead_tracking_time"
  end

  create_table "payouts", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "title"
    t.string "img_url"
    t.string "reward"
    t.string "redeem_limit"
    t.string "reward_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transaction_histories", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "title"
    t.bigint "user_id", null: false
    t.string "amount"
    t.string "status", default: "PENDING"
    t.string "upi_id"
    t.string "payout_id"
    t.string "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_transaction_histories_on_user_id"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "device_id"
    t.string "device_type"
    t.string "device_name"
    t.string "social_type"
    t.string "social_id"
    t.string "social_name"
    t.string "social_email"
    t.string "social_img_url"
    t.string "advertising_id"
    t.string "version_name"
    t.string "version_code"
    t.string "utm_source"
    t.string "utm_medium"
    t.string "utm_term"
    t.string "utm_content"
    t.string "utm_campaign"
    t.string "source_ip"
    t.string "fcm_token"
    t.string "referrer_url"
    t.string "security_token"
    t.string "refer_code"
    t.string "wallet_balance", default: "0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "mobile_number"
    t.string "pincode"
    t.string "gender"
  end

  create_table "videos", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "video_url"
    t.string "title"
    t.string "subtitle"
    t.text "description"
    t.boolean "status", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "app_opens", "users"
  add_foreign_key "transaction_histories", "users"
end
