class Grocery < ApplicationRecord
  belongs_to :grocery_category

  has_many :ingredients, dependent: :destroy
  has_many :meals, through: :ingredients
  has_many :ingredient_templates, dependent: :destroy
  has_many :meal_templates, through: :ingredient_templates

  validates :name, presence: true, uniqueness: true, if: proc { |a| a.barcode.blank? }
  validates :barcode, presence: true, uniqueness: true, if: proc { |a| a.name.blank? }

  accepts_nested_attributes_for :grocery_category, reject_if: ->(attributes) { attributes["name"].blank? }, allow_destroy: true

  before_validation do
    if grocery_category_id.blank?
      grocery_category = GroceryCategory.find_or_create_by(name: "Other")
      self.grocery_category_id = grocery_category.id
    end
  end

  def self.search(search)
    if search
      where("lower(name) LIKE ?", "%#{search.downcase}%")
    else
      all
    end
  end

  def self.by_category(category)
    joins(:grocery_category).where(grocery_categories: {name: category})
  end

  def self.by_category_id(category_id)
    joins(:grocery_category).where(grocery_categories: {id: category_id})
  end

  def self.by_category_name(category_name)
    joins(:grocery_category).where(grocery_categories: {name: category_name})
  end

  def self.by_category_name_and_search(category_name, search)
    joins(:grocery_category).where(grocery_categories: {name: category_name}).where("name LIKE ?", "%#{search}%")
  end

  def self.by_category_id_and_search(category_id, search)
    joins(:grocery_category).where(grocery_categories: {id: category_id}).where("name LIKE ?", "%#{search}%")
  end
end

