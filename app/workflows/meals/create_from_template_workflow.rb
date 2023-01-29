class Meals::CreateFromTemplateWorkflow < ApplicationWorkflow
  attr_reader :params, :meal_template
  attr_accessor :meal

  def initialize(params, meal = nil)
    @params = params
    @meal = meal
    @meal_template = MealTemplate.find(params[:meal_template_id])
  end

  def call
    if meal.valid?
      begin
        create_ingredients
        create_instructions
      rescue => exception
        meal.errors.add(:base, exception.message)
      end
    end
    meal
  end

  private

  def meal
    @meal ||= Meal.create(params.merge!(name: meal_template.name, serving_for: meal_template.serving_for))
  end

  def create_ingredients
    meal_template.ingredient_templates.each do |ingredient|
      meal.ingredients.create!(ingredient.attributes.slice("quantity","unit_type", "grocery_id", "notes"))
    end
  end

  def create_instructions 
    meal_template.instruction_template_steps.each do |instruction|
      meal.instruction_steps.create!(ingredient.attributes.slice("description","full_description", "position"))
    end
  end
end
