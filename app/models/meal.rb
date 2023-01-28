class Meal < ApplicationRecord
  belongs_to :user
  belongs_to :meal_template, optional: true, counter_cache: true

  has_many :ingredients, dependent: :destroy
  has_many :groceries, through: :ingredients
  has_many :instruction_steps, dependent: :destroy

  scope :bookmark, -> { where(bookmark: true) }
  scope :completed, -> { where.not(completed_at: nil) }
  scope :not_completed, -> { where(completed_at: nil) }

  validates :name, presence: true

  def self.search(search)
    if search
      where("name LIKE ?", "%#{search}%")
    else
      all
    end
  end

  def self.filter(filter)
    case filter
    when "bookmark"
      bookmark
    when "completed"
      completed
    else
      all
    end
  end

  def self.sort(sort)
    case sort
    when "name"
      order(name: :asc)
    when "name_desc"
      order(name: :desc)
    when "prep_time"
      order(prep_time: :asc)
    when "prep_time_desc"
      order(prep_time: :desc)
    when "cook_time"
      order(cook_time: :asc)
    when "cook_time_desc"
      order(cook_time: :desc)
    when "total_time"
      order(total_time: :asc)
    when "total_time_desc"
      order(total_time: :desc)
    when "serving_for"
      order(serving_for: :asc)
    when "serving_for_desc"
      order(serving_for: :desc)
    when "ingredients_count"
      order(ingredients_count: :asc)
    when "ingredients_count_desc"
      order(ingredients_count: :desc)
    else
      all
    end
  end

  def self.total_bookmarks
    bookmark.count
  end

  def self.total_completed
    completed.count
  end

  def self.total_ingredients
    joins(:ingredients).count
  end

  def self.total_groceries
    joins(:groceries).count
  end

  def self.total_ingredient_items
    joins(:ingredients).sum(:quantity)
  end

  def self.total_ingredient_items_purchased
    joins(:ingredients).where("ingredients.purchased_at IS NOT NULL").sum(:quantity)
  end

  def self.total_ingredient_items_unpurchased
    joins(:ingredients).where("ingredients.purchased_at IS NULL").sum(:quantity)
  end

  def self.total_ingredient_items_purchased_percentage
    total_ingredient_items_purchased.to_f
      .div(total_ingredient_items.to_f)
      .div(100)
  end

  def bookmarked?
    bookmark
  end

  def completed?
    completed_at.present?
  end
end

