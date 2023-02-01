class MealTemplatesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_meal_template, only: %i[ show edit update destroy ]

  def search
    @meal_templates = MealTemplate.filter_by(params[:q])
    render layout: false
  end

  def autocomplete
    @meal_templates = MealTemplate.filter_by(params[:q])
    render layout: false
  end

  private

  def set_meal_template
    @meal_template = MealTemplate.find(params[:id])
  end
end
