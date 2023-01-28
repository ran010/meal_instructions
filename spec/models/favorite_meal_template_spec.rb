require "rails_helper"

RSpec.describe FavoriteMealTemplate, type: :model do
  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:meal_template) }
  end

  describe "validations" do
    let!(:user) { create(:user) }
    let!(:meal_template) { create(:meal_template) }
    let!(:favorite_meal_template) { create(:favorite_meal_template, user: user, meal_template: meal_template) }

    it { should validate_uniqueness_of(:user_id).scoped_to([:meal_template_id]) }
  end
end
