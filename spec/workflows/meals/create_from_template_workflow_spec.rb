require "rails_helper"

RSpec.describe Meals::CreateFromTemplateWorkflow do
  let(:meal_template) { create(:meal_template) }
  let(:user) { create(:user) }
  let(:params) {
     {
      name: "Spaghetti Bolognese",
      description: "Spaghetti Bolognese",
      serving_for: 2,
      meal_template_id: meal_template.id,
      user: user
    }
  }

  context "when meal is valid" do
    it "creates meal" do
      meal = described_class.call(params)
      expect(meal.errors.blank?).to eq(true)
      expect(meal.ingredients.count).to eq(meal.meal_template.ingredient_templates.count)
      expect(meal.instruction_steps.count).to eq(meal.meal_template.instruction_template_steps.count)
    end
  end

  context "when meal is not valid" do
    let(:user) { nil }
    it "does creates meal" do
      meal = described_class.call(params)
      expect(meal.errors.blank?).to eq(false)
    end
  end
end
