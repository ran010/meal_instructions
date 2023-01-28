class IngredientTemplate < ApplicationRecord
  belongs_to :meal_template, counter_cache: true
  belongs_to :grocery

  delegate :grocery_category, to: :grocery
end
