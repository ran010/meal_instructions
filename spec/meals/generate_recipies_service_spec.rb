require "rails_helper"

RSpec.describe Meals::GenerateRecipesService do
  let(:user) { create(:user) }
  let(:name) { 'Pizza' }
  let(:meal) { create(:meal, user: user, name: name) }
  let(:chatgpt_client) { double("OpenAI::Client") }
  before {
    chatgpt_client
    allow(ChatgptClient).to receive(:new).and_return(chatgpt_client)
  }

  context "when openapi is success" do
    context "and meal template is not found" do
      it "will generate recipe for meal" do
        result_complete = "Ingredients:\n-1/2 pound spaghetti\n-1/2 pound ground beef\n-1/2 onion, diced\n-1 garlic clove, minced\n-1/2 can diced tomatoes\n-1/4 cup tomato paste\n-1/2 teaspoon salt\n-1/4 teaspoon black pepper\n-1/4 teaspoon dried oregano\n-1/4 teaspoon dried thyme\n-1/2 cup beef broth\n-1/4 cup grated Parmesan cheese\nInstructions:\n1. In a large pot of boiling water, cook the spaghetti according to package instructions.\n2. In a large skillet over medium-high heat, cook the ground beef until browned. Add the onion and garlic and cook until softened.\n3. Add the diced tomatoes, tomato paste, salt, black pepper, oregano, thyme, and beef broth. Simmer for 15 minutes.\n4. Drain the spaghetti and add it to the skillet with the Bolognese sauce. Toss to combine.\n5. Serve with the Parmesan cheese."
    
        allow(chatgpt_client).to receive(:create_completion).and_return(result_complete.split("\n"))
        
        described_class.call(meal)
    
        expect(MealTemplate.count).to eq(1)
        expect(meal.ingredients.count).not_to eq(0)
        expect(meal.ingredients.count).to eq(MealTemplate.first.ingredient_templates.count)
      end
    end
   
    context "meal template is already created" do
      let(:name) {"Spaghetti Bolognese" }
      let(:meal_template) { create(:meal_template, :with_ingredients, name: name) }

      it "generate existed recipe" do
       [meal_template, meal]
        
        described_class.call(meal)
        expect(MealTemplate.count).to eq(1)
        expect(meal.ingredients.count).to eq(meal_template.ingredient_templates.count)
      end
    end
  end
  
  context "when openapi is failed" do
    let(:name) { "Tuna Salad" }
    
    it "should return error when request to openapi failed" do
      result_complete = nil
      allow(chatgpt_client).to receive(:create_completion).and_return(result_complete)
      described_class.call(meal)
  
      expect(meal.meal_template).to eq(nil)
      expect(meal.errors.present?).to eq(true)
    end
  
    it "should return error when request to openapi return error" do
      allow(chatgpt_client).to receive(:create_completion).and_raise(IOError.new("openai api error"))
      described_class.call(meal)
  
      expect(meal.meal_template).to eq(nil)
      expect(meal.errors.present?).to eq(true)
      expect(meal.errors.full_messages).to eq(["Something went wrong. Please try again later"])
    end
  end
end
