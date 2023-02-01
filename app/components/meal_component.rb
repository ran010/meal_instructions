# frozen_string_literal: true

class MealComponent < ViewComponent::Base
  include ApplicationHelper
  with_collection_parameter :meal

  def initialize(meal:)
    @meal = meal
  end
end
