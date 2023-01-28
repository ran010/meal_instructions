class CreateMeals < ActiveRecord::Migration[7.0]
  def change
    create_table :meals do |t|
      t.string :name, null: false
      t.boolean :bookmark, default: false
      t.integer :serving_for, default: 2
      t.integer :ingredients_count, default: 0
      t.text :description
      t.integer :prep_time
      t.integer :cook_time
      t.integer :total_time
      t.datetime :completed_at
      
      t.references :meal_template, null: true, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end
