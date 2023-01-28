require "rails_helper"

RSpec.describe Grocery::CreateWorkflow do
  let(:barcode) { "123456789" }
  let(:title) { "Milk" }
  let(:image_data) { "image.com" }
  let(:category) { "Dairy" }
  let(:description) { "description" }
  before(:each) do
    barcode_response = {
      products: [
        {
          barcode_number: barcode,
          title: title,
          category: "Grocery > #{category}",
          description: description,
          images: [image_data]
        }
      ]

    }
    stub_request(:get, "https://api.barcodelookup.com/v3/products?barcode=#{barcode}&key=")
      .to_return(status: 200, body: barcode_response.to_json)
  end

  context "when barcode data is present" do
    it "creates grocery" do
      expect { described_class.call({barcode: barcode}) }.to change(Grocery, :count).by(1)
      grocery = Grocery.last
      expect(grocery.barcode).to eq(barcode)
      expect(grocery.name).to eq(title)
      expect(grocery.image_data).to eq(image_data)
      expect(grocery.grocery_category.name).to eq(category)
      expect(grocery.notes).to eq(description)
    end
  end
  context "when barcode data is not present" do
    it "does not create grocery" do
      stub_request(:get, "https://api.barcodelookup.com/v3/products?barcode=123&key=")
        .to_return(status: 404, body: "")
      grocery = described_class.call({barcode: "123"})
      expect(grocery.persisted?).to be(false)
      expect(grocery.errors.full_messages).to eq(["Barcode product not found"])
    end
  end

  context "when name params contain name" do
    it "creates grocery" do
      expect { described_class.call({name: "Flour"}) }.to change(Grocery, :count).by(1)
      grocery = Grocery.last
      expect(grocery.name).to eq("Flour")
      expect(grocery.barcode).to eq(nil)
      expect(grocery.image_data).to eq(nil)
      expect(grocery.grocery_category.name).to eq("Other")
    end
  end
end
