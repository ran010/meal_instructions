class GroceryCategory < ApplicationRecord
  has_many :groceries, dependent: :destroy

  validates :name, presence: true, uniqueness: true

  def self.search(search)
    if search
      where("name LIKE ?", "%#{search}%")
    else
      all
    end
  end
end

