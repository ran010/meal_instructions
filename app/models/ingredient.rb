class Ingredient < ApplicationRecord
  belongs_to :grocery
  belongs_to :meal, counter_cache: true

  accepts_nested_attributes_for :grocery, reject_if: ->(attributes) { attributes["name"].blank? }, allow_destroy: true

  validates :quantity, presence: true

  delegate :grocery_category, to: :grocery

  scope :purchased, -> { where.not(purchased_at: nil) }
  scope :not_purchased, -> { where(purchased_at: nil) }

  def purchased?
    purchased_at.present?
  end
end

