# frozen_string_literal: true

class FavoriteMealTemplateComponent < ViewComponent::Base
  include ApplicationHelper

  def initialize(meal_template:, current_user:)
    @meal_template = meal_template
    @current_user = current_user
  end

  def favorite_meal_template
    @current_user.favorite_meal_template(@meal_template.id)
  end
end
