class FavoriteMealTemplate < ApplicationRecord
  belongs_to :user
  belongs_to :meal_template

  validates :user_id, uniqueness: {scope: [:meal_template_id]}
end
