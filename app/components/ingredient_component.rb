# frozen_string_literal: true

class IngredientComponent < ViewComponent::Base
  include ApplicationHelper
  with_collection_parameter :ingredient

  def initialize(ingredient:, meal:)
    @ingredient = ingredient
    @meal = meal
  end
end
