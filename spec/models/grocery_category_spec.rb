require "rails_helper"

RSpec.describe GroceryCategory, type: :model do
  describe "associations" do
    it { should have_many(:groceries).dependent(:destroy) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
  end
end