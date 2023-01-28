require "rails_helper"

RSpec.describe Ingredient, type: :model do
  describe "associations" do
    it { should belong_to(:grocery) }
    it { should belong_to(:meal) }
  end
end