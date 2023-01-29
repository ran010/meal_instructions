class Meals::GenerateRecipesService < ApplicationService
  UNIT_TYPE = ["a teaspoon", "teaspoon", "tablespoon", "cup", "ounce", "pound", "cups", "can", "cans", "slice"].freeze

  attr_reader :meal, :prompt_message

  def initialize(meal)
    @meal = meal
    @prompt_message = "Recipe for #{meal.name} for #{meal.serving_for} people"
  end

  def call
    if meal_template.blank?
      begin
        recipes = ChatgptClient.new.create_completion(prompt_message)
        parsed_recipes = parse_recipes(recipes)
        create_meal_template(recipes)
        create_ingredients(parsed_recipes["Ingredients"])
        create_instructions(parsed_recipes["Instructions"])
      rescue => exception
        Rails.logger.error("Error while generating recipes: #{exception.message}")
        meal.errors.add(:base, "Something went wrong. Please try again later")
        return meal
      end
    end

    if meal_template.present?
      meal.update(meal_template: meal_template)
      Meals::CreateFromTemplateWorkflow.call({meal_template_id: meal_template.id}, meal)
    else
      meal.errors.add(:base, "No recipes found")
    end
  end

  private

  def parse_recipes(recipes)
    hash = Hash.new {|h,k| h[k] = [] }
    key = nil
    recipes.each do |val|
      if val.include?(":")
        key = val.gsub(":","")
        key = "Instructions" if key != "Ingredients"
      else
        hash[key] << val
      end
    end
    hash
  end

  def create_meal_template(recipes)
    payload = {
      prompt_message: prompt_message,
      recipes: recipes
    }.to_json
    @meal_template = MealTemplate.create(meal.attributes.slice("name","serving_for", "description", "prep_time", "cook_time","total_time").merge({payload: payload}))
  end

  def create_instructions(instructions)
    instructions.each.with_index do |instruction, index|
      description_with_position = instruction.scan(/\d+|\D+/)
      description = description_with_position.last.delete_prefix(". ")

      meal_template.instruction_template_steps.create!(
        full_description: instruction,
        description: description,
        position: description_with_position.first.to_i
      )
    end
  end

  def create_ingredients(ingredients)
    ingredients.each do |ingredient|
      unit_type = nil
      quantity, grocery_name = ingredient.partition(" ").reject(&:blank?)
      
      if is_unit_type_include?(ingredient)
        quantity, unit_type, grocery_name = ingredient.rpartition(/"#{UNIT_TYPE.join('|')}"|\(.*?-inch\)/)
      end

      grocery = Grocery.find_or_create_by!(name: grocery_name.split("of").last.strip)
      ingredient_template = meal_template.ingredient_templates.create!(
        grocery_id: grocery.id,
        quantity: quantity.split("-").last.strip.split(" ").first,
        unit_type: unit_type,
        notes: ingredient
      )
    rescue => exception
      meal.errors.add(:base, exception.message)
    end
  end

  def is_unit_type_include?(ingredient)
    /"#{UNIT_TYPE.join('|')}"/.match?(ingredient)
  end

  def meal_template
    @meal_template ||= MealTemplate.find_by(name: meal.name, serving_for: meal.serving_for)
  end
end
