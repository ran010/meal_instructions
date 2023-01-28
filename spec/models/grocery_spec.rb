require "rails_helper"

RSpec.describe Grocery, type: :model do
  describe "associations" do
    it { should belong_to(:grocery_category).without_validating_presence }
    it { should have_many(:ingredients).dependent(:destroy) }
    it { should have_many(:meals).through(:ingredients) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }

    it "validates presense of name" do
      grocery = build(:grocery, barcode: nil, name: nil)
      expect(grocery.valid?).to eq(false)
      grocery.name = "test"
      expect(grocery.valid?).to eq(true)
      grocery.barcode = "1234"
      expect(grocery.valid?).to eq(true)
    end
    it "validates presense of barcode" do
      grocery = build(:grocery, barcode: nil, name: nil)
      expect(grocery.valid?).to eq(false)
      grocery.barcode = "1234"
      expect(grocery.valid?).to eq(true)
      grocery.name = "test"
      expect(grocery.valid?).to eq(true)
    end
  end
end
