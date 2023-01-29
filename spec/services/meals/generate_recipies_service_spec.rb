require "rails_helper"

RSpec.describe Meals::GenerateRecipesService  do
  let(:meal) { create(:meal, name: 'Burger') }
  let(:recipes) { ["Ingredients:",
    "2 burger buns",
    "2 beef burgers",
    "1 slice of cheese",
    "2 tablespoons ketchup",
    "1 tablespoon mustard",
    "Instructions:",
    "1. Preheat the grill to medium-high heat.",
    "2. Grill the burgers for about 5 minutes per side, or until they are cooked to your liking.",
    "3. During the last minute of cooking, place a slice of cheese on each burger.",
    "4. Spread ketchup and mustard on the buns, and then place the burgers on the buns.",
    "5. Serve immediately."] }
    
    let(:chatgpt_client) { double("OpenAI::Client") }
    before {
      allow(ChatgptClient).to receive(:new).and_return(chatgpt_client)
      allow(chatgpt_client).to receive(:create_completion).and_return(recipes)
    }
    context "when meal template is blank" do
      it "creates new meal template" do
        subject = described_class.new(meal)
        expect {
          subject.call
        }.to change(MealTemplate, :count ).by(1)
         .and change(IngredientTemplate, :count ).by(5)
         .and change(InstructionTemplateStep, :count ).by(5)
        expect(meal.meal_template_id).to eq(MealTemplate.last.id)
      end
    end
    context "when meal template is present" do
      let!(:meal) { create(:meal, name: 'Tuna') }
      let!(:meal_template) { create(:meal_template, name: 'Tuna') }

      it "creates new meal template" do
        described_class.call(meal)
        expect(meal.meal_template_id).to eq(meal_template.id)
      end
    end
end
