# frozen_string_literal: true

class MealTemplateComponent < ViewComponent::Base
  include ApplicationHelper
  with_collection_parameter :meal_template

  def initialize(meal_template:, current_user:)
    @meal_template = meal_template
    @current_user = current_user
  end

  def render?
    @meal_template.present?
  end
end
