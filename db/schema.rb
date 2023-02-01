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

ActiveRecord::Schema[7.0].define(version: 2023_02_01_035132) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "commands", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_commands_on_user_id"
  end

  create_table "favorite_meal_templates", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "meal_template_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["meal_template_id"], name: "index_favorite_meal_templates_on_meal_template_id"
    t.index ["user_id", "meal_template_id"], name: "index_favorite_meals_on_user_id_and_meal_temp_id", unique: true
    t.index ["user_id"], name: "index_favorite_meal_templates_on_user_id"
  end

  create_table "groceries", force: :cascade do |t|
    t.string "name"
    t.text "image_data"
    t.text "notes"
    t.string "barcode"
    t.string "payload"
    t.bigint "grocery_category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["grocery_category_id"], name: "index_groceries_on_grocery_category_id"
  end

  create_table "grocery_categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ingredient_templates", force: :cascade do |t|
    t.string "quantity", null: false
    t.string "unit_type"
    t.text "notes"
    t.bigint "meal_template_id", null: false
    t.bigint "grocery_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["grocery_id"], name: "index_ingredient_templates_on_grocery_id"
    t.index ["meal_template_id"], name: "index_ingredient_templates_on_meal_template_id"
  end

  create_table "ingredients", force: :cascade do |t|
    t.bigint "grocery_id", null: false
    t.bigint "meal_id", null: false
    t.string "unit_type"
    t.string "quantity"
    t.string "notes"
    t.datetime "purchased_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["grocery_id"], name: "index_ingredients_on_grocery_id"
    t.index ["meal_id"], name: "index_ingredients_on_meal_id"
  end

  create_table "instruction_steps", force: :cascade do |t|
    t.bigint "meal_id", null: false
    t.integer "position", null: false
    t.text "description"
    t.text "full_description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["meal_id"], name: "index_instruction_steps_on_meal_id"
  end

  create_table "instruction_template_steps", force: :cascade do |t|
    t.bigint "meal_template_id", null: false
    t.integer "position", null: false
    t.text "full_description"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["meal_template_id"], name: "index_instruction_template_steps_on_meal_template_id"
  end

  create_table "meal_templates", force: :cascade do |t|
    t.string "name", null: false
    t.integer "serving_for", default: 2
    t.integer "ingredient_templates_count", default: 0
    t.text "description"
    t.integer "prep_time"
    t.integer "cook_time"
    t.integer "total_time"
    t.integer "meals_count", default: 0
    t.text "payload"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "meals", force: :cascade do |t|
    t.string "name", null: false
    t.boolean "bookmark", default: false
    t.integer "serving_for", default: 2
    t.integer "ingredients_count", default: 0
    t.text "description"
    t.integer "prep_time"
    t.integer "cook_time"
    t.integer "total_time"
    t.datetime "completed_at"
    t.bigint "meal_template_id"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["meal_template_id"], name: "index_meals_on_meal_template_id"
    t.index ["user_id"], name: "index_meals_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "commands", "users"
  add_foreign_key "favorite_meal_templates", "meal_templates"
  add_foreign_key "favorite_meal_templates", "users"
  add_foreign_key "groceries", "grocery_categories"
  add_foreign_key "ingredient_templates", "groceries"
  add_foreign_key "ingredient_templates", "meal_templates"
  add_foreign_key "ingredients", "groceries"
  add_foreign_key "ingredients", "meals"
  add_foreign_key "instruction_steps", "meals"
  add_foreign_key "instruction_template_steps", "meal_templates"
  add_foreign_key "meals", "meal_templates"
  add_foreign_key "meals", "users"
end
