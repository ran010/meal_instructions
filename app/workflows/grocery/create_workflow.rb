class Grocery::CreateWorkflow < ApplicationWorkflow
  attr_reader :params

  def initialize(params)
    @params = params
  end

  def call
    if params[:barcode].present?
      uri = URI("https://api.barcodelookup.com/v3/products?barcode=#{params[:barcode]}&key=#{barcode_lookup_credential}")
      begin
        res = JSON.parse(Net::HTTP.get(uri))
        product = res["products"][0]
        name = product["title"]
        notes = product["description"]
        image_data = product["images"].first
        category = (product["category"].split(" >") || []).last&.strip
        grocery_category = GroceryCategory.find_or_create_by(name: category) if category.present?
        grocery.update(name: name, notes: notes, image_data: image_data, grocery_category: grocery_category || @grocery.grocery_category, payload: res)
      rescue => e
        Rails.logger.error e.message
        grocery.errors.add(:barcode, "product not found")
        grocery
      end
    else
      grocery.save
    end
    grocery
  end

  private

  def grocery
    @grocery ||= Grocery.find_or_initialize_by(params)
  end

  def barcode_lookup_credential
    Rails.application.credentials.barcode_lookup
  end
end
