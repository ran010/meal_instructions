FactoryBot.define do
  factory :ingredient_template do
    quantity { "1" }
    unit_type { "cup" }
    notes { "MyText" }
    grocery
    meal_template
  end
end
